import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/generated/app_localizations.dart';
import '../network/app_exception.dart';
import '../network/error_messages.dart';
import 'empty_state.dart';

/// Loading spinner, friendly error with retry, or the data.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({super.key, required this.value, required this.data, this.onRetry});

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => value.when(
    data: data,
    loading: () => const LoadingView(),
    error: (error, _) => ErrorView(error: error, onRetry: onRetry),
  );
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()),
  );
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isOffline = error is NetworkException;
    return EmptyState(
      icon: isOffline ? Icons.cloud_off_outlined : Icons.error_outline,
      title: error is AppException ? (error as AppException).userMessage(l10n) : l10n.errorUnexpected,
      action: onRetry == null
          ? null
          : OutlinedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: Text(l10n.commonRetry)),
    );
  }
}
