import 'package:flutter/material.dart';

class QuranPage extends StatelessWidget {
  const QuranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran'),
      ),
      body: const Center(
        child: Text('Quran Page'),
      ),
    );
  }
}