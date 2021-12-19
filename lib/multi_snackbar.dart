import 'dart:async';
import 'package:flutter/material.dart';

///The interface of this package
class MultiSnackBarInterface {
  ///the list of being displayed snackBars
  static late ListModel<Widget> _snackBarList;

  ///The key used by the animated list
  static late GlobalKey<AnimatedListState> _listKey;

  ///Max number of snackbars being displayed at the same time
  static int _maxListLength = 4;

  ///The length of time which a snackBar is shown for
  static Duration _displayTime = const Duration(seconds: 4);

  ///The list of snackbars' timers
  ///each timer holds the amount of time each snackbar will be dispalyed for
  ///when a timer expires it dismissed the corresponding snackbar
  static final List<Timer> _timersList = <Timer>[];

  ///A boolean which holds the state of the parent snackbar
  ///false => parent snackbar is not being displayed
  ///true => parent snackbar is being displayed
  static bool _isShowingSnackBar = false;

  ///Initializes the snackbars list and the timers list
  static void _init({
    required Widget snackBar,
    required BuildContext context,
    bool isCustom = false,
    EdgeInsets? margin,
    Clip? clipBehavior,
    bool? borderOnForeground,
    bool? semanticContainer,
    Color? shadowColor,
    ShapeBorder? shape,
  }) {
    _listKey = GlobalKey<AnimatedListState>();
    _snackBarList = ListModel<Widget>(
      listKey: _listKey,
      initialItems: <Widget>[snackBar],
      removedItemBuilder: (Widget item, BuildContext context, Animation<double> animation) =>
          SnackBarItem(
              isCustom: isCustom,
              animation: animation,
              child: item,
              margin: margin,
              clipBehavior: clipBehavior,
              borderOnForeground: borderOnForeground,
              semanticContainer: semanticContainer,
              shadowColor: shadowColor,
              shape: shape),
    );

    for (Timer timer in _timersList) {
      timer.cancel();
    }
    _timersList.clear();
    for (int i = 0; i < _snackBarList.length; i++) {
      _timersList.add(
        Timer(
          _displayTime,
          () => _onDismissSnackBar(toBeDismissedSnackBar: snackBar, context: context),
        ),
      );
    }
  }

  ///Shows a list of widgets as individual snackbars
  ///[snackBar] is the widget that is going to be added
  ///set [isCustom] to true when you do not want to use the default widget (the pink Card)
  ///if you do not want to use custom widget you can also set the Card's properties
  static void show({
    required BuildContext context,
    required Widget snackBar,
    bool isCustom = false,
    EdgeInsets? margin,
    Clip? clipBehavior,
    bool? borderOnForeground,
    bool? semanticContainer,
    Color? shadowColor,
    ShapeBorder? shape,
  }) {
    if (_isShowingSnackBar) {
      _add(context: context, toBeAddedSnackBar: snackBar);
    } else {
      _init(
        snackBar: snackBar,
        context: context,
        margin: margin,
        clipBehavior: clipBehavior,
        borderOnForeground: borderOnForeground,
        semanticContainer: semanticContainer,
        shadowColor: shadowColor,
        shape: shape,
      );
      _isShowingSnackBar = true;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(hours: 12),
          elevation: 0,
          dismissDirection: DismissDirection.none,
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          content: AnimatedSnackBarList(
            listKey: _listKey,
            buildItem: (BuildContext context, int index, Animation<double> animation) => SnackBarItem(
                isCustom: isCustom,
                animation: animation,
                child: _snackBarList[index],
                margin: margin,
                clipBehavior: clipBehavior,
                borderOnForeground: borderOnForeground,
                semanticContainer: semanticContainer,
                shadowColor: shadowColor,
                shape: shape),
          ),
        ),
      );
    }
  }

  ///Adds a snackbar to the displaying snackbars if there is enough space
  ///If there is not enough space, it removes the first snackBar then adds the new one
  static _add({required BuildContext context, required Widget toBeAddedSnackBar}) {
    int listLength = _snackBarList.length;
    int freeSpace = _maxListLength - listLength;
    if (freeSpace == 0) {
      _snackBarList.removeAt(0);
      _timersList.elementAt(0).cancel();
      _timersList.removeAt(0);
    } else if (freeSpace < 0) {
      return;
    }
    _snackBarList.insert(_snackBarList.length, toBeAddedSnackBar);

    _timersList.add(
      Timer(
        _displayTime,
        () => _onDismissSnackBar(toBeDismissedSnackBar: toBeAddedSnackBar, context: context),
      ),
    );
  }

  ///Dismisses a snackbar and removes its timer
  ///Finally if there is no being displayed snackbars, it sets [_isShowingSnackBar] to false
  static void _onDismissSnackBar({required Widget toBeDismissedSnackBar, required BuildContext context}) {
    int snackBarIndex = _snackBarList.indexOf(toBeDismissedSnackBar);
    _timersList.elementAt(snackBarIndex).cancel();
    _timersList.removeAt(snackBarIndex);
    _snackBarList.removeAt(snackBarIndex);
    if (_snackBarList.length == 0) {
      _isShowingSnackBar = false;
      ScaffoldMessenger.of(context).clearSnackBars();
    }
  }

  ///Clears all of the being displayed snackbars
  static void clearAll({required BuildContext context}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    for (int i = 0; i < _snackBarList.length; i++) {
      _snackBarList.removeAt(0);
    }
    for (Timer timer in _timersList) {
      timer.cancel();
    }
    _timersList.clear();
    _isShowingSnackBar = false;
  }

  ///Sets the max number of snackbars
  static void setMaxListLength({required int maxLength}) {
    if (maxLength > 0) {
      _maxListLength = maxLength;
    }
  }

  ///Sets the time which each snackBar is displayed for
  static void setDisplayTime({required Duration displayTime}) {
    _displayTime = displayTime;
  }
}

class AnimatedSnackBarList extends StatelessWidget {
  final GlobalKey<AnimatedListState> listKey;
  final Widget Function(BuildContext, int, Animation<double>) buildItem;

  const AnimatedSnackBarList({
    Key? key,
    required this.buildItem,
    required this.listKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: listKey,
      initialItemCount: 1,
      itemBuilder: buildItem,
      shrinkWrap: true,
    );
  }
}

///A wrapper that wraps around the given snackBar widget
class SnackBarItem extends StatelessWidget {
  const SnackBarItem({
    Key? key,
    required this.animation,
    required this.child,
    required this.isCustom,
    this.margin,
    this.clipBehavior,
    this.borderOnForeground,
    this.semanticContainer,
    this.shadowColor,
    this.shape,
  }) : super(key: key);

  final Animation<double> animation;
  final Widget child;
  final bool isCustom;
  final EdgeInsets? margin;
  final Clip? clipBehavior;
  final bool? borderOnForeground;
  final bool? semanticContainer;
  final Color? shadowColor;
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: SizeTransition(
        sizeFactor: animation,
        child: isCustom
            ? child
            : SizedBox(
                width: double.infinity,
                child: Card(
                  margin: margin,
                  clipBehavior: clipBehavior,
                  borderOnForeground: borderOnForeground ?? true,
                  semanticContainer: semanticContainer ?? true,
                  shadowColor: shadowColor,
                  shape: shape,
                  elevation: 3,
                  color: Colors.pink.withOpacity(0.4),
                  child: child,
                ),
              ),
      ),
    );
  }
}

typedef RemovedItemBuilder<T> = Widget Function(T item, BuildContext context, Animation<double> animation);

/// Keeps a Dart [List] in sync with an [AnimatedSnackBarList].
///
/// The [insert] and [removeAt] methods apply to both the internal list and
/// the animated list that belongs to [listKey].
///
/// This class only exposes as much of the Dart List API as is needed by the
/// sample app. More list methods are easily added, however methods that
/// mutate the list must make the same changes to the animated list in terms
/// of [AnimatedListState.insertItem] and [AnimatedSnackBarList.removeItem].
class ListModel<E> {
  ListModel({
    required this.listKey,
    required this.removedItemBuilder,
    Iterable<E>? initialItems,
  }) : _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<AnimatedListState> listKey;
  final RemovedItemBuilder<E> removedItemBuilder;
  final List<E> _items;

  AnimatedListState? get _animatedList => listKey.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList!.insertItem(index);
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList!.removeItem(
        index,
        (BuildContext context, Animation<double> animation) {
          return removedItemBuilder(removedItem, context, animation);
        },
      );
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}
