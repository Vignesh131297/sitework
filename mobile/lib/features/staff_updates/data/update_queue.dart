import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../core/data/revision.dart';
import '../../../core/models/enums.dart';
import '../../../core/network/app_exception.dart';
import '../domain/pending_update.dart';
import '../domain/staff_update_models.dart';
import 'staff_updates_repository.dart';

/// Where saved updates and their photos live (app-private storage).
final pendingUpdatesDirectoryProvider = FutureProvider<Directory>((ref) async {
  final documents = await getApplicationDocumentsDirectory();
  return Directory('${documents.path}${Platform.pathSeparator}pending_updates')..createSync(recursive: true);
});

enum SendOutcome { sent, queued, rejected }

class SendResult {
  const SendResult.sent(StaffUpdate this.update) : outcome = SendOutcome.sent, error = null;
  const SendResult.queued(this.error) : outcome = SendOutcome.queued, update = null;
  const SendResult.rejected(AppException this.error) : outcome = SendOutcome.rejected, update = null;

  final SendOutcome outcome;
  final StaffUpdate? update;
  final AppException? error;
}

/// Updates waiting to reach the server. Every update is saved here first and
/// sent from here, so a dropped connection or a closed app never loses one:
/// it goes out on the next flush (app start, resume, a timer, or a retry).
///
/// File access is synchronous on purpose: the files are tiny (a JSON record and
/// a compressed photo), and finishing each write before moving on keeps the
/// saved state exact even if the app is killed.
class UpdateQueue extends AsyncNotifier<List<PendingUpdate>> {
  late Directory _directory;
  var _flushing = false;

  @override
  Future<List<PendingUpdate>> build() async {
    _directory = await ref.watch(pendingUpdatesDirectoryProvider.future);
    final items = <PendingUpdate>[];
    final entities = _directory.listSync();
    final records = {
      for (final e in entities)
        if (e.path.endsWith('.json')) e.path.substring(0, e.path.length - 5),
    };
    for (final entity in entities) {
      // A photo whose record is gone was sent; its delete failed earlier.
      if (entity is File &&
          entity.path.endsWith('.jpg') &&
          !records.contains(entity.path.substring(0, entity.path.length - 4))) {
        _tryDelete(entity);
        continue;
      }
      if (entity is! File || !entity.path.endsWith('.json')) continue;
      try {
        final item = PendingUpdate.fromJson(jsonDecode(entity.readAsStringSync()) as Map<String, dynamic>);
        // An app killed mid-upload leaves "sending"; the server dedupes a resend.
        items.add(item.state == PendingState.sending ? item.copyWith(state: PendingState.waiting) : item);
      } on Object catch (error) {
        debugPrint('Skipping unreadable saved update ${entity.path}: $error');
      }
    }
    items.sort((a, b) => a.capturedAt.compareTo(b.capturedAt));
    return items;
  }

  List<PendingUpdate> get _items => state.value ?? const [];

  /// Saves a new update with a copy of its photo. The id doubles as the
  /// clientSubmissionId, so sending it twice never creates two updates.
  Future<PendingUpdate> add({
    required String userId,
    required TimeSlot slot,
    required String workDate,
    required String description,
    required DateTime capturedAt,
    required PhotoSource photoSource,
    required Map<String, Object> location,
    required String photoPath,
  }) async {
    await future;
    final id = const Uuid().v4();
    final photo = File(photoPath).copySync(_path(id, 'jpg'));
    final item = PendingUpdate(
      id: id,
      userId: userId,
      slot: slot,
      workDate: workDate,
      description: description,
      capturedAt: capturedAt,
      photoSource: photoSource,
      location: location,
      photoPath: photo.path,
    );
    await _save(item);
    return item;
  }

  /// Sends one update now. Connection problems leave it waiting; a refusal
  /// from the server marks it failed with the reason.
  Future<SendResult> send(String id, {ProgressCallback? onSendProgress}) async {
    await future;
    final item = _items.where((i) => i.id == id).firstOrNull;
    if (item == null) return SendResult.queued(null);
    await _save(item.copyWith(state: PendingState.sending, errorCode: null, errorMessage: null));
    try {
      final update = await ref.read(staffUpdatesRepositoryProvider).submit(item, onSendProgress: onSendProgress);
      await _delete(item);
      ref
        ..bump(DataSet.staffUpdates)
        ..bump(DataSet.notifications);
      return SendResult.sent(update);
    } on AppException catch (error) {
      if (isTemporary(error)) {
        await _save(item.copyWith(state: PendingState.waiting, attempts: item.attempts + 1));
        return SendResult.queued(error);
      }
      if (error is ApiException && error.code == 'UPDATE_ALREADY_SUBMITTED') {
        // The slot already has an update; this copy can never be used.
        await _delete(item);
      } else {
        await _save(
          item.copyWith(
            state: PendingState.failed,
            attempts: item.attempts + 1,
            errorCode: error is ApiException ? error.code : null,
            errorMessage: error is ApiException ? error.message : null,
          ),
        );
      }
      return SendResult.rejected(error);
    }
  }

  /// Sends everything [userId] has waiting, oldest first; stops at the first
  /// connection problem (the rest would fail the same way).
  Future<void> flush(String userId) async {
    if (_flushing) return;
    _flushing = true;
    try {
      await future;
      for (final item in [..._items]) {
        if (item.userId != userId || item.state != PendingState.waiting) continue;
        if ((await send(item.id)).outcome == SendOutcome.queued) break;
      }
    } finally {
      _flushing = false;
    }
  }

  /// A failed update goes back to waiting and is tried at once.
  Future<SendResult> retry(String id) async {
    await future;
    final item = _items.where((i) => i.id == id).firstOrNull;
    if (item == null) return SendResult.queued(null);
    await _save(item.copyWith(state: PendingState.waiting));
    return send(id);
  }

  Future<void> discard(String id) async {
    await future;
    final item = _items.where((i) => i.id == id).firstOrNull;
    if (item != null) await _delete(item);
  }

  String _path(String id, String extension) => '${_directory.path}${Platform.pathSeparator}$id.$extension';

  Future<void> _save(PendingUpdate item) async {
    File(_path(item.id, 'json')).writeAsStringSync(jsonEncode(item.toJson()), flush: true);
    state = AsyncData(
      [
        for (final existing in _items)
          if (existing.id != item.id) existing,
        item,
      ]..sort((a, b) => a.capturedAt.compareTo(b.capturedAt)),
    );
  }

  /// The record goes first: without it the update is never sent again, and a
  /// photo left behind (e.g. still open elsewhere) is removed on the next load.
  Future<void> _delete(PendingUpdate item) async {
    File(_path(item.id, 'json')).deleteSync();
    _tryDelete(File(item.photoPath));
    state = AsyncData([
      for (final existing in _items)
        if (existing.id != item.id) existing,
    ]);
  }
}

void _tryDelete(File file) {
  try {
    if (file.existsSync()) file.deleteSync();
  } on FileSystemException catch (error) {
    debugPrint('Could not delete ${file.path} yet: ${error.message}');
  }
}

/// Worth retrying later: no connection, or the server is busy or briefly down.
bool isTemporary(AppException error) => switch (error) {
  NetworkException() => true,
  ApiException(:final statusCode) => statusCode >= 500 || statusCode == 408 || statusCode == 429 || statusCode == 401,
  UnexpectedException() => false,
};

final updateQueueProvider = AsyncNotifierProvider<UpdateQueue, List<PendingUpdate>>(UpdateQueue.new);
