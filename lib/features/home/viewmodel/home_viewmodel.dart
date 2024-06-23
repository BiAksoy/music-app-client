import 'dart:io';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/utils/utils.dart';
import 'package:client/features/home/repositories/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;

  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File audio,
    required File thumbnail,
    required String artist,
    required String songName,
    required Color color,
  }) async {
    state = const AsyncValue.loading();

    final result = await _homeRepository.uploadSong(
      audio: audio,
      thumbnail: thumbnail,
      artist: artist,
      songName: songName,
      hexCode: rgbaToHex(color),
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    switch (result) {
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
      case Right(value: final r):
        state = AsyncValue.data(r);
    }
  }
}
