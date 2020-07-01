import 'package:flutter/material.dart';

class Cart extends StatelessWidget { // <- (※1)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("カート"), // <- (※2)
      ),
      body: Center(child: Text("カート") // <- (※3)
      ),
    );
  }
}