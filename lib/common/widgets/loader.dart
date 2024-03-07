import 'package:flutter/material.dart';

import '../colours.dart';

class Loader extends StatelessWidget {
  final String message;
  const Loader({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: TColor.primaryColor1,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              message,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: TColor.black,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
