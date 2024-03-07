import 'package:flutter/material.dart';

import '../colours.dart';
import '../constants.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      elevation: 5.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: TColor.primaryColor1,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: TColor.white,
                borderRadius: BorderRadius.circular(30),
              ),
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: Image.asset(
                Constants.logo,
                width: 35,
                height: 35,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "CSAU Presents",
                    style: TextStyle(
                      color: TColor.white,
                      fontFamily: "PlayfairDisplay",
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    "Hunt Of Web Wanderer!",
                    style: TextStyle(
                      color: TColor.white,
                      fontFamily: "PlayfairDisplay",
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
