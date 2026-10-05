import 'dart:async';

import 'package:material_ui/material_ui.dart';

/// Calls [onRefresh] every [interval] and whenever the app returns to the
/// foreground, while this widget is on screen.
class PeriodicRefresh extends StatefulWidget {
  const PeriodicRefresh({super.key, required this.interval, required this.onRefresh, required this.child});

  final Duration interval;
  final VoidCallback onRefresh;
  final Widget child;

  @override
  State<PeriodicRefresh> createState() => _PeriodicRefreshState();
}

class _PeriodicRefreshState extends State<PeriodicRefresh> {
  late final Timer _timer = Timer.periodic(widget.interval, (_) => widget.onRefresh());
  late final AppLifecycleListener _lifecycle = AppLifecycleListener(onResume: widget.onRefresh);

  @override
  void initState() {
    super.initState();
    _timer;
    _lifecycle;
  }

  @override
  void dispose() {
    _timer.cancel();
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
