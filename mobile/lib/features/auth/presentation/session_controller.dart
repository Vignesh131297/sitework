import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/app_exception.dart';
import '../../notifications/push/push_registration.dart';
import '../data/auth_repository.dart';
import '../domain/app_session.dart';

/// The signed-in user (null when signed out); the router redirects whenever it
/// changes. On launch the cached session is used immediately, so the app starts
/// signed in even offline, and the profile is refreshed in the background.
class SessionController extends AsyncNotifier<AppSession?> {
  @override
  Future<AppSession?> build() async {
    final stored = await ref.read(authRepositoryProvider).restore();
    if (stored != null) unawaited(Future.microtask(_refreshProfile));
    return stored?.user;
  }

  Future<void> signIn(String identifier, String password) async {
    final user = await ref.read(authRepositoryProvider).signIn(identifier, password);
    ref.read(sessionNoticeProvider.notifier).clear();
    state = AsyncData(user);
  }

  /// The first admin creates their account and is signed in.
  Future<void> signUp({required String name, required String phone, String? email, required String password}) async {
    final user = await ref
        .read(authRepositoryProvider)
        .signUp(name: name, phone: phone, email: email, password: password);
    ref.read(sessionNoticeProvider.notifier).clear();
    state = AsyncData(user);
  }

  Future<void> signOut() async {
    // While still signed in, so the server accepts it.
    await ref.read(pushRegistrationProvider).unregister();
    await ref.read(authRepositoryProvider).signOut();
    state = const AsyncData(null);
  }

  /// Called when the server rejects the session (revoked, disabled, expired refresh).
  void sessionEnded() {
    if (state.value == null) return;
    ref.read(sessionNoticeProvider.notifier).sessionEnded();
    state = const AsyncData(null);
  }

  void passwordChanged() {
    final user = state.value;
    if (user != null) state = AsyncData(user.copyWith(mustChangePassword: false));
  }

  Future<void> _refreshProfile() async {
    try {
      final profile = await ref.read(authRepositoryProvider).fetchProfile();
      if (state.value != null) state = AsyncData(profile.toSession());
    } on AppException {
      // Offline: keep the cached session. A rejected session is handled by the
      // auth interceptor, which calls sessionEnded().
    }
  }
}

final sessionProvider = AsyncNotifierProvider<SessionController, AppSession?>(SessionController.new);

/// Set when the server ended the session, so sign-in can explain why.
class SessionNotice extends Notifier<bool> {
  @override
  bool build() => false;

  void sessionEnded() => state = true;
  void clear() => state = false;
}

final sessionNoticeProvider = NotifierProvider<SessionNotice, bool>(SessionNotice.new);
