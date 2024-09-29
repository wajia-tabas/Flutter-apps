import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';  // Import provider

// Main function to run the app
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GameData(),
      child: MyApp(),
    ),
  );
}

// Game data class to hold player names, scores, and bottle selection
class GameData extends ChangeNotifier {
  List<String> playerNames = [];
  Map<String, int> playerScores = {};
  String selectedBottle = 'bottle.png'; // Default bottle

  void addPlayer(String name) {
    if (playerNames.length < 10 && name.isNotEmpty) {
      playerNames.add(name);
      playerScores[name] = 0;
      notifyListeners();
    }
  }

  void selectBottle(String bottle) {
    selectedBottle = bottle;
    notifyListeners();
  }

  void incrementScore(String playerName) {
    playerScores[playerName] = (playerScores[playerName] ?? 0) + 1;
    notifyListeners();
  }

  void resetGame() {
    playerNames.clear();
    playerScores.clear();
    notifyListeners();
  }
}

// MyApp widget which defines the app's structure
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spin the Bottle Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

// HomeScreen where the game starts
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spin the Bottle Game'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GameScreen()),
            );
          },
          child: Text('Start Game'),
        ),
      ),
    );
  }
}

// GameScreen which handles the gameplay, player input, bottle spin, and challenges
class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  TextEditingController _nameController = TextEditingController();
  List<String> challenges = [
    'Do 10 push-ups',
    'Sing a song',
    'Dance for 30 seconds',
    'Tell a joke',
    'Imitate a celebrity',
  ];
  String selectedChallenge = '';
  double _bottleAngle = 0.0;
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _animation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeOut,
    );
    _controller!.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  void spinBottle() {
    var random = Random();
    double spin = random.nextDouble() * 2 * pi; // Random spin angle
    setState(() {
      _bottleAngle = spin; // Set the spin angle
    });
    _controller!.forward(from: 0).then((value) => selectRandomPlayer());
  }

  void selectRandomPlayer() {
    var gameData = Provider.of<GameData>(context, listen: false);
    if (gameData.playerNames.isNotEmpty) {
      var random = Random();
      int selectedIndex = random.nextInt(gameData.playerNames.length);
      String selectedPlayer = gameData.playerNames[selectedIndex];
      setState(() {
        selectedChallenge = challenges[random.nextInt(challenges.length)];
      });
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Challenge for $selectedPlayer'),
          content: Text(selectedChallenge),
          actions: [
            ElevatedButton(
              onPressed: () {
                gameData.incrementScore(selectedPlayer);
                Navigator.pop(context);
              },
              child: Text('Complete Challenge'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var gameData = Provider.of<GameData>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Spin the Bottle'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Enter player name'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              gameData.addPlayer(_nameController.text);
              _nameController.clear();
            },
            child: Text('Add Player'),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset('images/${gameData.selectedBottle}'), // Bottle image
                Transform.rotate(
                  angle: _animation!.value * _bottleAngle,
                  child: Image.asset('images/bottle.png', width: 100, height: 100),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: spinBottle,
            child: Text('Spin Bottle'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: gameData.playerNames.length,
              itemBuilder: (context, index) {
                String player = gameData.playerNames[index];
                return ListTile(
                  title: Text(player),
                  subtitle: Text('Score: ${gameData.playerScores[player]}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 