import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_colors.dart';
import 'package:client/core/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);

    if (currentSong == null) {
      return const SizedBox();
    }

    return Stack(
      children: [
        Container(
          height: 66,
          width: MediaQuery.of(context).size.width - 16,
          decoration: BoxDecoration(
            color: hexToColor(currentSong.hex_code),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(currentSong.thumbnail_url),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentSong.song_name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        currentSong.artist,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.subtitleText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      CupertinoIcons.heart,
                      color: AppColors.whiteColor,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      CupertinoIcons.play_fill,
                      color: AppColors.whiteColor,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 8,
          child: Container(
            height: 2,
            width: 20,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 8,
          child: Container(
            height: 2,
            width: MediaQuery.of(context).size.width - 32,
            decoration: BoxDecoration(
              color: AppColors.inactiveSeekColor,
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ),
      ],
    );
  }
}
