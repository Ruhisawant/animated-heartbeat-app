// Team members: Ruhi Sawant and Saiesh Irukulla

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
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  Timer? _timer;
  int _countdownSeconds = 10;
  String timerString = "00:05";
  bool isRunning = false;

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
  }

  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _countdownSeconds = 5;
    setState(() {
      isRunning = true;
      final minutes = (_countdownSeconds ~/ 60).toString().padLeft(2, '0');
      final seconds = (_countdownSeconds % 60).toString().padLeft(2, '0');
      timerString = "$minutes:$seconds";
    });

    _controller.repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 0) {
        setState(() {
          _countdownSeconds--;
          final minutes = (_countdownSeconds ~/ 60).toString().padLeft(2, '0');
          final seconds = (_countdownSeconds % 60).toString().padLeft(2, '0');
          timerString = "$minutes:$seconds";
        });
      } else {
        timer.cancel();
        _controller.stop();
        setState(() {
          isRunning = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
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
            padding: const EdgeInsets.only(top: 0, left: 8, right: 8),
            child: Center(
              child: SizedBox(
                height: 800,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: SizedBox(
                          height: 400,
                          child: Image.asset(
                            'assets/images/heart.jpg',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Side buttons
          Positioned(
            top: 300, // button position
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
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Button 2'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Button 3'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Button 4'),
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
