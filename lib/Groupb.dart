import 'package:flutter/material.dart';
import 'dart:math';
import 'package:random_color/random_color.dart';
import 'package:flutter/services.dart';

class Groupb extends StatefulWidget {
  @override
  _GroupbState createState() => _GroupbState();
}

RandomColor _randomColor = RandomColor();
Color _color = _randomColor.randomColor(colorBrightness: ColorBrightness.light);

class _GroupbState extends State<Groupb> {
  final TextEditingController _textController = new TextEditingController();
  final TextEditingController _numController = new TextEditingController();
  final random = Random();

  List<String> li = [];
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
  }

  void clear() {
    setState(() {
      li = [];
    });
  }

  void randd() {
    result = [];
    List pool = List.of(li);
    var retemp = [];
    var gsize = (li.length.toDouble() / ng.toDouble()).ceil();
    print('ng ' + ng.toString());
    print('gsize ' + gsize.toString());
    for (var i = 0; i < ng; i++) {
      for (var k = 0; k < gsize; k++) {
        var re;
        if (pool.length <= gsize) {
          retemp = List.of(pool);
          pool = [];
          break;
        }
        re = random.nextInt(pool.length);
        var n = pool[re];
        retemp.add(n);
        pool.removeAt(re);
      }
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
          title: Text(
            'Random group',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Color(0xffFFB157),
        ),
        body: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
                child: TextField(
                  controller: _textController,
                  decoration: new InputDecoration(hintText: "Input here!!"),
                  onSubmitted: (text) {
                    print(li.length);
                    _updateResults(text);
                    _textController.clear();
                  },
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: TextField(
                  controller: _numController,
                  onChanged: (number) {
                    if (number != null) {
                      int io = int.parse(number);
                      if (io > li.length) {
                        setState(() {
                          ng = li.length;
                          _numController.text = ng.toString();
                        });
                      } else {
                        setState(() {
                          ng = io;
                        });
                      }
                    }
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(hintText: "จำนวนกลุ่ม")),
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: 90, right: 90, top: 20, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: li.length > 1
                    ? [
                        ElevatedButton(
                          onPressed: randd,
                          child: Text('Random'),
                          style: ElevatedButton.styleFrom(
                            primary: li.length == 0
                                ? Colors.teal
                                : Color(0xffFFB157),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: clear,
                          child: Text('Clear'),
                          style: ElevatedButton.styleFrom(
                            primary: li.length == 0 ? Colors.teal : Colors.red,
                          ),
                        ),
                      ]
                    : [Text('Value')],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                    left: 80, right: 80, top: 30, bottom: 0),
                child: ListView.builder(
                  itemCount: li.length,
                  itemBuilder: (BuildContext context, int index) {
                    var l = li[index];
                    return Container(
                      child: ListTile(
                        title: Text(l),
                        tileColor: Color(0xFFFFB347),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(left: 30, top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('RESULT'),
                  ],
                )),
            Expanded(
                child: Container(
              margin: const EdgeInsets.only(
                  left: 30, right: 30, top: 20, bottom: 30),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: result.length,
                itemBuilder: (BuildContext context, int index) {
                  List l = result[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                        width: 160.0,
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        padding: const EdgeInsets.all(30),
                        color: Color(0xffeed9cd),
                        child: Center(
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: l.map((e) {
                                  return Text(e);
                                }).toList()))),
                  );
                },
              ),
            )),
          ],
        ));
  }
}
