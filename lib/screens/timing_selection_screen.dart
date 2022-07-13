import 'package:flutter/material.dart';
import 'package:pig_dice/screens/main_game_screen.dart';

class TimingSelectionScreen extends StatefulWidget {
  static const routeName = '/timing-selection';
  final bool isExtend;

  const TimingSelectionScreen({this.isExtend = false});

  @override
  _TimingSelectionScreenState createState() => _TimingSelectionScreenState();
}

class _TimingSelectionScreenState extends State<TimingSelectionScreen> {
  void _openGameScreen(String time) {
    if (widget.isExtend) {
      return Navigator.of(context).pop(time);
    }
    /* Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => GameScreen(time)));*/
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => MainGameScreen(time, null)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Select Time',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 40, color: Theme.of(context).accentColor),
              ),
              SizedBox(height: 50),
              OutlinedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.deepPurpleAccent)),
                onPressed: () {
                  _openGameScreen('1');
                },
                child: const Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    '1:00',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  _openGameScreen('5');
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.deepPurpleAccent)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '5:00',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  _openGameScreen('10');
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.deepPurpleAccent)),
                child: const Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    '10:00',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*

style: buttonClicked == 1
? ButtonStyle(
side: MaterialStateProperty.all(
BorderSide(color: Colors.deepPurpleAccent),
),
)
: null,*/
