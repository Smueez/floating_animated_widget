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
  @override
  Widget build(BuildContext context) {
    return FloatingDraggableWidget(
      floatingWidget: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add, size: 50),
      ),
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
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Floating Animated Widget'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Floating Animated Widget',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
