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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    MultiSnackBarInterface.setMaxListLength(maxLength: 4);
    MultiSnackBarInterface.setDisplayTime(displayTime: const Duration(seconds: 6));
  }

  @override
  Widget build(BuildContext context) {
    var random = Random.secure();

    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  // try{
                  MultiSnackBarInterface.show(
                    context: context,
                    snackBars: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Color.fromRGBO(random.nextInt(255), random.nextInt(255), random.nextInt(255), 1),
                        child: const Text(
                          'Added',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    ],
                  );
                  // }
                  // catch(e){
                  //   print('caught');
                  // }
                },
                child: const Text("show me what you got"),
              ),
              TextButton(
                onPressed: () => MultiSnackBarInterface.clearAll(context: context),
                child: const Text('Clear'),
              ),
              SizedBox(
                height: 20,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Max List Length'),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        onSubmitted: (max) => MultiSnackBarInterface.setMaxListLength(maxLength: int.parse(max)),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
