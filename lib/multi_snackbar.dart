import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _MultiSnackBarModel extends ChangeNotifier {
  _MultiSnackBarModel._();
  static final instance = _MultiSnackBarModel._();

  factory _MultiSnackBarModel() => instance;

  @override
  dispose(){}

  List<Widget> _snackBarsList = <Widget>[];
  List<Widget> get snackBarsList => _snackBarsList;
  void setSnackBarsList({required List<Widget> newSnackBarsList}){
    print(newSnackBarsList.length);
    _snackBarsList = newSnackBarsList;
    notifyListeners();
  }
  void addSnackBar({required Widget toBeAddedSnackBar}){
    _snackBarsList.add(toBeAddedSnackBar);
    notifyListeners();
  }
  void clearSnackBarList(){
    _snackBarsList = [];
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
        duration: Duration(hours: 4),
        elevation: 0,
        dismissDirection: DismissDirection.none,
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        content: _MultiSnackBarWrapper(),
      ),
    );
  }

  static add({required BuildContext context, required Widget toBeAddedSnackBar}){
    model.addSnackBar(toBeAddedSnackBar: toBeAddedSnackBar);
  }

  static clearAll({required BuildContext context}){
    ScaffoldMessenger.of(context).clearSnackBars();
    model.clearSnackBarList();
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
    _MultiSnackBarModel model = context.watch<_MultiSnackBarModel>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: model._snackBarsList
          .map(
            (snackBar) => SizedBox(
          width: double.infinity,
          child: snackBar,
        ),
      )
          .toList(),
    );
  }
}
