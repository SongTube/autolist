import 'dart:math' as math;

import 'package:autolist/autolist.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> _items = [];

  void _addItem() {
    setState(() {
      final newIdx = math.Random().nextInt(_items.length + 1);
      final newValue = math.Random().nextInt(10000);
      _items.insert(newIdx, newValue);
    });
  }

  void _removeItem() {
    setState(() {
      if (_items.length == 0) {
        return;
      }

      final idx = math.Random().nextInt(_items.length);
      _items.removeAt(idx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: AutoList<int>(
        items: _items,
        duration: Duration(milliseconds: 400),
        itemBuilder: (context, item) {
          return Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(),
                    ),
                  ),
                  child: Text(
                    item.toString(),
                    key: Key(item.toString()),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: _removeItem,
            tooltip: 'Remove item',
            child: Icon(Icons.remove),
          ),
          FloatingActionButton(
            onPressed: _addItem,
            tooltip: 'Add item',
            child: Icon(Icons.add),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
