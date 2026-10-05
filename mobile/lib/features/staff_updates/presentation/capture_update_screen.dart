import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/location/location_messages.dart';
import '../../../core/location/location_service.dart';
import '../../../core/media/image_picker_provider.dart';
import '../../../core/models/enums.dart';
import '../../../core/network/error_messages.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/time/server_clock.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/inline_message.dart';
import '../../../core/widgets/submit_state.dart';
import '../../auth/presentation/session_controller.dart';
import '../data/staff_updates_repository.dart';
import '../data/update_queue.dart';

/// Photo, description and location for one slot. The update is saved on the
/// phone first and then sent, so a lost connection never loses it.
class CaptureUpdateScreen extends ConsumerStatefulWidget {
  const CaptureUpdateScreen({super.key, required this.slot});

  final TimeSlot slot;

  @override
  ConsumerState<CaptureUpdateScreen> createState() => _CaptureUpdateScreenState();
}

class _CaptureUpdateScreenState extends ConsumerState<CaptureUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _description = TextEditingController();
  XFile? _photo;
  var _source = PhotoSource.camera;
  DateTime? _capturedAt;
  late Future<LocationResult> _location;
  LocationResult? _located;
  var _sending = false;
  double? _progress;
  String? _error;

  @override
  void initState() {
    super.initState();
    _location = _locate();
    WidgetsBinding.instance.addPostFrameCallback((_) => _recoverOrCapture());
  }

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  Future<LocationResult> _locate() async {
    final rules = ref.read(staffTodayProvider).value?.rules;
    final result = await ref
        .read(locationServiceProvider)
        .current(timeout: Duration(seconds: rules?.fixTimeoutSeconds ?? 10));
    if (mounted) setState(() => _located = result);
    return result;
  }

  /// Android may close the app while the camera is open; the photo taken
  /// then is recovered here instead of asking again.
  Future<void> _recoverOrCapture() async {
    final picker = ref.read(imagePickerProvider);
    if (Platform.isAndroid) {
      try {
        final lost = await picker.retrieveLostData();
        final file = lost.file;
        if (!lost.isEmpty && file != null) {
          _usePhoto(file, PhotoSource.camera);
          return;
        }
      } on PlatformException {
        // Nothing to recover.
      }
    }
    await _take(ImageSource.camera);
  }

  Future<void> _take(ImageSource source) async {
    final l10n = AppLocalizations.of(context);
    try {
      final file = await ref
          .read(imagePickerProvider)
          .pickImage(
            source: source,
            maxWidth: 1600,
            maxHeight: 1600,
            imageQuality: 85,
            preferredCameraDevice: CameraDevice.rear,
          );
      if (file != null) _usePhoto(file, source == ImageSource.camera ? PhotoSource.camera : PhotoSource.gallery);
    } on PlatformException {
      if (mounted) showSnack(context, l10n.captureCameraFailed);
    }
  }

  void _usePhoto(XFile file, PhotoSource source) {
    if (!mounted) return;
    setState(() {
      _photo = file;
      _source = source;
      // The server judges the slot by its own clock; record that time.
      _capturedAt = ref.read(serverClockProvider.notifier).now();
      _error = null;
    });
  }

  Future<void> _send() async {
    final l10n = AppLocalizations.of(context);
    final photo = _photo;
    if (photo == null) {
      setState(() => _error = l10n.capturePhotoRequired);
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    final session = ref.read(sessionProvider).value;
    if (session == null) return;
    setState(() {
      _sending = true;
      _progress = null;
      _error = null;
    });
    final queue = ref.read(updateQueueProvider.notifier);
    final capturedAt = _capturedAt!;
    final saved = await queue.add(
      userId: session.userId,
      slot: widget.slot,
      workDate: ref.read(staffTodayProvider).value?.date ?? isoDate(capturedAt),
      description: _description.text.trim(),
      capturedAt: capturedAt,
      photoSource: _source,
      location: (await _location).toApiFields(),
      photoPath: photo.path,
    );
    final result = await queue.send(
      saved.id,
      onSendProgress: (sent, total) {
        if (mounted && total > 0) setState(() => _progress = sent / total);
      },
    );
    if (!mounted) return;
    switch (result.outcome) {
      case SendOutcome.sent:
        showSnack(context, l10n.captureSent(widget.slot.label(l10n)));
        context.pop();
      case SendOutcome.queued:
        showSnack(context, l10n.captureQueued);
        context.pop();
      case SendOutcome.rejected:
        // Shown here, so the copy on the phone isn't needed: the next send saves a fresh one.
        await queue.discard(saved.id);
        setState(() {
          _sending = false;
          _error = result.error!.userMessage(l10n);
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final allowGallery = ref.watch(staffTodayProvider).value?.rules.allowGallery ?? true;
    final photo = _photo;
    return PopScope(
      canPop: !_sending,
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.captureTitle(widget.slot.label(l10n)))),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: ColoredBox(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: photo == null
                        ? Center(
                            child: FilledButton.tonalIcon(
                              onPressed: _sending ? null : () => _take(ImageSource.camera),
                              icon: const Icon(Icons.photo_camera_outlined),
                              label: Text(l10n.slotTakePhoto),
                            ),
                          )
                        : Image.file(File(photo.path), fit: BoxFit.cover, cacheWidth: 1200),
                  ),
                ),
              ),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  if (photo != null)
                    TextButton.icon(
                      onPressed: _sending ? null : () => _take(ImageSource.camera),
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.captureRetake),
                    ),
                  if (allowGallery)
                    TextButton.icon(
                      onPressed: _sending ? null : () => _take(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: Text(l10n.captureFromGallery),
                    ),
                ],
              ),
              if (_source == PhotoSource.gallery && photo != null)
                InlineMessage(message: l10n.captureGalleryNote, tone: StatusTone.warning),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _description,
                enabled: !_sending,
                minLines: 3,
                maxLines: 6,
                maxLength: 1000,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: l10n.captureDescriptionLabel,
                  hintText: l10n.captureDescriptionHint,
                  alignLabelWithHint: true,
                ),
                validator: (value) => (value?.trim().length ?? 0) < 3 ? l10n.captureDescriptionTooShort : null,
              ),
              _LocationLine(result: _located),
              if (_error != null) ...[const SizedBox(height: AppSpacing.md), InlineMessage(message: _error!)],
              const SizedBox(height: AppSpacing.lg),
              SubmitButton(
                label: _sending && _progress != null
                    ? l10n.captureSending((_progress! * 100).round())
                    : l10n.captureSend,
                busy: _sending && _progress == null,
                onPressed: _sending ? null : _send,
              ),
              if (_sending && _progress != null) ...[
                const SizedBox(height: AppSpacing.sm),
                LinearProgressIndicator(value: _progress),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Whether the update will carry a location, and what to do if it won't.
class _LocationLine extends ConsumerWidget {
  const _LocationLine({required this.result});

  final LocationResult? result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final result = this.result;
    final fix = result?.fix;
    final problem = result?.problem;
    final (IconData icon, String text, Color color) = switch (result) {
      null => (Icons.my_location, l10n.checkingLocation, theme.colorScheme.onSurfaceVariant),
      _ when fix != null && fix.isMocked => (
        Icons.wrong_location_outlined,
        l10n.locationMocked,
        theme.colorScheme.error,
      ),
      _ when fix != null && fix.approximate => (
        Icons.location_searching,
        l10n.locationApproximate,
        context.tone(StatusTone.warning).foreground,
      ),
      _ when fix != null => (
        Icons.location_on_outlined,
        l10n.captureLocationFound(fix.accuracyM.round()),
        context.tone(StatusTone.success).foreground,
      ),
      _ => (
        Icons.location_off_outlined,
        '${problem!.message(l10n)} ${l10n.captureLocationMarked}',
        context.tone(StatusTone.warning).foreground,
      ),
    };
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(text, style: theme.textTheme.bodySmall?.copyWith(color: color)),
          ),
          if (problem != null && problem.hasSettings)
            TextButton(
              onPressed: () => ref.read(locationServiceProvider).openSettingsFor(problem),
              child: Text(l10n.commonOpenSettings),
            )
          else if (fix != null && fix.approximate && !fix.isMocked)
            TextButton(
              onPressed: () => ref.read(locationServiceProvider).openAppSettings(),
              child: Text(l10n.commonOpenSettings),
            ),
        ],
      ),
    );
  }
}
