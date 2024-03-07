import 'dart:async';

import 'package:flutter/material.dart';

import '../colours.dart';
import '../utils.dart';

class LiveTimer extends StatefulWidget {
  final DateTime startTime;
  const LiveTimer({
    super.key,
    required this.startTime,
  });

  @override
  State<LiveTimer> createState() => _LiveTimerState();
}

class _LiveTimerState extends State<LiveTimer> {
  late StreamController<DateTime> _controller;
  late Stream<DateTime> _stream;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = StreamController<DateTime>();
    _stream = _controller.stream;
    _startTimer();
  }

  @override
  void dispose() {
    _controller.close();
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _controller.add(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Duration elapsedTime = snapshot.data!.difference(widget.startTime);

          return Text(
            formatDuration(elapsedTime),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          );
        } else {
          return CircularProgressIndicator(
            color: TColor.primaryColor1,
          );
        }
      },
    );
  }
}
