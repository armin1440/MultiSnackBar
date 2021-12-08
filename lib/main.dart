import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:listed_snack_bar/multi_snackbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> snackBars = [
      const Text('Hello world', style: TextStyle(color: Colors.red)),
      TextButton.icon(
        onPressed: () => print('pressed'),
        icon: const Icon(
          Icons.eighteen_mp_outlined,
          size: 33,
        ),
        label: const Text("Do not press me"),
        style: TextButton.styleFrom(backgroundColor: Colors.pink),
      ),
      const Icon(
        Icons.sixteen_mp,
        size: 18,
      ),
      Container(
        width: 20,
        height: 33,
        color: Colors.yellow,
      )
    ];

    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              TextButton(
                onPressed: () => MultiSnackBarController.show(context: context, snackBars: snackBars),
                child: const Text("show me what you got"),
              ),
              TextButton(
                onPressed: () => MultiSnackBarController.add(
                    context: context, toBeAddedSnackBar: const Text('Added', style: TextStyle(color: Colors.black))),
                child: const Text("Add sth"),
              ),
              TextButton(
                onPressed: () => MultiSnackBarController.clearAll(context: context),
                child: const Text('Clear'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
