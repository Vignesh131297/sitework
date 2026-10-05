import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The server's "now". Every business rule runs on the server clock, so times
/// the app records (e.g. when an offline photo was taken) are corrected by the
/// difference between the phone's clock and the server's, last seen in a response.
class ServerClock extends Notifier<Duration> {
  @override
  Duration build() => Duration.zero;

  /// Records the server time from a response that just arrived.
  void observe(DateTime serverTime) => state = serverTime.difference(DateTime.now());

  DateTime now() => DateTime.now().add(state);
}

final serverClockProvider = NotifierProvider<ServerClock, Duration>(ServerClock.new);
