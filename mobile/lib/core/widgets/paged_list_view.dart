import 'package:material_ui/material_ui.dart';

import '../l10n/generated/app_localizations.dart';
import '../network/api_client.dart';
import '../network/app_exception.dart';
import '../network/error_messages.dart';
import '../theme/app_spacing.dart';
import 'async_value_view.dart';
import 'empty_state.dart';

typedef PageFetcher<T> = Future<PageResult<T>> Function(int page);

/// Infinite-scroll list over a paginated endpoint: first-load spinner, error with
/// retry, empty state, pull to refresh, and more pages as the user scrolls.
/// Give it a new key (e.g. from filters or a data revision) to start over.
class PagedListView<T> extends StatefulWidget {
  const PagedListView({
    super.key,
    required this.fetch,
    required this.itemBuilder,
    required this.empty,
    this.padding = const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 96),
    this.separator = const SizedBox(height: AppSpacing.sm),
    this.header,
  });

  final PageFetcher<T> fetch;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final Widget empty;
  final EdgeInsets padding;
  final Widget separator;

  /// Shown above the items (e.g. a total or summary).
  final Widget Function(BuildContext context, int total)? header;

  @override
  State<PagedListView<T>> createState() => _PagedListViewState<T>();
}

class _PagedListViewState<T> extends State<PagedListView<T>> {
  final _items = <T>[];
  var _page = 0;
  var _total = 0;
  var _hasMore = true;
  var _loading = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _loadMore();
  }

  Future<void> _refresh() async {
    setState(() {
      _items.clear();
      _page = 0;
      _hasMore = true;
      _error = null;
    });
    await _loadMore();
  }

  Future<void> _loadMore() async {
    if (_loading || !_hasMore) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await widget.fetch(_page + 1);
      if (!mounted) return;
      setState(() {
        _items.addAll(page.items);
        _page = page.page;
        _total = page.total;
        _hasMore = page.hasMore;
      });
    } on Object catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      if (_error != null) return ErrorView(error: _error!, onRetry: _refresh);
      if (_loading || _hasMore) return const LoadingView();
      final header = widget.header;
      if (header != null) {
        // The header (e.g. today's card) stays, with the empty message below it.
        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: widget.padding,
            children: [header(context, 0), widget.empty],
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: _refresh,
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: widget.empty,
            ),
          ),
        ),
      );
    }

    final hasHeader = widget.header != null;
    final extra = (hasHeader ? 1 : 0) + 1;
    return RefreshIndicator(
      onRefresh: _refresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.extentAfter < 400) _loadMore();
          return false;
        },
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: widget.padding,
          itemCount: _items.length + extra,
          separatorBuilder: (_, _) => widget.separator,
          itemBuilder: (context, index) {
            if (hasHeader && index == 0) return widget.header!(context, _total);
            final itemIndex = index - (hasHeader ? 1 : 0);
            if (itemIndex < _items.length) return widget.itemBuilder(context, _items[itemIndex]);
            return _Footer(loading: _loading, error: _error, hasMore: _hasMore, onRetry: _loadMore);
          },
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.loading, required this.error, required this.hasMore, required this.onRetry});

  final bool loading;
  final Object? error;
  final bool hasMore;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (loading) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Center(child: SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 2.5))),
      );
    }
    if (error != null) {
      return Column(
        children: [
          Text(
            error is AppException ? (error! as AppException).userMessage(l10n) : l10n.errorUnexpected,
            textAlign: TextAlign.center,
          ),
          TextButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
        ],
      );
    }
    return const SizedBox(height: AppSpacing.sm);
  }
}

/// A ready-made empty state for lists.
class EmptyList extends StatelessWidget {
  const EmptyList({super.key, required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) => EmptyState(icon: icon, title: message);
}
