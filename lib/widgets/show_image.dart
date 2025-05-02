import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
  final String path;
  const ShowImage({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return Image.asset(path);
  }
}
