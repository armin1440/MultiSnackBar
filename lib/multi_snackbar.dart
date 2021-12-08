import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _MultiSnackBarModel extends ChangeNotifier {
  _MultiSnackBarModel._();

  static final instance = _MultiSnackBarModel._();

  factory _MultiSnackBarModel() => instance;

  List<Widget> _snackBarsList = <Widget>[];
  int? _maxListLength;
  Duration _displayTime = const Duration(seconds: 8);

  @override
  dispose() {}

  void reset() {
    _snackBarsList = [];
    _maxListLength = null;
    _displayTime = const Duration(seconds: 5);
  }

  List<Widget> get snackBarsList => _snackBarsList;

  void trySetSnackBarsList({required List<Widget> newSnackBarsList}) {
    if (_maxListLength != null && newSnackBarsList.length > _maxListLength!) {
      throw Exception(
          "Snackbars length ( = ${newSnackBarsList.length} ) is larger than max length allowed ( = $_maxListLength ) ");
    }
    _snackBarsList = newSnackBarsList.map((e) => e).toList();
    notifyListeners();
  }

  void addSnackBars({required List<Widget> toBeAddedSnackBar}) {
    _snackBarsList.addAll(toBeAddedSnackBar);
    notifyListeners();
  }

  void clearSnackBarList() {
    _snackBarsList = [];
    notifyListeners();
  }

  void _removeSnackBar({required Widget toBeRemovedSnackBar}) {
    _snackBarsList.remove(toBeRemovedSnackBar);
    notifyListeners();
  }

  void dismissSnackBar({required Widget toBeDismissedSnackBar, required BuildContext context}) {
    _removeSnackBar(toBeRemovedSnackBar: toBeDismissedSnackBar);
    if (_snackBarsList.isEmpty) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
    }
  }

  int? get maxListLength => _maxListLength;

  void setMaxListLength({required int maxLength}) {
    _maxListLength = maxLength;
  }

  Duration get displayTime => _displayTime;

  void setDisplayTime({required Duration displayTime}) {
    _displayTime = displayTime;
  }
}

class MultiSnackBarInterface {
  static final _MultiSnackBarModel _model = _MultiSnackBarModel();
  static List<Timer> _timersList = <Timer>[];
  static bool _isShowingSnackbar = false;

  static void _init({required List<Widget> snackBars, required BuildContext context}) {
    _model.trySetSnackBarsList(newSnackBarsList: snackBars);
    _timersList.forEach((timer) => timer.cancel());
    _timersList.clear();
    _model.snackBarsList.forEach((snackBar) {
      _timersList.add(
        Timer(
          _model.displayTime,
          () => onDismissSnackBar(toBeDismissedSnackBar: snackBar, context: context),
        ),
      );
    });
  }

  static void show({required BuildContext context, required List<Widget> snackBars}) {
    if (_isShowingSnackbar) {
      _add(context: context, toBeAddedSnackBars: snackBars);
    }
    else{
      _init(snackBars: snackBars, context: context);
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(hours: 12),
          elevation: 0,
          dismissDirection: DismissDirection.none,
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          content: _MultiSnackBarWrapper(
            onDismiss: (snackBar, context) => onDismissSnackBar(toBeDismissedSnackBar: snackBar, context: context),
          ),
        ),
      );
      _isShowingSnackbar = true;
    }
  }

  static _add({required BuildContext context, required List<Widget> toBeAddedSnackBars}) {
    int listLength = _model.snackBarsList.length;
    if (_model.maxListLength != null && listLength == _model.maxListLength) {
      _model.snackBarsList.removeRange(0, toBeAddedSnackBars.length);
      _timersList.getRange(0, toBeAddedSnackBars.length).forEach((timer) => timer.cancel());
      _timersList.removeRange(0, toBeAddedSnackBars.length);
    }
    _model.addSnackBars(toBeAddedSnackBar: toBeAddedSnackBars);
    toBeAddedSnackBars.forEach((toBeAddedSnackBar) {
      _timersList.add(
        Timer(
          _model.displayTime,
          () => onDismissSnackBar(toBeDismissedSnackBar: toBeAddedSnackBar, context: context),
        ),
      );
    });
  }

  static void onDismissSnackBar({required Widget toBeDismissedSnackBar, required BuildContext context}) {
    int snackIndex = _model.snackBarsList.indexOf(toBeDismissedSnackBar);
    _model.dismissSnackBar(toBeDismissedSnackBar: toBeDismissedSnackBar, context: context);
    _timersList.elementAt(snackIndex).cancel();
    _timersList.removeAt(snackIndex);
    if (_model.snackBarsList.isEmpty) {
      _isShowingSnackbar = false;
    }
  }

  static void clearAll({required BuildContext context}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    _model.clearSnackBarList();
    _timersList.forEach((timer) => timer.cancel());
    _timersList.clear();
    _isShowingSnackbar = false;
  }

  static void setMaxListLength({required int maxLength}) {
    if (maxLength > 0) {
      _model.setMaxListLength(maxLength: maxLength);
      if (_model.maxListLength != null && _model.snackBarsList.length > _model.maxListLength!) {
        int listLength = _model.snackBarsList.length;
        _model.trySetSnackBarsList(newSnackBarsList: _model.snackBarsList.sublist(listLength - _model.maxListLength!));
        _timersList.sublist(0, listLength - _model.maxListLength!).forEach((timer) => timer.cancel());
        _timersList = _timersList.sublist(listLength - _model.maxListLength!);
      }
    }
  }
}

class _MultiSnackBarWrapper extends StatelessWidget {
  final Function(Widget, BuildContext) onDismiss;

  const _MultiSnackBarWrapper({
    required this.onDismiss,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _MultiSnackBarModel(),
      child: _MultiSnackBar(onDismiss: onDismiss),
    );
  }
}

class _MultiSnackBar extends StatelessWidget {
  final Function(Widget, BuildContext) onDismiss;

  const _MultiSnackBar({
    required this.onDismiss,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _MultiSnackBarModel model = context.watch<_MultiSnackBarModel>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: model.snackBarsList
          .map(
            (snackBar) => Dismissible(
              key: UniqueKey(),
              onDismissed: (_) => onDismiss(snackBar, context),
              child: SizedBox(
                width: double.infinity,
                child: snackBar,
              ),
            ),
          )
          .toList(),
    );
  }
}
