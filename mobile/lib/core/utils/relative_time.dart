import '../l10n/generated/app_localizations.dart';
import 'formatters.dart';

/// "Just now", "5 min ago", "3 h ago", "Yesterday, 4:10 PM", else "5 Oct, 4:10 PM".
String formatRelative(DateTime time, AppLocalizations l10n, {DateTime? now}) {
  final local = time.toLocal();
  final current = (now ?? DateTime.now()).toLocal();
  final elapsed = current.difference(local);
  if (elapsed.inMinutes < 1) return l10n.timeJustNow;
  if (elapsed.inMinutes < 60) return l10n.timeMinutesAgo(elapsed.inMinutes);
  final today = DateTime(current.year, current.month, current.day);
  if (!local.isBefore(today)) return l10n.timeHoursAgo(elapsed.inHours);
  if (!local.isBefore(today.subtract(const Duration(days: 1)))) return l10n.timeYesterday(formatTime(local));
  return formatDateTime(local);
}
