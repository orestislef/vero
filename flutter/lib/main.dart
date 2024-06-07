import 'package:flutter/material.dart';
import 'package:vero/widgets/home.dart';

void main() {
  runApp(const VeroApp());
}

class VeroApp extends StatelessWidget {
  const VeroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vero',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}
