import 'dart:math';

import 'package:flutter/material.dart';
import 'listitem.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The vote',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: VoteList(),
    );
  }
}

class VoteList extends StatefulWidget {
  @override
  _VoteListState createState() => _VoteListState();
}

class _VoteListState extends State<VoteList> {
  final TextEditingController _textController = new TextEditingController();
  final random = Random();
  List<Canditems> li = [];
  String S;
  String result;
  @override
  void initState() {
    S = 'OOOO';
    super.initState();
  }

  void _updateResults(Canditems text) {
    setState(() {
      li.add(text);
    });
    print(li.length);
  }

  void randd() {
    var re = random.nextInt(li.length);
    setState(() {
      result = li[re].name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
            child: TextField(
              controller: _textController,
              decoration: new InputDecoration(hintText: "Type in here!"),
              onSubmitted: (text) {
                print(li.length);
                var t = Canditems(text, 0.0);
                _updateResults(t);
                _textController.clear();
              },
            )),
        ElevatedButton(
          onPressed: randd,
          child: Text('Random'),
          style: ElevatedButton.styleFrom(
            primary: li.length == 0 ? Colors.teal : Colors.red,
          ),
        ),
        Text((result == null
            ? 'please input '
            : "Result is :" + result.toString())),
        Expanded(
            child: ListView.builder(
          itemCount: li.length,
          itemBuilder: (BuildContext context, int index) {
            var l = li[index];
            return ListTile(
              title: Text(l.name),
            );
          },
        )),
      ],
    ));
  }
}
