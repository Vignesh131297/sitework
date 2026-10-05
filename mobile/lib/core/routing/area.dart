import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/session_controller.dart';

/// The signed-in user's area: '/admin', '/engineer' or '/staff'. Shared screens
/// build links with it so they stay inside the right role's routes.
final areaPathProvider = Provider<String>((ref) => ref.watch(sessionProvider).value?.role.areaPath ?? '');
