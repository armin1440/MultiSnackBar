# multi_snackbar

A set of commands that helps you display more than one snackbar at the same time.

## Getting Started

### Make a list of widgets:
~~~
var widgets = List.generate(3, (index) => Text('I am $index'));
~~~

### Show them as individual snackbars:
~~~
MultiSnackBarInterface.show(context: context, snackBars: widgets);
~~~

Just like that!

## Another Features

### Set maximum number of snackbars:
~~~
MultiSnackBarInterface.setMaxListLength(maxLength: 4);
~~~

### Set display time of snackbars:
~~~
MultiSnackBarInterface.setDisplayTime(displayTime: const Duration(seconds: 6));
~~~

### Close all snackbars:
~~~
MultiSnackBarInterface.clearAll(context: context);
~~~



#### Please give this package a star and follow me on github: https://github.com/armin1440 ;)
