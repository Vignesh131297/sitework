import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../domain/server_health.dart';

class SystemApi {
  SystemApi(this._client);

  final ApiClient _client;

  Future<ServerHealth> health() =>
      _client.get('/health', decode: (data) => ServerHealth.fromJson(data! as Map<String, dynamic>));
}

final systemApiProvider = Provider<SystemApi>((ref) => SystemApi(ref.watch(apiClientProvider)));
