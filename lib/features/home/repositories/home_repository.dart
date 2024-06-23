import 'dart:io';

import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure/app_failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, String>> uploadSong({
    required File audio,
    required File thumbnail,
    required String artist,
    required String songName,
    required String hexCode,
    required String token,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ServerConstant.serverUrl}/song/upload'),
      );

      request
        ..files.addAll(
          [
            await http.MultipartFile.fromPath('song', audio.path),
            await http.MultipartFile.fromPath('thumbnail', thumbnail.path),
          ],
        )
        ..fields.addAll(
          {
            'artist': artist,
            'song_name': songName,
            'hex_code': hexCode,
          },
        )
        ..headers.addAll(
          {
            'x-auth-token': token,
          },
        );

      final response = await request.send();

      if (response.statusCode != 201) {
        return Left(AppFailure(await response.stream.bytesToString()));
      }

      return Right(await response.stream.bytesToString());
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}