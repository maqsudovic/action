import 'package:flutter/material.dart';

class Sellerpage extends StatefulWidget {
  const Sellerpage({super.key});

  @override
  State<Sellerpage> createState() => _SellerpageState();
}

class _SellerpageState extends State<Sellerpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Seller page"),
      ),
    );
  }
}
