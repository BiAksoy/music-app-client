import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:client/features/auth/repositories/auth_local_repository.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;

  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
    return null;
  }

  Future<void> initSharedPreferences() async {
    await _authLocalRepository.init();
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    final result = await _authRemoteRepository.signup(
      name: name,
      email: email,
      password: password,
    );

    switch (result) {
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
      case Right(value: final r):
        state = AsyncValue.data(r);
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    final result = await _authRemoteRepository.login(
      email: email,
      password: password,
    );

    switch (result) {
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
      case Right(value: final r):
        _authLocalRepository.setToken(r.token);
        _currentUserNotifier.setCurrentUser(r);
        state = AsyncValue.data(r);
    }
  }

  Future<UserModel?> getCurrentUser() async {
    state = const AsyncValue.loading();

    final token = _authLocalRepository.getToken();

    if (token != null) {
      final result = await _authRemoteRepository.getCurrentUser(token);

      switch (result) {
        case Left(value: final l):
          state = AsyncValue.error(l.message, StackTrace.current);
        case Right(value: final r):
          _currentUserNotifier.setCurrentUser(r);
          state = AsyncValue.data(r);
          return r;
      }
    }
    return null;
  }
}
