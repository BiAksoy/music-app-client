import 'package:client/core/theme/app_colors.dart';
import 'package:client/features/home/view/pages/library_page.dart';
import 'package:client/features/home/view/pages/songs_page.dart';
import 'package:client/features/home/view/widgets/music_slab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomePage());

  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;

  final pages = [
    const SongsPage(),
    const LibraryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          pages[_currentIndex],
          const Positioned(
            bottom: 0,
            child: MusicSlab(),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == 0
                  ? 'assets/images/home_filled.png'
                  : 'assets/images/home_unfilled.png',
              color: _currentIndex == 0
                  ? AppColors.whiteColor
                  : AppColors.inactiveBottomBarItemColor,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/library.png'),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
