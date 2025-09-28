import 'package:flutter/material.dart';

import '../components/app_top_bar.dart';

class StubScreen extends StatelessWidget {
  const StubScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(title),
      ),
      body: Center(
        child: Text(
          '$title screen coming soon',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
