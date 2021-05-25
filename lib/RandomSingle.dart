import 'dart:async';
import 'dart:math';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter/material.dart';
import 'package:imagebutton/imagebutton.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:ui' as ui;
import 'listitem.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'database_helper.dart';
import 'package:provider/provider.dart';
import 'package:the_vote/store.dart';

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
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
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
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            ),
            Expanded(
                child: ListView(
              children: [
                Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Ink.image(
                        image: AssetImage(
                          'assets/img/travel.jpg',
                        ),
                        child: InkWell(
                          onTap: () {
                            provider.changecategory('travel');
                            Navigator.pop(
                              context,
                            );
                          },
                        ),
                        height: 240,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        'TRAVELING',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24,
                            letterSpacing: 2.5),
                      ),
                    ],
                  ),
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Ink.image(
                        image: AssetImage(
                          'assets/img/food.jpg',
                        ),
                        child: InkWell(
                          onTap: () {
                            provider.changecategory('food');
                            Navigator.pop(
                              context,
                            );
                          },
                        ),
                        height: 240,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        'Food and Drinking',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24,
                            letterSpacing: 2.5),
                      ),
                    ],
                  ),
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Ink.image(
                        image: AssetImage(
                          'assets/img/tarot.jpg',
                        ),
                        child: InkWell(
                          onTap: () {
                            provider.changecategory('luck');
                            Navigator.pop(
                              context,
                            );
                          },
                        ),
                        height: 240,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        'DESTINY',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24,
                            letterSpacing: 2.5),
                      ),
                    ],
                  ),
                ),
                 Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Ink.image(
                        image: AssetImage(
                          'assets/img/dummy.jpg',
                        ),
                        child: InkWell(
                          onTap: () {             
                          },
                        ),
                        height: 240,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        'COMING SOON',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24,
                            letterSpacing: 2.5),
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ],
        );
      }),
    );
  }
}
