import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/widgets/periodic_refresh.dart';

/// Reloads the unread count and lists now and then, and when the app comes
/// back to the foreground. Push messages (when set up) refresh them sooner.
class NotificationsPoller extends ConsumerWidget {
  const NotificationsPoller({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) => PeriodicRefresh(
    interval: const Duration(minutes: 1),
    onRefresh: () => ref.bump(DataSet.notifications),
    child: child,
  );
}
