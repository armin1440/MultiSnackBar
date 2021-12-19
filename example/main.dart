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
    //This is optional. By default it is 4.
    MultiSnackBarInterface.setMaxListLength(maxLength: 3);
    //This is optional. By default it is 4 seconds.
    MultiSnackBarInterface.setDisplayTime(displayTime: const Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  MultiSnackBarInterface.show(
                    // isCustom: true,
                    // margin: const EdgeInsets.all(12),
                    // shadowColor: Colors.yellow,
                    context: context,
                    snackBar: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        'Added',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  );
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
