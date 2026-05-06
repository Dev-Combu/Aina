import 'package:flutter/material.dart';

class Aina extends StatefulWidget{
  const Aina({super.key});

  @override
  State<Aina> createState() => _AinaState();
}

class _AinaState extends State<Aina> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aina'),
      ),
      body: const Center(
        child: Text('Aina'),
      ),
    );
  }
}