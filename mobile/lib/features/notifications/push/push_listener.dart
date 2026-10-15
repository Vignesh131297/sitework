import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/models/enums.dart';
import '../../auth/presentation/session_controller.dart';
import '../presentation/notifications_screen.dart';
import 'push_registration.dart';
import 'push_service.dart';

/// Inside a signed-in role's area: registers this phone for pushes, refreshes
/// what a push is about, and opens the screen a tapped notification points to.
class PushListener extends ConsumerStatefulWidget {
  const PushListener({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<PushListener> createState() => _PushListenerState();
}

class _PushListenerState extends ConsumerState<PushListener> {
  final _subscriptions = <StreamSubscription<PushArrival>>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  Future<void> _start() async {
    if (!mounted) return;
    final service = ref.read(pushServiceProvider);
    unawaited(ref.read(pushRegistrationProvider).register());
    _subscriptions
      ..add(service.foregroundMessages.listen(_arrived))
      ..add(service.openedMessages.listen(_open));
    final initial = await service.initialMessage();
    if (initial != null && mounted) _open(initial);
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
    super.dispose();
  }

  void _refresh(PushArrival arrival) {
    ref.bump(DataSet.notifications);
    final related = switch (arrival.toNotification().type) {
      NotificationType.staffUpdate || NotificationType.missingUpdate => DataSet.staffUpdates,
      NotificationType.engineerUpdate => DataSet.engineerUpdates,
      NotificationType.issue => DataSet.issues,
      NotificationType.payment => DataSet.payments,
      NotificationType.attendance => DataSet.attendance,
      NotificationType.stock => DataSet.stock,
      NotificationType.system => null,
    };
    if (related != null) ref.bump(related);
  }

  /// The system shows nothing while the app is open, so the app does.
  void _arrived(PushArrival arrival) {
    if (!mounted) return;
    _refresh(arrival);
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(arrival.title),
        action: SnackBarAction(label: l10n.commonView, onPressed: () => _open(arrival)),
      ),
    );
  }

  void _open(PushArrival arrival) {
    final role = ref.read(sessionProvider).value?.role;
    if (role == null || !mounted) return;
    _refresh(arrival);
    final target = notificationTarget(arrival.toNotification(), role);
    if (target == null) return;
    if (target.isTab) {
      context.go(target.path);
    } else {
      unawaited(context.push<void>(target.path));
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
