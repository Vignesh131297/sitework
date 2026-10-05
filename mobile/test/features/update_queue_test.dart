import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sitework/core/models/enums.dart';
import 'package:sitework/core/network/app_exception.dart';
import 'package:sitework/features/staff_updates/data/staff_updates_repository.dart';
import 'package:sitework/features/staff_updates/data/update_queue.dart';
import 'package:sitework/features/staff_updates/domain/pending_update.dart';
import 'package:sitework/features/staff_updates/domain/staff_update_models.dart';

import '../helpers/staff_fixtures.dart';

/// Answers submissions with whatever [answer] returns or throws.
class FakeSubmitRepository implements StaffUpdatesRepository {
  FakeSubmitRepository(this.answer);

  StaffUpdate Function(PendingUpdate update) answer;
  final submitted = <PendingUpdate>[];

  @override
  Future<StaffUpdate> submit(PendingUpdate update, {ProgressCallback? onSendProgress}) async {
    submitted.add(update);
    return answer(update);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(invocation.memberName.toString());
}

final accepted = StaffUpdate.fromJson(staffUpdateJson());
StaffUpdate refuse(String code) => throw ApiException(statusCode: 400, code: code, message: 'Refused: $code');

void main() {
  late Directory directory;
  late File photo;
  late FakeSubmitRepository repository;

  setUp(() {
    directory = Directory.systemTemp.createTempSync('sitework-queue-');
    photo = tinyPhoto();
    repository = FakeSubmitRepository((_) => accepted);
  });

  tearDown(() => directory.deleteSync(recursive: true));

  ProviderContainer container() {
    final c = ProviderContainer(
      overrides: [
        pendingUpdatesDirectoryProvider.overrideWith((ref) => directory),
        staffUpdatesRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  Future<PendingUpdate> add(ProviderContainer c, {String userId = 'staff-1', TimeSlot slot = TimeSlot.morning}) => c
      .read(updateQueueProvider.notifier)
      .add(
        userId: userId,
        slot: slot,
        workDate: '2026-10-05',
        description: 'Plastering',
        capturedAt: DateTime.utc(2026, 10, 5, 5, 10),
        photoSource: PhotoSource.camera,
        location: const {'latitude': 13.08, 'longitude': 80.2, 'accuracyM': 12.0, 'isMocked': false},
        photoPath: photo.path,
      );

  List<String> files() => [for (final f in directory.listSync()) f.uri.pathSegments.last]..sort();

  test('saves the update with a copy of its photo, sends it, then forgets it', () async {
    final c = container();
    final item = await add(c);
    expect(files(), ['${item.id}.jpg', '${item.id}.json']);

    final result = await c.read(updateQueueProvider.notifier).send(item.id);

    expect(result.outcome, SendOutcome.sent);
    expect(repository.submitted.single.id, item.id);
    expect(files(), isEmpty);
    expect(c.read(updateQueueProvider).value, isEmpty);
    expect(photo.existsSync(), isTrue, reason: 'the original belongs to the camera app');
  });

  test('keeps the update waiting while offline and sends it on the next flush', () async {
    final c = container();
    repository.answer = (_) => throw const NetworkException();
    final item = await add(c);

    expect((await c.read(updateQueueProvider.notifier).send(item.id)).outcome, SendOutcome.queued);
    expect(c.read(updateQueueProvider).value!.single, isA<PendingUpdate>().having((i) => i.attempts, 'attempts', 1));

    repository.answer = (_) => accepted;
    await c.read(updateQueueProvider.notifier).flush('staff-1');
    expect(c.read(updateQueueProvider).value, isEmpty);
    expect(repository.submitted.map((u) => u.id), [item.id, item.id]);
  });

  test('marks refused updates failed with the reason, and retries on request', () async {
    final c = container();
    repository.answer = (_) => refuse('NOT_CHECKED_IN');
    final item = await add(c);

    final result = await c.read(updateQueueProvider.notifier).send(item.id);
    expect(result.outcome, SendOutcome.rejected);
    final failed = c.read(updateQueueProvider).value!.single;
    expect([failed.state, failed.errorCode], [PendingState.failed, 'NOT_CHECKED_IN']);

    // Flushing leaves failed updates alone; retry sends them again.
    await c.read(updateQueueProvider.notifier).flush('staff-1');
    expect(repository.submitted, hasLength(1));
    repository.answer = (_) => accepted;
    expect((await c.read(updateQueueProvider.notifier).retry(item.id)).outcome, SendOutcome.sent);
    expect(files(), isEmpty);
  });

  test('drops a copy the server can never accept because the slot is done', () async {
    final c = container();
    repository.answer = (_) => refuse('UPDATE_ALREADY_SUBMITTED');
    final item = await add(c);
    await c.read(updateQueueProvider.notifier).send(item.id);
    expect(files(), isEmpty);
  });

  test('survives a restart; an interrupted send waits again', () async {
    final first = container();
    final item = await add(first);
    // The app was killed while this one was being sent.
    final record = File('${directory.path}${Platform.pathSeparator}${item.id}.json');
    final json = jsonDecode(record.readAsStringSync()) as Map<String, dynamic>;
    record.writeAsStringSync(jsonEncode({...json, 'state': 'sending'}));

    final restarted = container();
    final loaded = await restarted.read(updateQueueProvider.future);
    expect(loaded.single, isA<PendingUpdate>().having((i) => i.state, 'state', PendingState.waiting));
    expect(loaded.single.location['latitude'], 13.08);
  });

  test('only sends the signed-in user’s updates, and stops at the first connection failure', () async {
    final c = container();
    await add(c, userId: 'someone-else');
    final morning = await add(c);
    final afternoon = await add(c, slot: TimeSlot.afternoon);
    repository.answer = (_) => throw const NetworkException();

    await c.read(updateQueueProvider.notifier).flush('staff-1');

    expect(repository.submitted.map((u) => u.id), [morning.id]);
    expect(c.read(updateQueueProvider).value!.map((i) => i.id), containsAll([morning.id, afternoon.id]));
  });

  test('server trouble and lost connections are temporary; refusals are not', () {
    expect(isTemporary(const NetworkException()), isTrue);
    expect(isTemporary(const ApiException(statusCode: 503, code: 'SERVICE_UNAVAILABLE')), isTrue);
    expect(isTemporary(const ApiException(statusCode: 429, code: 'RATE_LIMITED')), isTrue);
    expect(isTemporary(const ApiException(statusCode: 409, code: 'UPDATE_ALREADY_SUBMITTED')), isFalse);
    expect(isTemporary(const ApiException(statusCode: 400, code: 'SLOT_CLOSED')), isFalse);
  });
}
