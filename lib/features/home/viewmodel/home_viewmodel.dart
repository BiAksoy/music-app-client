import 'dart:io';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/utils/utils.dart';
import 'package:client/features/home/models/favorite_song_model.dart';
import 'package:client/features/home/models/song_model.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';
import 'package:client/features/home/repositories/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(GetAllSongsRef ref) async {
  final token =
      ref.watch(currentUserNotifierProvider.select((user) => user!.token));
  final result = await ref.watch(homeRepositoryProvider).getAllSongs(token);

  return switch (result) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<SongModel>> getAllFavoriteSongs(GetAllFavoriteSongsRef ref) async {
  final token =
      ref.watch(currentUserNotifierProvider.select((user) => user!.token));
  final result =
      await ref.watch(homeRepositoryProvider).getAllFavoriteSongs(token);

  return switch (result) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;
  late HomeLocalRepository _homeLocalRepository;

  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
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

  List<SongModel> getRecentlyPlayedSongs() {
    return _homeLocalRepository.getLocalSongs();
  }

  Future<void> favoriteSong(String songId) async {
    state = const AsyncValue.loading();

    final result = await _homeRepository.favoriteSong(
      songId: songId,
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    switch (result) {
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
      case Right(value: final r):
        final userNotifier = ref.read(currentUserNotifierProvider.notifier);
        if (r) {
          userNotifier.setCurrentUser(
            ref.read(currentUserNotifierProvider)!.copyWith(
              favorites: [
                ...ref.read(currentUserNotifierProvider)!.favorites,
                FavoriteSongModel(
                  id: '',
                  song_id: songId,
                  user_id: '',
                ),
              ],
            ),
          );
        } else {
          userNotifier.setCurrentUser(
            ref.read(currentUserNotifierProvider)!.copyWith(
                  favorites: ref
                      .read(currentUserNotifierProvider)!
                      .favorites
                      .where((favorite) => favorite.song_id != songId)
                      .toList(),
                ),
          );
        }
        ref.invalidate(getAllFavoriteSongsProvider);

        state = AsyncValue.data(r);
    }
  }
}
