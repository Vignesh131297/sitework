import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import 'api_client.dart';
import 'app_exception.dart';
import 'dio_error_mapper.dart';

/// Downloads photos from their short-lived signed links into memory. Nothing is
/// written to disk: staff photos are meant to disappear once reviewed.
class ImageLoader {
  ImageLoader(this._dio, this._apiBaseUrl);

  final Dio _dio;
  final String _apiBaseUrl;

  /// Signed links from local storage are paths under the API (`/files/…`).
  Uri resolve(String url) => url.startsWith('/') ? Uri.parse('$_apiBaseUrl$url') : Uri.parse(url);

  Future<Uint8List> bytes(String url) async {
    try {
      // No auth header: the signature in the link is the permission.
      final response = await _dio.getUri<List<int>>(
        resolve(url),
        options: Options(responseType: ResponseType.bytes, headers: {'cache-control': 'no-store'}),
      );
      return Uint8List.fromList(response.data ?? const []);
    } on DioException catch (error) {
      throw mapDioException(error);
    } on Object catch (error) {
      throw UnexpectedException(error);
    }
  }
}

final imageLoaderProvider = Provider<ImageLoader>(
  (ref) => ImageLoader(ref.watch(plainDioProvider), ref.watch(appConfigProvider).apiBaseUrl),
);

/// A photo's bytes by URL, released when nothing shows it any more.
final imageBytesProvider = FutureProvider.autoDispose.family<Uint8List, String>(
  (ref, url) => ref.watch(imageLoaderProvider).bytes(url),
);
