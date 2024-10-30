import 'package:flutter/material.dart';

class PlaceholderWidget extends StatelessWidget {
  const PlaceholderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("More"),
        backgroundColor: Colors.blueAccent,
      ),
      body: const Center(
        child: Text(
          "More features coming soon!",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}

