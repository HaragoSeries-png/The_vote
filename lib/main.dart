import 'dart:math';

import 'package:flutter/material.dart';
import 'package:imagebutton/imagebutton.dart';
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
      home: Mainpags(),
    );
  }
}

class Mainpags extends StatefulWidget {
  @override
  _MainpagsState createState() => _MainpagsState();
}

class _MainpagsState extends State<Mainpags> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('main'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0.0, 60, 0, 40),
              child: ImageButton(
                children: <Widget>[],
                width: 200,
                height: 200,
                label: Text('allrandom'),
                mainAxisAlignment: MainAxisAlignment.end,
                unpressedImage: Image.asset('assets/allrandom.jpg'),
                pressedImage: Image.asset('assets/allrandom.jpg'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => VoteList()));
                },
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0.0, 30, 0, 40),
              child: ImageButton(
                children: <Widget>[],
                width: 200,
                height: 200,
                label: Text('group'),
                mainAxisAlignment: MainAxisAlignment.end,
                unpressedImage: Image.asset('assets/grouping.png'),
                pressedImage: Image.asset('assets/grouping.png'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Groupb()));
                },
              ),
            ),
          ],
        ),
      ),
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
        appBar: AppBar(
          title: Text('All random'),
        ),
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

class Groupb extends StatefulWidget {
  @override
  _GroupbState createState() => _GroupbState();
}

class _GroupbState extends State<Groupb> {
  final TextEditingController _textController = new TextEditingController();
  final random = Random();
  List<String> li = ['a', 'b', 'c','d','e'];
  String S;
  List result = [];
  int ng = 2;

  @override
  void initState() {
    S = 'OOOO';
    super.initState();
  }

  void _updateResults(String text) {
    setState(() {
      li.add(text);
    });
    print(li.length);
  }

  void randd() {
    result = [];
    List pool = List.of(li);
    var retemp = [];
    var gsize = (li.length.toDouble() / ng.toDouble()).ceil();
    print(ng);
    for (var i = 0; i <  ng; i++) {
      for (var k = 0; k <gsize; k++) {
        print('----------');
        var re;
        print('in k ' + pool.length.toString());
        if (pool.length < gsize) {
          print('len ' + pool.length.toString());
          retemp = List.of(pool);
          pool = [];
          print(retemp);
          break;
        }
        re = random.nextInt(pool.length);
        var n = pool[re];
        retemp.add(n);
        print(n);
        pool.removeAt(re);
      }
      print('----------------------');
      setState(() {
        result.add(retemp);
      });
      retemp = [];
      if(pool.isEmpty){
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Groupby'),
        ),
        body: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
                child: TextField(
                  controller: _textController,
                  decoration: new InputDecoration(hintText: "Type in here!"),
                  onSubmitted: (text) {
                    print(li.length);
                    _updateResults(text);
                    _textController.clear();
                  },
                )),
            Row(
              children: [
                ElevatedButton(
                  onPressed: randd,
                  child: Text('Random'),
                  style: ElevatedButton.styleFrom(
                    primary: li.length == 0 ? Colors.teal : Colors.red,
                  ),
                ),
                DropdownButton(
                  value: ng,
                  items: li.map((String value,) {   
                    var v = li.indexOf(value)+1;             
                    return  DropdownMenuItem(
                      child: Text((v).toString()),
                      value: v,
                    );
                  }).toList(),
                  onChanged:(value){
                    
                    setState(() {
                      ng = value;
                    });
                  } ,
                ),
              ],
              
            ),
            
            Expanded(
                child: ListView.builder(
              itemCount: li.length,
              itemBuilder: (BuildContext context, int index) {
                var l = li[index];
                return ListTile(
                  title: Text(l),
                );
              },
            )),
            Text('result'),
            Expanded(
                child: ListView.builder(
              itemCount: result.length,
              itemBuilder: (BuildContext context, int index) {
                var l = result[index];
                return ListTile(title: Text(l.toString()));
              },
            )),
          ],
        ));
  }
}
