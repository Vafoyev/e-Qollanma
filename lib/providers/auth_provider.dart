import 'package:e_qollanma/data/models/user_model.dart';
import 'package:e_qollanma/data/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// ── Auth State ────────────────────────────────────────────────────────────────
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  bool get isLoggedIn => user != null;

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
  }) =>
      AuthState(
        user:      user ?? this.user,
        isLoading: isLoading ?? this.isLoading,
        error:     error,
      );
}

// ── Auth Notifier ─────────────────────────────────────────────────────────────
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;

  AuthNotifier(this._repo) : super(const AuthState()) {
    _loadProfile();
  }

  // App ochilganda token bo'lsa profil yuklaymiz
  Future<void> _loadProfile() async {
    try {
      state = state.copyWith(isLoading: true);
      final user = await _repo.getProfile();
      state = state.copyWith(user: user, isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> login({
    required String phone,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repo.login(phone: phone, password: password);
      state = state.copyWith(user: user, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> register({
    required String fullName,
    required String phone,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repo.register(
        fullName: fullName,
        phone:    phone,
        password: password,
      );
      // Register dan keyin auto login
      return await login(phone: phone, password: password);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AuthState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authProvider =
StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});