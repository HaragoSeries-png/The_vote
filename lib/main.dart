import 'dart:async';
import 'dart:math';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter/material.dart';
import 'package:imagebutton/imagebutton.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:the_vote/thevote.dart';
import 'dart:ui' as ui;
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
      li = ['หัวหิน', 'ทะเล', 'ภูเขา', 'ภูเรา'];
    } else if (cat == 'luck') {
      li = [
        'เกลือ',
        'เกลือมาก',
        'เกลือที่สุด',
        'เกลื่อเหมือนกันอแต่เป็นสีเขียว'
      ];
    }
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return Store();
        })
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'The vote',
        theme: ThemeData(
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
  final double _borderRadius = 24;
  void test(r) {
    if (r == 'Random')
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => RandomSingle()));
    else if (r == 'GroupRandom')
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Groupb()));
    else if (r == 'Thevote')
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ThevotePage()));
  }

  imgFunction(c) {
    if (c == 'Random')
      return Image.asset(
        'assets/img/dice.png',
        height: 64,
        width: 64,
      );
    else if (c == 'GroupRandom')
      return Image.asset(
        'assets/img/kanban.png',
        height: 64,
        width: 64,
      );
    else if (c == 'Thevote')
      return Image.asset(
        'assets/img/poll.png',
        height: 64,
        width: 64,
      );
  }

  var items = [
    PlaceInfo(
        'Random Single Mode',
        Color(0xff6DC8F3),
        Color(0xff73A1F9),
        1,
        'You can create your own challenge or make your decision with yourself',
        '___________________________________',
        'Random'),
    PlaceInfo(
        'Random Group',
        Color(0xffFFB157),
        Color(0xffFFA057),
        2,
        'You can mange you group random with yourself in this function',
        '___________________________________',
        'GroupRandom'),
    PlaceInfo(
        'The Vote',
        Color(0xffD76EF5),
        Color(0xff8F7AFE),
        3,
        'You can not make decision with you friend So,let the vote help you:)',
        '___________________________________',
        'Thevote'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Select Mode',
          style: TextStyle(
              fontFamily: 'Varela', fontSize: 20, color: Color(0xFF545D68)),
        ),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              test(items[index].route);
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(_borderRadius),
                          gradient: LinearGradient(
                              colors: [
                                items[index].startColor,
                                items[index].endColor
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight),
                          boxShadow: [
                            BoxShadow(
                                color: items[index].endColor,
                                blurRadius: 3,
                                offset: Offset(0, 2))
                          ]),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      top: 0,
                      child: CustomPaint(
                        size: Size(100, 160),
                        painter: CustomCardShapePainter(_borderRadius,
                            items[index].startColor, items[index].endColor),
                      ),
                    ),
                    Positioned.fill(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: imgFunction(items[index].route),
                            flex: 2,
                          ),
                          Expanded(
                            flex: 4,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  items[index].name,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24),
                                ),
                                Text(
                                  items[index].category,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                                Flexible(
                                  child: Text(
                                    items[index].location,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  items[index].rating.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: Color(0xFFF17532),
      //   child: Icon(Icons.fastfood),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: BottomBar(),
    );
  }
}

class RandomSingle extends StatefulWidget {
  @override
  _RandomSingleState createState() => _RandomSingleState();
}

class _RandomSingleState extends State<RandomSingle> {
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
          backgroundColor: Color(0xff6DC8F3),
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
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Text(e.toString(),
                                                  style: TextStyle(
                                                      fontSize: 16))));
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
          backgroundColor: Color(0xffFFB157),
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

class PlaceInfo {
  final String name;
  final String category;
  final String location;
  final double rating;
  final Color startColor;
  final Color endColor;
  final String route;
  PlaceInfo(this.name, this.startColor, this.endColor, this.rating,
      this.location, this.category, this.route);
}

class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;
  CustomCardShapePainter(this.radius, this.startColor, this.endColor);
  @override
  void paint(Canvas canvas, Size size) {
    var radius = 3.0;
    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        Offset(3, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);
    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - radius * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Trending Now',
          style: TextStyle(
              fontFamily: 'Varela',
              fontSize: 20,
              color: Colors.black,
              letterSpacing: 2.0),
        ),
      ),
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RandomSingle()));
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RandomSingle()));
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RandomSingle()));
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
