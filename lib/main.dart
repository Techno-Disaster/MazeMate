import 'dart:async';
import 'package:flutter/material.dart';
import 'maze.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mazegen',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomePage(),
      );
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _maze;
  Iterator<Cell> _counter;

  @override
  void initState() {
    super.initState();
    go();
  }

  void go() {
    _maze = Maze(
        17, 17); // increase this if u want to increase complexity of the maze.
    _counter = _maze.generate().iterator;
    Timer.periodic(Duration(milliseconds: 1), onTick);
  }

  void onTick(Timer timer) {
    if (_counter.moveNext()) {
      setState(() {});
    } else {
      timer.cancel();
      _counter = null;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: Text(
            'MazeMate',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.grey,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber,
          onPressed: _counter == null ? go : null,
          child: Icon(Icons.refresh, color: Colors.black),
        ),
        body: Center(
          child: AspectRatio(
            aspectRatio: 1,
            child: Column(
              children: [
                for (var row = 0; row != _maze.rows; ++row)
                  Expanded(
                    child: Row(
                      children: [
                        for (var col = 0; col != _maze.cols; ++col)
                          Expanded(
                            child: CellView(
                              _maze.getCell(row,
                                  col), // Cellview sets border so that maze looks complete.
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}

class CellView extends StatelessWidget {
  final Cell cell;
  CellView(this.cell);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: _getBorderSide(Wall.top),
          left: _getBorderSide(Wall.left),
          right: _getBorderSide(Wall.right),
          bottom: _getBorderSide(Wall.bottom),
        ),
        color: cell.visited ? Colors.green : Colors.black,
      ),
    );
  }

  BorderSide _getBorderSide(Wall wall) => BorderSide(
      width: 5.0,
      style: cell.wallon[wall.index] ? BorderStyle.solid : BorderStyle.none);
}
