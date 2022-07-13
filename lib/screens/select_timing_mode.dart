import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pig_dice/screens/timing_selection_screen.dart';

import 'main_game_screen.dart';

class SelectTimingMode extends StatelessWidget {
  final textController = TextEditingController();

  void _showScoreDialogue(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        bool error = false;
        return StatefulBuilder(
          builder: (ctx, setState) => AlertDialog(
            title: Text('Enter Wining score'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    autocorrect: true,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                    controller: textController,
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: false, signed: false),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (val) {
                      setState(() {
                        error = false;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 10),
                    child: Text(
                      error ? 'Enter Score greater than 0' : '',
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (textController.text.isNotEmpty &&
                      int.parse(textController.text) > 0) {
                    print(textController.text);
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => MainGameScreen(
                            null, int.parse(textController.text.toString()))));
                  } else {
                    setState(() {
                      error = true;
                    });
                  }
                },
                child: Text('Start'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Transform.rotate(
                angle: 25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Pig ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 60, color: Theme.of(context).accentColor),
                    ),
                    Container(
                        width: 60,
                        child: Image.asset('assets/images/dice.png')),
                  ],
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(TimingSelectionScreen.routeName, arguments: 0);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Timing',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).accentColor),
                ),
              ),
              Divider(),
              ElevatedButton(
                onPressed: () {
                  textController.clear();
                  _showScoreDialogue(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Score',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).accentColor),
                ),
              ),
              Divider(),
              ElevatedButton(
                onPressed: () => SystemNavigator.pop(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Exit',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).accentColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
