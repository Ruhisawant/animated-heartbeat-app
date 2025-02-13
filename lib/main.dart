// Team members: Ruhi Sawant and Saiesh Irukulla
//Updated
import 'package:flutter/material.dart';

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
  String timerString = "00:00";

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Text(
                    timerString,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Button 1'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Button 2'),
                ),
                const SizedBox(height: 10),
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
        ],
      ),
    );
  }
}