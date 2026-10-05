import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/generated/app_localizations.dart';
import '../media/image_picker_provider.dart';
import '../theme/app_spacing.dart';
import 'submit_state.dart';

/// Up to [max] photos from the camera or gallery, shown as removable thumbnails.
/// Holds file paths; the form uploads them when it is sent.
class PhotoPickerField extends ConsumerWidget {
  const PhotoPickerField({super.key, required this.paths, required this.onChanged, this.max = 5, this.enabled = true});

  final List<String> paths;
  final ValueChanged<List<String>> onChanged;
  final int max;
  final bool enabled;

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l10n.photoCamera),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.photoGallery),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    try {
      final file = await ref
          .read(imagePickerProvider)
          .pickImage(source: source, maxWidth: 1600, maxHeight: 1600, imageQuality: 85);
      if (file != null) onChanged([...paths, file.path]);
    } on PlatformException {
      if (context.mounted) showSnack(context, l10n.captureCameraFailed);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.fieldPhotos, style: theme.textTheme.titleSmall),
        Text(l10n.photosLimit(max), style: theme.textTheme.bodySmall),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final (i, path) in paths.indexed)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(File(path), width: 88, height: 88, fit: BoxFit.cover, cacheWidth: 176),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton.filledTonal(
                      visualDensity: VisualDensity.compact,
                      tooltip: l10n.commonRemove,
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: enabled ? () => onChanged([...paths]..removeAt(i)) : null,
                    ),
                  ),
                ],
              ),
            if (paths.length < max)
              SizedBox.square(
                dimension: 88,
                child: OutlinedButton(
                  onPressed: enabled ? () => _add(context, ref) : null,
                  style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add_a_photo_outlined),
                      Text(l10n.photosAdd, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
