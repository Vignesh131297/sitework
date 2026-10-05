import 'package:material_ui/material_ui.dart';

import '../../features/engineer_updates/domain/engineer_update_models.dart';
import '../theme/app_spacing.dart';
import 'network_photo.dart';

/// Thumbnails of kept photos; tapping one opens them full screen.
class AttachmentStrip extends StatelessWidget {
  const AttachmentStrip({super.key, required this.attachments});

  final List<Attachment> attachments;

  @override
  Widget build(BuildContext context) {
    if (attachments.isEmpty) return const SizedBox.shrink();
    final urls = [for (final a in attachments) a.url];
    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: attachments.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => PhotoGalleryPage.open(context, urls, initialIndex: index),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox.square(
              dimension: 112,
              child: ColoredBox(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: NetworkPhoto(url: urls[index], cacheWidth: 224),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
