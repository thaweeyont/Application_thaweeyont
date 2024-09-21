import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class LoadData extends StatelessWidget {
  const LoadData({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "กำลังโหลด",
            style: TextStyle(
              color: Colors.red[400],
              fontFamily: 'prompt',
              fontSize: 14,
            ),
          ),
          AnimatedTextKit(
            animatedTexts: [
              WavyAnimatedText(
                '.......',
                textStyle: TextStyle(
                  color: Colors.red[400],
                  fontFamily: 'prompt',
                  fontSize: 16,
                ),
              ),
              WavyAnimatedText(
                '.......',
                textStyle: TextStyle(
                  color: Colors.red[400],
                  fontFamily: 'prompt',
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
