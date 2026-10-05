import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// Picks photos. A provider so tests can supply images without a camera.
final imagePickerProvider = Provider<ImagePicker>((ref) => ImagePicker());
