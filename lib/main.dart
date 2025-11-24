import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cronometro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const StopwatchPage(),
    );
  }
}

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  // Stream controllers
  final StreamController<int> _tickStreamController = StreamController<int>();
  final StreamController<int> _secondStreamController = StreamController<int>();

  // Timer
  Timer? _tickTimer;
  Timer? _secondTimer;

  // Variabili
  int _tickCount = 0;
  int _seconds = 0;
  bool _isRunning = false;
  bool _isPaused = false;

  @override
  void dispose() {
    _tickTimer?.cancel();
    _secondTimer?.cancel();
    _tickStreamController.close();
    _secondStreamController.close();
    super.dispose();
  }

  void _startStopwatch() {
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });

    // Stream tick ogni 200ms
    _tickTimer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      _tickCount++;
      _tickStreamController.add(_tickCount);
    });

    // Stream secondi ogni 1000ms
    _secondTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _seconds++;
      _secondStreamController.add(_seconds);
    });
  }

  void _stopStopwatch() {
    _tickTimer?.cancel();
    _secondTimer?.cancel();
    setState(() {
      _isRunning = false;
      _isPaused = false;
    });
  }

  void _resetStopwatch() {
    _tickTimer?.cancel();
    _secondTimer?.cancel();
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _tickCount = 0;
      _seconds = 0;
    });
    _tickStreamController.add(0);
    _secondStreamController.add(0);
  }

  void _pauseStopwatch() {
    _tickTimer?.cancel();
    _secondTimer?.cancel();
    setState(() {
      _isPaused = true;
    });
  }

  void _resumeStopwatch() {
    setState(() {
      _isPaused = false;
    });

    _tickTimer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      _tickCount++;
      _tickStreamController.add(_tickCount);
    });

    _secondTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _seconds++;
      _secondStreamController.add(_seconds);
    });
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Cronometro'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display del tempo
                  StreamBuilder<int>(
                    stream: _secondStreamController.stream,
                    initialData: 0,
                    builder: (context, snapshot) {
                      return Text(
                        _formatTime(snapshot.data!),
                        style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 40),
                  // Display dei tick
                  StreamBuilder<int>(
                    stream: _tickStreamController.stream,
                    initialData: 0,
                    builder: (context, snapshot) {
                      return Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Tick: ${snapshot.data}',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.grey[700],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Pulsanti
          Padding(
            padding: EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Pulsante START/STOP
                ElevatedButton(
                  onPressed: () {
                    if (!_isRunning && _seconds == 0) {
                      _startStopwatch();
                    } else if (_isRunning || _isPaused) {
                      _stopStopwatch();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        (!_isRunning && _seconds == 0) ? Colors.green : Colors.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text(
                    (!_isRunning && _seconds == 0) ? 'START' : 'STOP',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(width: 16),
                // Pulsante PAUSE/RESUME/RESET
                ElevatedButton(
                  onPressed: () {
                    if (!_isRunning && _seconds > 0) {
                      _resetStopwatch();
                    } else if (_isRunning && !_isPaused) {
                      _pauseStopwatch();
                    } else if (_isPaused) {
                      _resumeStopwatch();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isPaused
                        ? Colors.orange
                        : (!_isRunning && _seconds > 0)
                            ? Colors.grey
                            : Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text(
                    (!_isRunning && _seconds > 0)
                        ? 'RESET'
                        : _isPaused
                            ? 'RESUME'
                            : 'PAUSE',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
