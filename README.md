# multi_snackbar

A set of commands that helps you display more than one snackbar at the same time.

## Getting Started

### Make a widget:
~~~
var widget = Text('I am a widget');
~~~

### Show them as individual snackbars:
~~~
MultiSnackBarInterface.show(context: context, snackBar: widget);
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

