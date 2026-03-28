import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String judul;
  MyAppBar({super.key, required this.judul});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        elevation: 0,
        leading: TextButton(onPressed: () {
          Navigator.of(context).pop();
        }, child: Text("Batal", style: TextStyle(color: Color(0xFF147efb), fontSize: 16, fontWeight: FontWeight.w500),)),
        leadingWidth: 80,
        backgroundColor: Colors.transparent,
        title: Text(
          judul,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

