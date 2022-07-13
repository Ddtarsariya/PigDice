import 'package:flutter/material.dart';
import 'package:pig_dice/screens/select_timing_mode.dart';
import 'package:pig_dice/screens/timing_selection_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent,
      ),
      home: SelectTimingMode(),
      routes: {
        TimingSelectionScreen.routeName: (ctx) => TimingSelectionScreen(),
      },
    );
  }
}
