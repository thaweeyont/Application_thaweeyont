import 'package:flutter/material.dart';

class EndPage extends StatelessWidget {
  const EndPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "สิ้นสุดหน้า",
            style: TextStyle(
              color: Colors.red[400],
              fontFamily: 'prompt',
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
