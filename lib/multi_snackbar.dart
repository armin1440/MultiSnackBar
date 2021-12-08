///Written by Armin Rezaee on Dec 8, 2021

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///This class holds data of the MultiSnackBar
///such as :
/// the list of snackbars
/// display time
/// max number of snackbars
class _MultiSnackBarModel extends ChangeNotifier {
  _MultiSnackBarModel._();

  static final instance = _MultiSnackBarModel._();

  factory _MultiSnackBarModel() => instance;

  ///The list of snackbars that is going to be displayed
  List<Widget> _snackBarsList = <Widget>[];
  ///The max number of snackbars that is allowed to be displayed at the same time
  int? _maxListLength;
  ///The time which snackbars will automatically dismiss after
  Duration _displayTime = const Duration(seconds: 5);

  @override
  dispose() {}

  // void reset() {
  //   _snackBarsList = [];
  //   _maxListLength = null;
  //   _displayTime = const Duration(seconds: 5);
  // }

  List<Widget> get snackBarsList => _snackBarsList;

  ///Sets snackbars
  ///If max list length is not null, then an exception will be thrown if you try to
  ///display more snackbars using this method
  void trySetSnackBarsList({required List<Widget> newSnackBarsList}) {
    if (_maxListLength != null && newSnackBarsList.length > _maxListLength!) {
      throw Exception(
          "Snackbars length ( = ${newSnackBarsList.length} ) is larger than max length allowed ( = $_maxListLength ) ");
    }
    _snackBarsList = newSnackBarsList.map((e) => e).toList();
    notifyListeners();
  }

  ///Adds a list of widgets to the being displayed snackbars
  void addSnackBars({required List<Widget> toBeAddedSnackBar}) {
    _snackBarsList.addAll(toBeAddedSnackBar);
    notifyListeners();
  }

  ///Empties all snackbars
  void clearSnackBarList() {
    _snackBarsList = [];
    notifyListeners();
  }

  ///removes a snackbar
  void _removeSnackBar({required Widget toBeRemovedSnackBar}) {
    _snackBarsList.remove(toBeRemovedSnackBar);
    notifyListeners();
  }

  ///Dismissed a snackbar
  ///Also if there is not any other snackbars, it removes the whole parent snackbar
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

///The interface of this library
///used to interact with the programmer
class MultiSnackBarInterface {
  static final _MultiSnackBarModel _model = _MultiSnackBarModel();

  ///The list of snackbars' timers
  ///each timer holds the amount of time each snackbar will be dispalyed for
  ///when a timer expires it dismissed the corresponding snackbar
  static List<Timer> _timersList = <Timer>[];

  ///A boolean which holds the state of the parent snackbar
  ///false => parent snackbar is not being displayed
  ///true => parent snackbar is being displayed
  static bool _isShowingSnackbar = false;

  ///Initializes the snackbars list and the times list
  static void _init({required List<Widget> snackBars, required BuildContext context}) {
    _model.trySetSnackBarsList(newSnackBarsList: snackBars);
    _timersList.forEach((timer) => timer.cancel());
    _timersList.clear();
    _model.snackBarsList.forEach((snackBar) {
      _timersList.add(
        Timer(
          _model.displayTime,
          () => _onDismissSnackBar(toBeDismissedSnackBar: snackBar, context: context),
        ),
      );
    });
  }

  ///Shows a list of widgets as individual snackbars
  ///Each snackbar is dismissible independently and also it dismisses automatically when its timer expires
  ///The timer counts to displayTime which you can set it using setDisplayTime. By default it is 5 seconds
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
            onDismiss: (snackBar, context) => _onDismissSnackBar(toBeDismissedSnackBar: snackBar, context: context),
          ),
        ),
      );
      _isShowingSnackbar = true;
    }
  }

  ///Adds a snackbar to the displaying snackbars if there is enough space
  ///If there is not enough space, it adds as much snackbars as it is possible until reaching the limit
  ///You can set the limit using setMaxListLength
  static _add({required BuildContext context, required List<Widget> toBeAddedSnackBars}) {
    int listLength = _model.snackBarsList.length;
    int? freeSpace = _model.maxListLength == null ? null : _model.maxListLength! - listLength;
    if (freeSpace != null && freeSpace < toBeAddedSnackBars.length) {
      int neededSpace = toBeAddedSnackBars.length - freeSpace;
      _model.snackBarsList.removeRange(0, neededSpace);
      _timersList.getRange(0, neededSpace).forEach((timer) => timer.cancel());
      _timersList.removeRange(0, neededSpace);
    }
    _model.addSnackBars(toBeAddedSnackBar: toBeAddedSnackBars);
    toBeAddedSnackBars.forEach((toBeAddedSnackBar) {
      _timersList.add(
        Timer(
          _model.displayTime,
          () => _onDismissSnackBar(toBeDismissedSnackBar: toBeAddedSnackBar, context: context),
        ),
      );
    });
  }

  ///Dismisses a snackbar and removes its timer
  ///Finally if there is no being displayed snackbars, it sets isShowingSnackbar to false
  static void _onDismissSnackBar({required Widget toBeDismissedSnackBar, required BuildContext context}) {
    int snackIndex = _model.snackBarsList.indexOf(toBeDismissedSnackBar);
    _model.dismissSnackBar(toBeDismissedSnackBar: toBeDismissedSnackBar, context: context);
    _timersList.elementAt(snackIndex).cancel();
    _timersList.removeAt(snackIndex);
    if (_model.snackBarsList.isEmpty) {
      _isShowingSnackbar = false;
    }
  }

  ///Clears all of the being displayed snackbars
  static void clearAll({required BuildContext context}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    _model.clearSnackBarList();
    _timersList.forEach((timer) => timer.cancel());
    _timersList.clear();
    _isShowingSnackbar = false;
  }

  ///Sets the max number of snackbars which are being displayed at the same time
  ///If there are some snackbars being displayed at the moment of calling this,
  ///it will remove all extra top snackbars
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

  ///Sets the time which each snackbar is displayed for
  static void setDisplayTime({required Duration displayTime}){
    _model.setDisplayTime(displayTime: displayTime);
  }
}

///This class is only used to wrap view in ChangeNotifierProvider
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

///This widget is the view of snackbars
///There is a single flutter SnackBar that has all other snackbars as its child
///Each child has infinite width but the height is determined by the child
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
