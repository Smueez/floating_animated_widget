### Features

- Support Android, IOS, Web etc.
- This package is used to make a widget movable or draggable around the screen freely;
- Works fine for any Widget;
- Does not affect the functionnality or permormance of the particilar widget;
- Used physics law supported animation to make it more attractive;


## Demo

![](https://raw.githubusercontent.com/Smueez/assets/d69fb817054f9f90796915078c9099f3e527d168/ezgif.com-gif-maker.gif)



### Getting started

####  Install
add this in your pubspec.yaml
`floating_animated_widget: ^leatest_version`

#### Class

This is the constructor fo the class.

    FloatingWidget({
		required this.child,
    	required this.floatingWidget,
		required this.floatingWidgetWidth,
    	required this.floatingWidgetHeight,
    	this.dy,
    	this.dx,
    	this.speed
		});

### Where:

-   **Child** is required and it accept any **widget**. This is actually the base Widget or the parent widget on where the floating widget will be dragged or moved.
-   **floatingWidget** is also required and it accept any **widget**. This is actually the particular widget which will be floated and can be modev or dragged around the screen.
-  **floatingWidgetWidth** is also required and it accepts a **double** value which is the width of the floating widget above mentioned.
-  **floatingWidgetHeight** is also required and it accepts a **double** value which is the height of the floating widget above mentioned.
-  **dy** accepts a **double** value which is the distance from the top of the screen where floating widget will be positioned initially .
-  **dx** accepts a **double** value which is the distance from the left of the screen where floating widget will be positioned initially.
-  **speed** accepts a **double** value which is the speed factor of the floating widget after it will be let go. The more **speed** will be provided the slower the object will move after the user let the widget go freely.

#### Usage　

```Dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return FloatingWidget(
      child: Scaffold(
        appBar: AppBar(

          title: Text(widget.title),
        ),
        body: Center(

          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      ),
      floatingWidget: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      floatingWidgetHeight: 40,
      floatingWidgetWidth: 40,
    );
  }
}

```
### Known Limitations
- Doesn't have functionnality of floating on other apps.
- It is different than mesenger is such way, you may put the draggable widget anywhere in the screen. it will not gonna align on the left or right of the screen. I did not implemented this feature cause this feature has already been made in other packages.
### End