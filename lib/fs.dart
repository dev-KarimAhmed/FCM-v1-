import 'package:flutter/material.dart';
import 'package:test/core/functions/navigate_to.dart';
import 'package:test/features/cache/presentation/views/cache_data.dart';

class FirstView extends StatelessWidget {
  const FirstView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
          onPressed: () {
            navigateTo(context, const CacheData());
          },
          icon: const Icon(Icons.add)),
    );
  }
}
