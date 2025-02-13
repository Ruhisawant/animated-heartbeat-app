// Team members: Ruhi Sawant and Saiesh Irukulla
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Heartbeat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Animated Heartbeat App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late ConfettiController confettiController;
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  
  Timer? timer;
  int countdownSeconds = 5;
  String timerString = "00:05";
  bool isRunning = false;
  int messageIndex = 0;

  final List<String> messages = [
    "Will you be my Valentine?",
    "You are the beat of my heart!",
    "Happy Valentine's Day!",
    "You make my heart race!",
    "I love you"
  ];

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..stop();

    scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );

    confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  void startTimer() {
    if (timer != null) {
      timer!.cancel();
    }
    countdownSeconds = 5;
    setState(() {
      isRunning = true;
      updateTimerString();
    });
    controller.repeat(reverse: true);

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownSeconds > 0) {
        setState(() {
          countdownSeconds--;
          updateTimerString();
        });
      } else {
        timer.cancel();
        controller.stop();
        setState(() {
          isRunning = false;
        });
        displayConfetti();
      }
    });
  }

  void updateTimerString() {
    final minutes = (countdownSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (countdownSeconds % 60).toString().padLeft(2, '0');
    timerString = "$minutes:$seconds";
  }

  @override
  void dispose() {
    controller.dispose();
    timer?.cancel();
    confettiController.dispose();
    super.dispose();
  }

  void displayConfetti() {
    confettiController.play();
  }

  void cycleMessage() {
    setState(() {
      messageIndex = (messageIndex + 1) % messages.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: ScaleTransition(
                scale: scaleAnimation,
                child: SizedBox(
                  child: Image.asset('assets/images/heart2.png', height:800, fit:BoxFit.fill),
                ),
              ),
            ),
          ),

          // Confetti
          Center(
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.orange, Colors.green, Colors.blue, Colors.yellow, Colors.purple],
            ),
          ),

          // Message
          Positioned(
            top: 400,
            left: 0,
            right: 0,
            child: AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              child: Text(
                messages[messageIndex],
                key: ValueKey<int>(messageIndex),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          // Side buttons
          Positioned(
            top: 300,
            right: 200,
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    timerString,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: startTimer,
                    child: const Text('Start'),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: displayConfetti,
                    child: const Text('Confetti'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: cycleMessage,
                    child: const Text('Show Message'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}