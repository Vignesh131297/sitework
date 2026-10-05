import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/generated/app_localizations.dart';

/// Text picked from the translations when the widget builds.
typedef LocalizedText = String Function(AppLocalizations l10n);

/// One bottom-navigation tab of a role's shell.
class ShellTab {
  const ShellTab({
    required this.path,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.screen,
    this.badgeCount,
  });

  final String path;
  final IconData icon;
  final IconData selectedIcon;
  final LocalizedText label;
  final Widget screen;

  /// A number shown on the tab's icon (e.g. unread alerts); 0 hides it.
  final int Function(WidgetRef ref)? badgeCount;
}

/// A role's home: the selected tab's screen above a bottom navigation bar.
/// Each tab keeps its own navigation stack.
class RoleShell extends ConsumerWidget {
  const RoleShell({super.key, required this.shell, required this.tabs});

  final StatefulNavigationShell shell;
  final List<ShellTab> tabs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    Widget icon(ShellTab tab, IconData data) {
      final count = tab.badgeCount?.call(ref) ?? 0;
      return Badge(isLabelVisible: count > 0, label: Text(count > 99 ? '99+' : '$count'), child: Icon(data));
    }

    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        // Tapping the current tab again returns to its first screen.
        onDestinationSelected: (index) => shell.goBranch(index, initialLocation: index == shell.currentIndex),
        destinations: [
          for (final tab in tabs)
            NavigationDestination(
              icon: icon(tab, tab.icon),
              selectedIcon: icon(tab, tab.selectedIcon),
              label: tab.label(l10n),
            ),
        ],
      ),
    );
  }
}

/// [wrap] places role-wide helpers (polling, background sync) around the shell.
StatefulShellRoute roleShellRoute(List<ShellTab> tabs, {Widget Function(Widget shell)? wrap}) =>
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) {
        final roleShell = RoleShell(shell: shell, tabs: tabs);
        return wrap == null ? roleShell : wrap(roleShell);
      },
      branches: [
        for (final tab in tabs)
          StatefulShellBranch(
            routes: [GoRoute(path: tab.path, builder: (context, state) => tab.screen)],
          ),
      ],
    );
