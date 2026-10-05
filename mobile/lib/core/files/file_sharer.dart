import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

/// Hands a file to the system share sheet, so the user can save it to Drive,
/// mail it or open it in a spreadsheet app. Nothing is kept on the phone.
abstract interface class FileSharer {
  Future<void> share({required String name, required List<int> bytes, required String mimeType, String? subject});
}

class SystemFileSharer implements FileSharer {
  const SystemFileSharer();

  @override
  Future<void> share({required String name, required List<int> bytes, required String mimeType, String? subject}) =>
      SharePlus.instance.share(
        ShareParams(
          files: [XFile.fromData(Uint8List.fromList(bytes), mimeType: mimeType, name: name)],
          fileNameOverrides: [name],
          subject: subject,
        ),
      );
}

final fileSharerProvider = Provider<FileSharer>((ref) => const SystemFileSharer());
