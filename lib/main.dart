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
  late ConfettiController _confettiController;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  Timer? _timer;
  int _countdownSeconds = 5;
  String timerString = "00:05";
  bool isRunning = false;
  int _messageIndex = 0;

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
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..stop();

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _countdownSeconds = 5;
    setState(() {
      isRunning = true;
      _updateTimerString();
    });
    _controller.repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 0) {
        setState(() {
          _countdownSeconds--;
          _updateTimerString();
        });
      } else {
        timer.cancel();
        _controller.stop();
        setState(() {
          isRunning = false;
        });
        _displayConfetti();
      }
    });
  }

  void _updateTimerString() {
    final minutes = (_countdownSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_countdownSeconds % 60).toString().padLeft(2, '0');
    timerString = "$minutes:$seconds";
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    _confettiController.dispose();
    super.dispose();
  }

  void _displayConfetti() {
    _confettiController.play();
  }

  void _cycleMessage() {
    setState(() {
      _messageIndex = (_messageIndex + 1) % messages.length;
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
                scale: _scaleAnimation,
                child: SizedBox(
                  height: 400,
                  child: Image.asset('assets/images/heart.jpg'),
                ),
              ),
            ),
          ),

          // Confetti
          Center(
            child: ConfettiWidget(
              confettiController: _confettiController,
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
                messages[_messageIndex],
                key: ValueKey<int>(_messageIndex),
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
                    onPressed: _startTimer,
                    child: const Text('Start'),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _displayConfetti,
                    child: const Text('Confetti'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _cycleMessage,
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