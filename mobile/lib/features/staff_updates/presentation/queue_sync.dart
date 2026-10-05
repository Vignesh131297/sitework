import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/widgets/periodic_refresh.dart';
import '../../auth/presentation/session_controller.dart';
import '../data/update_queue.dart';
import '../domain/pending_update.dart';

/// Sends saved updates whenever it can: when the staff area opens, when the
/// app comes back to the foreground, and every half minute while some wait.
class QueueSync extends ConsumerStatefulWidget {
  const QueueSync({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<QueueSync> createState() => _QueueSyncState();
}

class _QueueSyncState extends ConsumerState<QueueSync> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _flush());
  }

  Future<void> _flush() async {
    final userId = ref.read(sessionProvider).value?.userId;
    if (userId == null || !mounted) return;
    final waiting = (await ref.read(updateQueueProvider.future))
        .any((item) => item.userId == userId && item.state == PendingState.waiting);
    if (waiting && mounted) await ref.read(updateQueueProvider.notifier).flush(userId);
  }

  @override
  Widget build(BuildContext context) =>
      PeriodicRefresh(interval: const Duration(seconds: 30), onRefresh: _flush, child: widget.child);
}
