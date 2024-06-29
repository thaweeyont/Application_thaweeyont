import 'package:flutter/material.dart';

import '../utility/my_constant.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromRGBO(5, 12, 69, 1),
      iconTheme: const IconThemeData(
        color: Colors.white, //change your color here
      ),
      title: Text(
        title,
        style: MyContant().TitleStyle(),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
