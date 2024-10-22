import 'package:floating_draggable_widget/floating_widget_controller.dart';
import 'package:flutter/material.dart';

import 'package:floating_draggable_widget/floating_draggable_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Floating Draggable Widget',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ///floating widget visibility initially set to false
  final FloatingWidgetController floatingWidgetController = FloatingWidgetController(false);

  @override
  Widget build(BuildContext context) {
    return FloatingDraggableWidget(
      controller: floatingWidgetController,
      floatingWidget: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add, size: 50),
      ),
      onDragEvent: (dx, dy) {
        print("$dx, $dy");
      },
      onDragging: (val) {
        print("on dragging $val");
      },
      autoAlign: true,
      disableBounceAnimation: true,
      // autoAlignType: AlignmentType.both,
      floatingWidgetHeight: 90,
      floatingWidgetWidth: 90,
      dx: 200,
      dy: 300,
      deleteWidgetDecoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white12, Colors.grey],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [.0, 1],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      deleteWidget: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 2, color: Colors.black87),
        ),
        child: const Icon(Icons.close, color: Colors.black87),
      ),
      onDeleteWidget: () {
        debugPrint('Widget deleted');
      },
      mainScreenWidget: Scaffold(
        appBar: AppBar(
          title: const Text('Floating Animated Widget'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Floating Animated Widget',
              ),
              ElevatedButton(
                  onPressed: () {
                    //example to show the floating widget
                    setState(() {
                      floatingWidgetController.show();
                    });
                  },
                  child: const Text("Show")),
              ElevatedButton(
                  onPressed: () {
                    //example to hide the floating widget
                    setState(() {
                      floatingWidgetController.hide();
                    });
                  },
                  child: const Text("Show")),
              ElevatedButton(
                  onPressed: () {
                    //example to toggle the floating widget state
                    setState(() {
                      floatingWidgetController.toggle();
                    });
                  },
                  child: const Text("Toggle"))
            ],
          ),
        ),
      ),
    );
  }
}
