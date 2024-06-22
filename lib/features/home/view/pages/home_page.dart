import 'package:client/core/providers/current_user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomePage());

  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserNotifierProvider);
    
    return Scaffold(
      body: Center(
        child: Text('Welcome ${user?.name}'),
      ),
    );
  }
}
