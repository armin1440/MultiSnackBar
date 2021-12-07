import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _MultiSnackBarModel extends ChangeNotifier {
  static final instance = _MultiSnackBarModel._();

  _MultiSnackBarModel._();

  factory _MultiSnackBarModel() => instance;

  List<Widget> _snackBarsList = <Widget>[];
  List<Widget> get snackBarsList => _snackBarsList;
  void setSnackBarsList({required List<Widget> newSnackBarsList}){
    _snackBarsList = newSnackBarsList;
    notifyListeners();
  }
}

class MultiSnackBarController {
  static _MultiSnackBarModel model = _MultiSnackBarModel();

  static show({required BuildContext context, required List<Widget> snackBars}) {
    model.setSnackBarsList(newSnackBarsList: snackBars);
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(hours: 1),
        elevation: 0,
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        content: _MultiSnackBarWrapper(),
      ),
    );
  }
}

class _MultiSnackBarWrapper extends StatelessWidget {
  const _MultiSnackBarWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _MultiSnackBarModel(),
      child: const _MultiSnackBar(),
    );
  }
}

class _MultiSnackBar extends StatelessWidget {
  const _MultiSnackBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<_MultiSnackBarModel>(
      builder: (context, model, _) => Column(
        mainAxisSize: MainAxisSize.min,
        children: model._snackBarsList
            .map(
              (snackBar) => SizedBox(
                width: double.infinity,
                child: snackBar,
              ),
            )
            .toList(),
      ),
    );
  }
}
