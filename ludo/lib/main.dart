import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(LudoGame());
}

class LudoGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ludo Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final int numberOfRounds = 5;
  int currentRound = 1;
  int currentPlayer = 0;

  List<int> scores = [0, 0, 0, 0];
  List<Color> playerColors = [Colors.red, Colors.green, Colors.blue, Colors.orange];
  String message = '';

  void rollDice() {
    if (currentRound > numberOfRounds) {
      return; // Game has ended
    }

    int rolledNumber = Random().nextInt(6) + 1;
    scores[currentPlayer] += rolledNumber;
    message = 'Player ${currentPlayer + 1} rolled a $rolledNumber';

    setState(() {
      currentPlayer++;
      if (currentPlayer >= 4) {
        currentPlayer = 0;
        currentRound++;
      }
    });

    if (currentRound > numberOfRounds) {
      declareWinner();
    }
  }

  void declareWinner() {
    int maxScore = scores.reduce(max);
    List<int> winners = [];
    for (int i = 0; i < scores.length; i++) {
      if (scores[i] == maxScore) {
        winners.add(i + 1);
      }
    }
    message = 'Winner: Player ${winners.join(', Player ')} with $maxScore points!';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ludo Game'),
      ),
      body: Center(  // Centering the entire content
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Round: $currentRound/$numberOfRounds',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              Row(  // Row for two columns of players
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Left Column: Player 1 and Player 3
                  Column(
                    children: [
                      playerContainer(0),  // Player 1
                      SizedBox(height: 16), // Spacing between Player 1 and Player 3
                      playerContainer(2),  // Player 3
                    ],
                  ),
                  SizedBox(width: 32), // Space between the two columns
                  // Right Column: Player 2 and Player 4
                  Column(
                    children: [
                      playerContainer(1),  // Player 2
                      SizedBox(height: 16), // Spacing between Player 2 and Player 4
                      playerContainer(3),  // Player 4
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: rollDice,
                child: Text('Roll Dice'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  textStyle: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 20),
              Text(
                message,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to create a container for each player
  Widget playerContainer(int playerIndex) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: playerColors[playerIndex],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: Column(
        children: [
          Text(
            'Player ${playerIndex + 1}',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(
            'Score: ${scores[playerIndex]}',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
