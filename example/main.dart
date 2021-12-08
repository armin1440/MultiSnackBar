import 'dart:math';

import 'package:flutter/material.dart';
import 'package:multi_snackbar/multi_snackbar.dart';

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
    //This is optional. By default there is no limit.
    MultiSnackBarInterface.setMaxListLength(maxLength: 4);
    //This is optional. By default it is 5 seconds.
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
                  //You should wrap show method in try-catch block when there is a max number of snackbars limit
                  //because you might get an exception when you want to show more snackbars than the limit

                  try{
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
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Color.fromRGBO(random.nextInt(255), random.nextInt(255), random.nextInt(255), 1),
                        child: const Text(
                          'Added',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
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
                  }
                  catch(e){
                    // print(e.toString());
                  }
                },
                child: const Text("Add a snackbar"),
              ),
              TextButton(
                onPressed: () => MultiSnackBarInterface.clearAll(context: context),
                child: const Text('Clear All'),
              ),
              SizedBox(
                height: 20,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Set Max List Length'),
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
