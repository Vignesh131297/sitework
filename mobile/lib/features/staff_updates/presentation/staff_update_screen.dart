import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/enums.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/network/image_loader.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/network_photo.dart';
import '../../../core/widgets/status_chip.dart';
import '../../auth/domain/user_role.dart';
import '../../auth/presentation/session_controller.dart';
import '../data/staff_updates_repository.dart';
import '../domain/staff_update_models.dart';
import 'update_tile.dart';

/// The photo's signed link. Kept per screen visit, not reloaded with the update.
final imageLinkProvider = FutureProvider.autoDispose.family<ImageLink, String>(
  (ref, id) => ref.watch(staffUpdatesRepositoryProvider).imageLink(id),
);

/// One staff update with its photo. Showing the photo to an admin or the
/// responsible engineer records their review; once both have seen it the
/// server deletes the photo after a short grace period.
class StaffUpdateScreen extends ConsumerStatefulWidget {
  const StaffUpdateScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<StaffUpdateScreen> createState() => _StaffUpdateScreenState();
}

class _StaffUpdateScreenState extends ConsumerState<StaffUpdateScreen> {
  var _recorded = false;

  Future<void> _recordView() async {
    final role = ref.read(sessionProvider).value?.role;
    if (_recorded || role == null || role == UserRole.staff) return;
    _recorded = true;
    try {
      await ref.read(staffUpdatesRepositoryProvider).recordView(widget.id);
      ref.bump(DataSet.staffUpdates);
    } on AppException {
      // The next time they open it, the view is recorded then.
      _recorded = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final update = ref.watch(staffUpdateProvider(widget.id));
    final link = ref.watch(imageLinkProvider(widget.id));
    // Recorded once the photo itself is on screen, not when the link arrives.
    final url = link.value?.url;
    if (url != null && ref.watch(imageBytesProvider(url)).hasValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _recordView());
    }
    final loaded = update.value;
    return Scaffold(
      appBar: AppBar(
        title: Text(loaded == null ? '' : l10n.photoViewerTitle(loaded.staff.name, loaded.slot.label(l10n))),
      ),
      body: AsyncValueView(
        value: update,
        onRetry: () => ref.invalidate(staffUpdateProvider(widget.id)),
        data: (update) => ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: ColoredBox(
                color: Colors.black,
                child: link.when(
                  data: (link) => GestureDetector(
                    onTap: () => PhotoGalleryPage.open(context, [link.url]),
                    child: NetworkPhoto(url: link.url, fit: BoxFit.contain),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, _) =>
                      _PhotoUnavailable(deleted: error is ApiException && error.code == 'IMAGE_DELETED'),
                ),
              ),
            ),
            _Details(update: update),
          ],
        ),
      ),
    );
  }
}

class _PhotoUnavailable extends StatelessWidget {
  const _PhotoUnavailable({required this.deleted});

  final bool deleted;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Theme(
      data: ThemeData.dark(),
      child: EmptyState(
        icon: deleted ? Icons.hide_image_outlined : Icons.broken_image_outlined,
        title: deleted ? l10n.photoDeleted : l10n.photoLoadFailed,
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.update});

  final StaffUpdate update;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final u = update;
    final distance = u.location.distanceFromSiteM;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(u.description, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            [
              u.site.name,
              formatShortDate(DateTime.parse(u.workDate)),
              l10n.updateTakenAt(formatTime(u.capturedAt)),
              l10n.updateSentAt(formatTime(u.submittedAt)),
            ].join(' · '),
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              StatusChip(
                label: [u.location.flag.label(l10n), if (distance != null) l10n.updateDistance(distance)].join(' · '),
                tone: u.location.flag.tone,
                icon: Icons.location_on_outlined,
              ),
              if (u.submittedOffline) StatusChip(label: l10n.slotSentOffline, tone: StatusTone.neutral),
              if (u.photoSource == PhotoSource.gallery)
                StatusChip(label: l10n.photoFromGallery, tone: StatusTone.warning),
              StatusChip(label: photoStatusText(u.image, l10n), tone: StatusTone.info),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _ReviewLine(
            done: u.engineerViewedAt != null,
            doneText: l10n.reviewEngineerDone,
            pendingText: l10n.reviewEngineerPending,
            name: u.engineer.name,
          ),
          _ReviewLine(
            done: u.adminViewedAt != null,
            doneText: l10n.reviewAdminDone,
            pendingText: l10n.reviewAdminPending,
          ),
        ],
      ),
    );
  }
}

class _ReviewLine extends StatelessWidget {
  const _ReviewLine({required this.done, required this.doneText, required this.pendingText, this.name});

  final bool done;
  final String doneText;
  final String pendingText;
  final String? name;

  @override
  Widget build(BuildContext context) {
    final colors = context.tone(done ? StatusTone.success : StatusTone.neutral);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Icon(done ? Icons.check_circle : Icons.radio_button_unchecked, size: 18, color: colors.foreground),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text([done ? doneText : pendingText, ?name].join(' · '))),
        ],
      ),
    );
  }
}
