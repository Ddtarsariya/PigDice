import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:pig_dice/screens/timing_selection_screen.dart';

class MainGameScreen extends StatefulWidget {
  final String time;
  final int score;

  const MainGameScreen(this.time, this.score);

  @override
  _MainGameScreenState createState() => _MainGameScreenState();
}

class _MainGameScreenState extends State<MainGameScreen>
    with SingleTickerProviderStateMixin {
  var rnd = Random();
  var playerOneTurn = Random().nextBool();
  var player1MainScore = 0;
  var player2MainScore = 0;
  var player1TurnScore = 0;
  var player2TurnScore = 0;
  int currentNum;
  Timer _timer;
  bool extendTime = false;
  int counter;
  var isAnimating = true;
  final double portraitContainer = 90;
  final double landscapeContainer = 70;

  var pauseScreen = false;
  var disableAction = false;
  ConfettiController _controllerCenter;
  var winner = false;
  var whoWinner = '';
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    if (widget.score == null) timer(null);
    animationController = new AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
  }

  stopRotation() {
    animationController.stop();
  }

  startRotation() {
    animationController.repeat();
  }

  void timer(String exTime) {
    print(exTime);
    if (!pauseScreen)
      counter = exTime == null
          ? Duration(minutes: int.parse(widget.time)).inSeconds
          : Duration(minutes: int.parse(exTime)).inSeconds;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (counter > 0) {
          counter--;
        } else {
          _timer.cancel();
          if (player1MainScore == player2MainScore)
            _declareWinner(title: 'Tie');
          else
            (player1MainScore > player2MainScore)
                ? _declareWinner(title: 'Player 1 win')
                : _declareWinner(title: 'Player 2 win');
        }
      });
    });
  }

  @override
  void dispose() {
    if (widget.score == null) _timer.cancel();
    _controllerCenter.dispose();
    super.dispose();
  }

  _declareWinner({/* BuildContext context, Size size,  */ String title}) {
    setState(() {
      winner = true;
      whoWinner = title;
    });
    /*return showDialog(
      barrierDismissible: false,
      context: context,
      builder: ((ctx) => AlertDialog(
            title: widget.score == null ? Text(title) : Text(title),
            actions: [
              if (widget.score == null)
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
                      player2TurnScore = 0;
                      player1TurnScore = 0;
                      timer(value);
                    });
                  },
                  child: Text('Add time'),
                ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  if (widget.score == null) Navigator.of(context).pop();
                },
                child: Text('Main Menu'),
              ),
            ],
          )),
    );*/
  }

  Widget _columnOfInteractWidget() {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? Column(
            children: [
              const SizedBox(height: 20),
              _playerRollDiceWidget(Icons.shuffle_on_outlined),
              const Divider(),
              const Text(
                'Shuffle',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              _playerCollectScoreWidget(Icons.add_circle_outline_sharp),
              const Divider(),
              const Text(
                'Collect Score',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  _scoreWidget(playerOneTurn
                      ? player1TurnScore.toString()
                      : player2TurnScore.toString()),
                  const Divider(),
                  const Text(
                    'Turn Score',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  _playerRollDiceWidget(Icons.shuffle_on_outlined),
                  const SizedBox(height: 5),
                  const Text(
                    'Shuffle',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  _playerCollectScoreWidget(Icons.add_circle_outline_sharp),
                  const SizedBox(height: 5),
                  const Text(
                    'Collect Score',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const SizedBox(height: 30),
                  _scoreWidget(playerOneTurn
                      ? player1TurnScore.toString()
                      : player2TurnScore.toString()),
                  const Divider(),
                  const Text(
                    'Turn Score',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          );
  }

  void reset() {
    if (playerOneTurn) {
      playerOneTurn = !playerOneTurn;
      player1TurnScore = 0;
    } else {
      playerOneTurn = !playerOneTurn;
      player2TurnScore = 0;
    }
  }

  void _rollDiceWithScore() async {
    startRotation();
    setState(() {
      isAnimating = true;
      disableAction = true;
    });
    await Future.delayed(Duration(milliseconds: 600));
    currentNum = rnd.nextInt(7);
    currentNum = currentNum == 0 ? 1 : currentNum;
    setState(() {
      if (playerOneTurn) {
        if (currentNum == 1) {
          if ((player1TurnScore + player1MainScore) == widget.score ||
              (currentNum + player1TurnScore + player1MainScore) ==
                  widget.score)
            _collectScore();
          else
            reset();
        } else {
          player1TurnScore += currentNum;
          if (player1TurnScore > widget.score ||
              ((player1TurnScore + player1MainScore) > widget.score)) {
            reset();
          }
        }
      } else {
        if (currentNum == 1) {
          if ((player2TurnScore + player2MainScore) == widget.score ||
              ((currentNum + player2TurnScore + player2MainScore) ==
                  widget.score))
            _collectScore();
          else
            reset();
        } else {
          player2TurnScore += currentNum;
          if (player2TurnScore > widget.score ||
              ((player2TurnScore + player2MainScore) > widget.score)) {
            reset();
          }
        }
      }

      isAnimating = false;
      disableAction = false;
    });
    if (player1TurnScore == widget.score && player1MainScore == 0) {
      _declareWinner(title: 'Player 1 Win');
    } else if (player2TurnScore == widget.score && player2MainScore == 0) {
      _declareWinner(title: 'Player 2 Win');
    }
    stopRotation();
  }

  Widget playerTag({String header}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(40)),
      child: Center(
        child: Text(
          header,
          style: const TextStyle(
            fontSize: 35,
          ),
        ),
      ),
      padding: const EdgeInsets.all(10),
    );
  }

  void _rollDice() async {
    startRotation();
    setState(() {
      isAnimating = true;
      disableAction = true;
    });
    await Future.delayed(Duration(milliseconds: 600));
    currentNum = rnd.nextInt(7);
    currentNum = currentNum == 0 ? 6 : currentNum;
    print(currentNum);
    setState(() {
      if (playerOneTurn) {
        if (currentNum > 1) {
          player1TurnScore += currentNum;
        } else {
          player1TurnScore = 0;
          playerOneTurn = false;
        }
      } else {
        if (currentNum > 1) {
          player2TurnScore += currentNum;
        } else {
          player2TurnScore = 0;
          playerOneTurn = true;
        }
      }
      isAnimating = false;
      disableAction = false;
    });
    stopRotation();
  }

  Widget setResultDice(Orientation orientation) {
    return Container(
        width: orientation == Orientation.portrait
            ? portraitContainer - 25
            : landscapeContainer - 14,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset('assets/images/dice$currentNum.jpg')));
  }

  void _collectScore() {
    setState(() {
      if (playerOneTurn) {
        player1MainScore += player1TurnScore;
        player1TurnScore = 0;
      } else {
        player2MainScore += player2TurnScore;
        player2TurnScore = 0;
      }
      if (widget.score != null) {
        if (player1MainScore == widget.score) {
          _declareWinner(title: 'Player 1 Win');
        } else if (player2MainScore == widget.score) {
          _declareWinner(title: 'Player 2 Win');
        } else if (player2MainScore > widget.score &&
            player1MainScore > widget.score) {
          _declareWinner(title: 'Tie');
        }
      }
      playerOneTurn = !playerOneTurn;
    });
  }

  Widget _playerRollDiceWidget(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.green, borderRadius: BorderRadius.circular(40)),
      child: IconButton(
        splashColor: Colors.white,
        icon: Icon(icon),
        onPressed: disableAction
            ? null
            : widget.score == null
                ? _rollDice
                : _rollDiceWithScore,
      ),
    );
  }

  Widget winnerWidget(
    BuildContext context,
    Size size,
  ) {
    _controllerCenter.play();
    return Container(
      width: size.width,
      height: size.height,
      color: const Color.fromRGBO(0, 0, 0, 40),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _controllerCenter,
              blastDirectionality: BlastDirectionality.explosive,
              gravity: 0.6,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ], // manually specify the colors to be used.
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 150,
                  height: 150,
                  child: Image.asset('assets/images/trophy.png')),
              const Divider(),
              Text(
                whoWinner,
                style: const TextStyle(color: Colors.white, fontSize: 50),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.score == null)
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => TimingSelectionScreen(
                              isExtend: true,
                            ),
                          ),
                        ).then((value) {
                          player2TurnScore = 0;
                          player1TurnScore = 0;
                          winner = false;
                          timer(value);
                        });
                      },
                      child: const Text(
                        'Add time',
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (widget.score == null) Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Main Menu',
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _playerCollectScoreWidget(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.green, borderRadius: BorderRadius.circular(35)),
      child: IconButton(
        splashColor: Colors.white,
        icon: Icon(icon),
        onPressed: _collectScore,
      ),
    );
  }

  Widget _scoreWidget(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(40)),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 25,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.score == null
                            ? Text(
                                '${Duration(
                                  seconds: counter,
                                ).inMinutes.remainder(60).toString().padLeft(2, '0')} : ${Duration(
                                  seconds: counter,
                                ).inSeconds.remainder(60).toString().padLeft(2, '0')}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 50,
                                ),
                              )
                            : _scoreWidget('Target : ${widget.score}'),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (widget.score == null) _timer.cancel();
                              pauseScreen = true;
                            });
                          },
                          icon: const Icon(Icons.pause),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Column(
                          children: [
                            playerTag(header: 'Player 1'),
                            playerOneTurn
                                ? _columnOfInteractWidget()
                                : Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 30),
                                    child: AnimatedBuilder(
                                      animation: animationController,
                                      child: isAnimating
                                          ? Container(
                                              width: orientation ==
                                                      Orientation.portrait
                                                  ? portraitContainer
                                                  : landscapeContainer,
                                              child: Image.asset(
                                                  'assets/images/dice.png'))
                                          : setResultDice(orientation),
                                      builder: (BuildContext context,
                                          Widget _widget) {
                                        return Transform.rotate(
                                          angle:
                                              animationController.value * 90.3,
                                          child: _widget,
                                        );
                                      },
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      Container(
                        height: size.height / 2,
                        child: const VerticalDivider(color: Colors.grey),
                      ),
                      Flexible(
                        flex: 3,
                        child: Column(
                          children: [
                            playerTag(header: 'Player 2'),
                            !playerOneTurn
                                ? _columnOfInteractWidget()
                                : Container(
                                    margin: EdgeInsets.symmetric(vertical: 40),
                                    child: AnimatedBuilder(
                                      animation: animationController,
                                      child: isAnimating
                                          ? Container(
                                              width: orientation ==
                                                      Orientation.portrait
                                                  ? portraitContainer
                                                  : landscapeContainer,
                                              child: Image.asset(
                                                  'assets/images/dice.png'))
                                          : setResultDice(orientation),
                                      builder: (BuildContext context,
                                          Widget _widget) {
                                        return Transform.rotate(
                                          angle:
                                              animationController.value * 90.3,
                                          child: _widget,
                                        );
                                      },
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      _scoreWidget('Score'),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(40)),
                              child: Text(
                                player1MainScore.toString(),
                                style: const TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(40)),
                              child: Text(
                                player2MainScore.toString(),
                                style: const TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            if (winner) winnerWidget(context, size),
            if (pauseScreen)
              Container(
                width: size.width,
                height: size.height,
                color: Color.fromRGBO(0, 0, 0, 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(0, 0, 0, 00)),
                      ),
                      onPressed: () {
                        if (widget.score == null) timer(null);
                        setState(() {
                          pauseScreen = false;
                        });
                      },
                      child: const Text(
                        'Resume',
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(0, 0, 0, 00)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (widget.score == null) Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Main Menu',
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}


/* 
void _rollDiceWithScore() async {
    startRotation();
    setState(() {
      isAnimating = true;
      disableAction = true;
    });
    await Future.delayed(Duration(milliseconds: 600));
    currentNum = rnd.nextInt(7);
    currentNum = currentNum == 0 ? 1 : currentNum;
    setState(() {
      if (playerOneTurn) {
        player1TurnScore += currentNum;
        if (player1TurnScore > widget.score) {
          playerOneTurn = !playerOneTurn;
          player1TurnScore = 0;
        } else if ((player1TurnScore + player1MainScore) > widget.score) {
          playerOneTurn = !playerOneTurn;
          player1TurnScore = 0;
        }
      } else {
        player2TurnScore += currentNum;
        if (player2TurnScore > widget.score) {
          playerOneTurn = !playerOneTurn;
          player2TurnScore = 0;
        } else if ((player2TurnScore + player2MainScore) > widget.score) {
          playerOneTurn = !playerOneTurn;
          player2TurnScore = 0;
        }
      }
      isAnimating = false;
      disableAction = false;
    });
    if (player1TurnScore == widget.score && player1MainScore == 0) {
      _declareWinner(title: 'Player 1 Win');
    } else if (player2TurnScore == widget.score && player2MainScore == 0) {
      _declareWinner(title: 'Player 2 Win');
    }
    stopRotation();
  } */