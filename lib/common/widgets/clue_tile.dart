import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/googlecode.dart';

import '../colours.dart';
import '../constants.dart';

class ClueTile extends StatelessWidget {
  final int clueNumber;

  const ClueTile({
    super.key,
    required this.clueNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: TColor.primaryG,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Clue ${clueNumber + 1}',
            style: TextStyle(
              color: TColor.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8.0),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: HighlightView(
                Constants.clues[clueNumber]['code'],
                language: 'cpp',
                theme: googlecodeTheme,
                padding: const EdgeInsets.all(10),
                textStyle: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
