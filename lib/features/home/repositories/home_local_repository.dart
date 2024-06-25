import 'package:client/features/home/models/song_model.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_local_repository.g.dart';

@riverpod
HomeLocalRepository homeLocalRepository(HomeLocalRepositoryRef ref) {
  return HomeLocalRepository();
}

class HomeLocalRepository {
  final Box _box = Hive.box();

  void uploadLocalSong(SongModel song) {
    _box.put(song.id, song.toJson());
  }

  List<SongModel> getLocalSongs() {
    List<SongModel> songs = [];

    for (final key in _box.keys) {
      final song = SongModel.fromJson(_box.get(key));
      songs.add(song);
    }

    return songs;
  }
}
