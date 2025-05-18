import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: FareYakala(), debugShowCheckedModeBanner: false));
}

class FareYakala extends StatefulWidget {
  const FareYakala({super.key});

  @override
  _FareYakala createState() => _FareYakala();
}

class _FareYakala extends State<FareYakala> {
  final List<String> imagePaths = List.generate(
    9,
    (index) => 'lib/assets/images/R${index + 1}.png',
  );
  List<bool> isVisibleList = List.generate(9, (_) => false);
  List<bool> isClickedList = List.generate(9, (_) => false);
  int score = 0;
  int remainingTime = 120;
  Timer? gameTimer;
  Timer? imageTimer;
  bool isGameOver = false;

  void startGame() {
    score = 0;
    remainingTime = 120;
    isGameOver = false;

    gameTimer = Timer.periodic(Duration(milliseconds: 450), (timer) {
      setState(() {
        remainingTime--;
        if (remainingTime <= 0) {
          endGame();
        }
      });
    });

    imageTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      showRandomImage();
    });
  }

  void showRandomImage() {
    if (isGameOver) return;

    final random = Random();
    int index = random.nextInt(9);

    setState(() {
      isVisibleList[index] = true;
      isClickedList[index] = false;
    });

    Timer(Duration(seconds: 2), () {
      if (!isClickedList[index]) {
        setState(() {
          isVisibleList[index] = false;
        });
      }
    });
  }

  void endGame() {
    gameTimer?.cancel();
    imageTimer?.cancel();
    setState(() {
      isGameOver = true;
      isVisibleList = List.generate(9, (_) => false);
    });
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("⏰ Oyun Bitti!"),
            content: Text("Skorunuz: $score"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  startGame();
                },
                child: Text("Tekrardan Oyna."),
              ),
            ],
          ),
    );
  }

  @override
  void initState() {
    super.initState();
    startGame();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    imageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fare Yakalama Oyunu"),
        backgroundColor: Color.fromARGB(255, 194, 11, 11),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(child: Text("⏳ Kalan Süre $remainingTime s")),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(child: Text("⭐ Skorunuz: $score")),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          childAspectRatio: 0.6,

          children: List.generate(9, (index) {
            return GestureDetector(
              onTap: () {
                if (isVisibleList[index]) {
                  setState(() {
                    isClickedList[index] = true;
                    isVisibleList[index] = false;
                    score++;
                  });
                }
              },
              child: Visibility(
                visible: isVisibleList[index],
                child: Container(
                  child: Image.asset(
                    imagePaths[index],
                    fit: BoxFit.cover,
                    width: 15,
                    height: 15,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
