import 'package:client/features/auth/model/user_model.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late final AuthRemoteRepository _authRemoteRepository;

  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    return null;
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
        state = AsyncValue.data(r);
    }
  }
}