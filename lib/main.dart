import 'package:flutter/material.dart';

import 'screen/home.dart';


void main() {
  runApp(const Plotter());
}

class Plotter extends StatelessWidget {
  const Plotter({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
      ),
      home: const PlotterPage(title: 'Plotter'),
    );
  }
}

