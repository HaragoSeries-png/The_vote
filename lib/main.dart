import 'dart:async';
import 'dart:math';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter/material.dart';
import 'package:imagebutton/imagebutton.dart';
import 'package:sqflite/sqlite_api.dart';
import 'listitem.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'database_helper.dart';
import 'package:provider/provider.dart';

class Store extends ChangeNotifier {
  var li = <String>[];

  void add(data) {
    li.add(data);
    notifyListeners();
  }

  void remove(data) {
    li.remove(data);
    notifyListeners();
  }

  void changecategory(cat) {
    print(cat);
    if (cat == 'food') {
      li = ['ต้มยำ', 'กระเพรา', 'ข้าวผัด'];
    } else if (cat == 'travel') {
      li = ['หัวหีน', 'ทะเล', 'ภูเขา', 'ภูเรา'];
    } else if (cat == 'luck') {
      li = [
        'เกลือ',
        'เกลือมาก',
        'เกลือที่สุด',
        'เกลื่อเหมือนกันอแต่เป็นสีเขียว'
      ];
    }
    notifyListeners();
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return Store();
        })
      ],
      child: MaterialApp(
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
      ),
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
  StreamController<int> controller = StreamController<int>();
  final TextEditingController _textController = new TextEditingController();
  final db = DatabaseHelper.instace;
  final random = Random();

  String S;
  String result;
  @override
  void initState() {
    S = 'OOOO';
    super.initState();
  }

  void _updateResults(Canditems text) {
    setState(() {});
  }

  // void randd() {
  //   var re = random.nextInt(li.length);
  //   setState(() {
  //     result = li[re].name;
  //   });
  // }

  void showmore() {
    showCupertinoModalBottomSheet(
        context: context, builder: (context) => Showcurrent());
  }

  void showtrend() {
    showCupertinoModalBottomSheet(
        context: context, builder: (context) => Trendshow());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('All random'),
        ),
        body: Consumer(
          builder: (context, Store provider, Widget child) {
            return Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
                    child: TextField(
                      controller: _textController,
                      decoration:
                          new InputDecoration(hintText: "Type in here!"),
                      onSubmitted: (text) {
                        var t = provider.add(text);

                        _textController.clear();
                      },
                    )),
                // ElevatedButton(
                //   onPressed: randd,
                //   child: Text('Random'),
                //   style: ElevatedButton.styleFrom(
                //     primary: li.length > 1 ? Colors.teal : Colors.grey,
                //   ),
                // ),
                Text((result == null
                    ? 'please input '
                    : "Result is :" + result.toString())),
                // Expanded(
                //     child: ListView.builder(
                //   itemCount: li.length,
                //   itemBuilder: (BuildContext context, int index) {
                //     var l = li[index];
                //     return ListTile(
                //       title: Text(l.name),
                //     );
                //   },
                // )),
                Expanded(
                  child: provider.li.length > 1
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(16.0,0,0,0),
                          child: FortuneWheel(
                              // changing the return animation when the user stops dragging
                              physics: CircularPanPhysics(
                                duration: Duration(seconds: 3),
                                curve: Curves.decelerate,
                              ),
                              onFling: () {
                                controller.add(1);
                              },
                              selected: controller.stream,
                              items: (provider.li.length > 1
                                  ? provider.li.map((e) {
                                      return FortuneItem(                             
                                        child: Container(
                                          padding: const EdgeInsets.all(16.0),
                                          
                                          child: Text(e.toString(),style: TextStyle(fontSize: 16)))
                                      );
                                    }).toList()
                                  : [
                                      FortuneItem(child: Text('now ')),
                                      FortuneItem(child: Text('now '))
                                    ])),
                        )
                      : Text('add more'),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: showmore,
                      child: Text('Show current'),
                      style: ElevatedButton.styleFrom(
                        primary:
                            provider.li.length > 1 ? Colors.teal : Colors.grey,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: showtrend,
                      child: Text('Show trend'),
                      style: ElevatedButton.styleFrom(
                        primary:
                            provider.li.length > 1 ? Colors.teal : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
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
  List<String> li = ['a', 'b', 'c', 'd', 'e'];
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
    for (var i = 0; i < ng; i++) {
      for (var k = 0; k < gsize; k++) {
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
      if (pool.isEmpty) {
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
                  items: li.map((
                    String value,
                  ) {
                    var v = li.indexOf(value) + 1;
                    return DropdownMenuItem(
                      child: Text((v).toString()),
                      value: v,
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      ng = value;
                    });
                  },
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

// class Fortune_wheel extends StatefulWidget {
//   @override
//   _Fortune_wheelState createState() => _Fortune_wheelState();
// }

// class _Fortune_wheelState extends State<Fortune_wheel> {
//   StreamController<int> controller = StreamController<int>();
//   var si;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: FortuneWheel(
//         // changing the return animation when the user stops dragging
//         physics: CircularPanPhysics(
//           duration: Duration(seconds: 1),
//           curve: Curves.decelerate,
//         ),
//         onFling: () {
//           controller.add(1);
//         },
//         selected: controller.stream,
//         items: [
//           FortuneItem(child: Text('Han Solo')),
//           FortuneItem(child: Text('Yoda')),
//           FortuneItem(child: Text('Obi-Wan Kenobi')),
//         ],
//       ),
//     );
//   }
// }
class Showcurrent extends StatefulWidget {
  @override
  _ShowcurrentState createState() => _ShowcurrentState();
}

class _ShowcurrentState extends State<Showcurrent> {
  @override
  // void initState() {
  //   this.li = widget.li;
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer(builder: (context, Store provider, Widget child) {
      return ListView.builder(
        itemCount: provider.li.length,
        itemBuilder: (BuildContext context, int index) {
          var l = provider.li[index];
          return ListTile(
            title: Text(l),
            subtitle: Column(children: [
              ElevatedButton(
                child: Text('Remove'),
                onPressed: () {
                  provider.remove(l);
                },
              )
            ]),
          );
        },
      );
    }));
  }
}

class Trendshow extends StatelessWidget {
  List<String> trend = ['food', 'travel', 'luck'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(builder: (context, Store provider, Widget child) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
            ),
            Expanded(
                child: ListView(
              children: [
                ListTile(
                  tileColor: Colors.white24,
                  leading: Image.asset('assets/plane.jpg'),
                  title: Text('travel'),
                  subtitle: Column(
                    children: [
                      ElevatedButton(
                        child: Text('select'),
                        onPressed: () {
                          provider.changecategory('travel');
                        },
                      )
                    ],
                  ),
                ),
                ListTile(
                  tileColor: Colors.white24,
                  leading: Image.asset('assets/food.jpg'),
                  title: Text('food'),
                  subtitle: Column(
                    children: [
                      ElevatedButton(
                        child: Text('select'),
                        onPressed: () {
                          provider.changecategory('food');
                        },
                      )
                    ],
                  ),
                ),
                ListTile(
                  tileColor: Colors.white24,
                  leading: Image.asset('assets/fortune.jpg'),
                  title: Text('fortune'),
                  subtitle: Column(
                    children: [
                      ElevatedButton(
                        child: Text('select'),
                        onPressed: () {
                          provider.changecategory('luck');
                        },
                      )
                    ],
                  ),
                )
              ],
            )),
          ],
        );
      }),
    );
  }
}
