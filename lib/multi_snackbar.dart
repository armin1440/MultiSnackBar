import 'package:flutter/material.dart';

class _MultiSnackBarController{
  final _MultiSnackBar _multiSnackBar = const _MultiSnackBar([]);

}


class _MultiSnackBar extends StatefulWidget {
  final List<Widget> content;

  const _MultiSnackBar({
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  State<_MultiSnackBar> createState() => _MultiSnackBarState();
}

class _MultiSnackBarState extends State<_MultiSnackBar> {
  late SnackBar snack;

  @override
  void initState() {
    super.initState();
    snack = SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(days: 1),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _snackBarList,
        )
    );
  }

  void _incrementCounter() {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    // ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // _showSnack = true;
    // timer?.cancel();
    // timer = Timer(const Duration(seconds: 5), () => setState(() {
    //   _showSnack = false;
    // }));

    setState(() {
      _counter++;
      if(_snackBarList.length > 3){
        _snackBarList.removeAt(0);
      }
      _snackBarList.add(
          _MultiSnackBar(Text("I am $_counter"))
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  @override
  Widget build(BuildContext context) {
    return _isNotClosed
        ? TextButton(
            onPressed: () => setState(() {
              _isNotClosed = !_isNotClosed;
            }),
            child: widget.content,
      style: TextButton.styleFrom(backgroundColor: Colors.greenAccent,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      ),
          )
        : const SizedBox();
  }
}
