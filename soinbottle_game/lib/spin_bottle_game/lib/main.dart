import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(CoinFlipGame());

class CoinFlipGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coin Flip Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CoinFlipScreen(),
    );
  }
}

class CoinFlipScreen extends StatefulWidget {
  @override
  _CoinFlipScreenState createState() => _CoinFlipScreenState();
}

class _CoinFlipScreenState extends State<CoinFlipScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isHeads = true;
  bool isFlipping = false;
  String currentSide = "Heads";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    // Define the animation for a full flip (0 to 2 * pi)
    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Stop flipping animation once completed
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isFlipping = false;
          currentSide = isHeads ? "Heads" : "Tails";
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void flipCoin() {
    if (!isFlipping) {
      setState(() {
        isFlipping = true;
        isHeads = Random().nextBool(); // Decide the result of the coin flip here
      });
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coin Flip Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                // Apply scaling effect and shadow
                double scaleValue = (_animation.value < pi) ? 1.0 : 0.9; // Shrink slightly at the back

                // Calculate translation to simulate coin moving upwards
                double translationValue = -100 * sin(_animation.value); // Move the coin upwards
                
                return Transform(
                  alignment: Alignment.center,
                  // Combine the 3D flip and translation for the upward effect
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.002) // Perspective
                    ..rotateY(_animation.value)
                    ..translate(0.0, translationValue, 0.0), // Translate along Y-axis to simulate upward movement
                  child: Transform.scale(
                    scale: scaleValue, // Apply scaling here
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Ensure the shadow is circular
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: Offset(0, 5), // Apply shadow effect
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: _animation.value <= pi
                            ? Image.asset(
                                'images/heads.png',
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              )
                            : Transform(
                                transform: Matrix4.rotationY(pi), // Invert tails image
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'images/tails.png',
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 50),
            Text(
              isFlipping ? 'Flipping...' : 'Result: $currentSide',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: flipCoin,
              child: Text(
                'Flip Coin',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
