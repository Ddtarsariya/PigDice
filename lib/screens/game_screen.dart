import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pig_dice/screens/timing_selection_screen.dart';

class GameScreen extends StatefulWidget {
  static const routeName = '/game';
  final String time;

  const GameScreen(this.time);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Timer _timer;
  int counter;
  var rnd = Random();
  int playerOneTurnScore = 0;
  int playerOneMainScore = 0;
  int playerTwoTurnScore = 0;
  int playerTwoMainScore = 0;
  int currentGetNumber = 0;
  bool playerOneTurn = true;
  bool extendTime = false;

  void timer(String exTime) {
    print(exTime);
    counter = exTime == null
        ? Duration(minutes: int.parse(widget.time)).inSeconds
        : Duration(minutes: int.parse(exTime)).inSeconds;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (counter > 0) {
          counter--;
        } else {
          _timer.cancel();
          _declareWinner();
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    timer(null);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _declareWinner() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: ((ctx) => AlertDialog(
            title: playerOneMainScore > playerTwoMainScore
                ? Text('Player 1 win')
                : Text('Player 2 win'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => TimingSelectionScreen(
                        isExtend: true,
                      ),
                    ),
                  ).then((value) {
                    playerTwoTurnScore = 0;
                    playerOneTurnScore = 0;
                    timer(value);
                  });
                },
                child: Text('Add time'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text('Go to main screen'),
              ),
            ],
          )),
    );
  }

  void _rollDice() {
    int num = rnd.nextInt(6);
    currentGetNumber = num < 1 ? 6 : num;
    print(num);
    setState(() {
      if (playerOneTurn) {
        if (currentGetNumber > 1) {
          playerOneTurnScore += currentGetNumber;
        } else {
          playerOneTurnScore = 0;
          playerOneTurn = false;
        }
      } else {
        if (currentGetNumber > 1) {
          playerTwoTurnScore += currentGetNumber;
        } else {
          playerTwoTurnScore = 0;
          playerOneTurn = true;
        }
      }
    });
  }

  void _collectScore() {
    setState(() {
      if (playerOneTurn) {
        playerOneMainScore += playerOneTurnScore;
        playerOneTurnScore = 0;
      } else {
        playerTwoMainScore += playerTwoTurnScore;
        playerTwoTurnScore = 0;
      }
      playerOneTurn = !playerOneTurn;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${Duration(
                      seconds: counter,
                    ).inMinutes.remainder(60).toString().padLeft(2, '0')} : ${Duration(
                      seconds: counter,
                    ).inSeconds.remainder(60).toString().padLeft(2, '0')}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 50),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: size.width / 2 - 30,
                        height: size.height - 150,
                        color: playerOneTurn ? Colors.green : null,
                        child: Column(
                          children: [
                            Text(
                              'Player 1',
                              style: TextStyle(fontSize: 30),
                            ),
                            SizedBox(height: 30),
                            InkWell(
                              onTap: playerOneTurn ? _rollDice : null,
                              child: Column(
                                children: [
                                  Icon(Icons.refresh),
                                  Text(
                                    'Roll dice',
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 30),
                            InkWell(
                              onTap: playerOneTurn ? _collectScore : null,
                              child: Column(
                                children: [
                                  Icon(Icons.add_box_outlined),
                                  Text(
                                    'Collect Score',
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            Container(
                              color: Colors.grey,
                              child: Column(
                                children: [
                                  Text(
                                    playerOneTurnScore.toString(),
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  Text(
                                    'Turn Score',
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            Container(
                              color: Colors.grey,
                              child: Column(
                                children: [
                                  Text(
                                    playerOneMainScore.toString(),
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  Text(
                                    'Main Score',
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          height: 500,
                          child: VerticalDivider(color: Colors.grey)),
                      Container(
                        color: !playerOneTurn ? Colors.green : null,
                        width: size.width / 2 - 30,
                        height: size.height - 150,
                        child: Column(
                          children: [
                            Text(
                              'Player 2',
                              style: TextStyle(fontSize: 30),
                            ),
                            SizedBox(height: 30),
                            InkWell(
                              onTap: !playerOneTurn ? _rollDice : null,
                              child: Column(
                                children: [
                                  Icon(Icons.refresh),
                                  Text(
                                    'Roll dice',
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            InkWell(
                              onTap: !playerOneTurn ? _collectScore : null,
                              child: Column(
                                children: [
                                  Icon(Icons.add_box_outlined),
                                  Text(
                                    'Collect Score',
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            Container(
                              color: Colors.grey,
                              child: Column(
                                children: [
                                  Text(
                                    playerTwoTurnScore.toString(),
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  Text(
                                    'Turn Score',
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            Container(
                              color: Colors.grey,
                              child: Column(
                                children: [
                                  Text(
                                    playerTwoMainScore.toString(),
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  Text(
                                    'Main Score',
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(150.0),
                  child: Text(
                    currentGetNumber.toString(),
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
