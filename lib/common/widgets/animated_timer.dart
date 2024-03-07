import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

import '../colours.dart';

class AnimatedTimer extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final Function(bool) onTimerFinished;

  const AnimatedTimer({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.onTimerFinished,
  }) : super(key: key);

  @override
  State<AnimatedTimer> createState() => _AnimatedTimerState();
}

class _AnimatedTimerState extends State<AnimatedTimer> {
  double _progress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _progress = (DateTime.now().difference(widget.startDate).inSeconds) /
            (widget.endDate.difference(widget.startDate).inSeconds);
      });
      if (_progress >= 1.0) {
        setState(() {
          _progress = 1.0;
        });
        timer.cancel();
        widget.onTimerFinished(true);
      }
    });
  }

  String _calculateTimeRemaining() {
    Duration remainingTime = widget.endDate.difference(DateTime.now());
    int minutes = remainingTime.inMinutes;
    int seconds = remainingTime.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Stack(
      children: [
        SimpleAnimationProgressBar(
          height: 20,
          width: media.width,
          backgroundColor: Colors.grey.shade100,
          foregrondColor: Colors.purple,
          ratio: _progress,
          direction: Axis.horizontal,
          curve: Curves.fastLinearToSlowEaseIn,
          duration: const Duration(seconds: 3),
          borderRadius: BorderRadius.circular(7.5),
          gradientColor: LinearGradient(
            colors: TColor.primaryG,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        Positioned(
          top: -2,
          left: 5,
          child: Center(
            child: Text(
              _progress != 1.0 ? _calculateTimeRemaining() : '0:00',
              style: TextStyle(
                color: TColor.secondaryColor1,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
