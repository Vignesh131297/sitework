import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/generated/app_localizations.dart';
import '../network/image_loader.dart';

/// A photo from a signed link, held in memory only (never in a disk cache).
class NetworkPhoto extends ConsumerWidget {
  const NetworkPhoto({super.key, required this.url, this.fit = BoxFit.cover, this.cacheWidth});

  final String url;
  final BoxFit fit;

  /// Decode at this width to save memory for thumbnails.
  final int? cacheWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return ref
        .watch(imageBytesProvider(url))
        .when(
          data: (bytes) => Image.memory(bytes, fit: fit, cacheWidth: cacheWidth, gaplessPlayback: true),
          loading: () =>
              const Center(child: SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 2))),
          error: (_, _) => Center(
            child: Icon(
              Icons.broken_image_outlined,
              color: theme.colorScheme.onSurfaceVariant,
              semanticLabel: AppLocalizations.of(context).photoLoadFailed,
            ),
          ),
        );
  }
}

/// Full-screen, zoomable photos; swipe between them.
class PhotoGalleryPage extends StatefulWidget {
  const PhotoGalleryPage({super.key, required this.urls, this.initialIndex = 0});

  final List<String> urls;
  final int initialIndex;

  static Future<void> open(BuildContext context, List<String> urls, {int initialIndex = 0}) => Navigator.of(context)
      .push<void>(
        MaterialPageRoute(
          builder: (_) => PhotoGalleryPage(urls: urls, initialIndex: initialIndex),
        ),
      );

  @override
  State<PhotoGalleryPage> createState() => _PhotoGalleryPageState();
}

class _PhotoGalleryPageState extends State<PhotoGalleryPage> {
  late final _controller = PageController(initialPage: widget.initialIndex);
  late var _index = widget.initialIndex;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: widget.urls.length > 1 ? Text('${_index + 1} / ${widget.urls.length}') : null,
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.urls.length,
        onPageChanged: (index) => setState(() => _index = index),
        itemBuilder: (context, index) => InteractiveViewer(
          maxScale: 5,
          child: NetworkPhoto(url: widget.urls[index], fit: BoxFit.contain),
        ),
      ),
    );
  }
}
