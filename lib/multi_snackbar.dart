import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _MultiSnackBarModel extends ChangeNotifier {
  _MultiSnackBarModel._();
  static final instance = _MultiSnackBarModel._();

  factory _MultiSnackBarModel() => instance;

  List<Widget> _snackBarsList = <Widget>[];
  int _maxListLength = 4;

  @override
  dispose(){}

  void reset(){
    _snackBarsList = [];
    _maxListLength = 4;
  }

  List<Widget> get snackBarsList => _snackBarsList;
  void setSnackBarsList({required List<Widget> newSnackBarsList}){
    _snackBarsList = newSnackBarsList;
    notifyListeners();
  }
  void addSnackBar({required Widget toBeAddedSnackBar}){
    if(_snackBarsList.length == _maxListLength){
      _snackBarsList.removeAt(0);
    }
    _snackBarsList.add(toBeAddedSnackBar);
    notifyListeners();
  }
  void clearSnackBarList(){
    _snackBarsList = [];
    notifyListeners();
  }

  void setMaxListLength({required int maxLength}){
    _maxListLength = maxLength;
    if(_snackBarsList.length > _maxListLength){
      int listLength = _snackBarsList.length;
      setSnackBarsList(newSnackBarsList: _snackBarsList.sublist(listLength - _maxListLength));
    }
  }
}

class MultiSnackBarController {
  static _MultiSnackBarModel _model = _MultiSnackBarModel();

  static show({required BuildContext context, required List<Widget> snackBars}) {
    _model.setSnackBarsList(newSnackBarsList: snackBars);
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
    _model.addSnackBar(toBeAddedSnackBar: toBeAddedSnackBar);
  }

  static clearAll({required BuildContext context}){
    ScaffoldMessenger.of(context).clearSnackBars();
    _model.clearSnackBarList();
  }

  static setMaxListLength({required int maxLength}){
    if(maxLength > 0){
      _model.setMaxListLength(maxLength: maxLength);
    }
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
