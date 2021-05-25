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
                          new InputDecoration(hintText: "Input Here!!!"),
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

                Expanded(
                  child: provider.li.length > 1
                      ? Padding(
                          padding:
                              const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 25.0),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 60, horizontal: 105),
                      child: ElevatedButton(
                        onPressed: showmore,
                        child: Text('SHOW CURRENT'),
                        style: ElevatedButton.styleFrom(
                          primary: provider.li.length > 1
                              ? Colors.teal
                              : Colors.grey,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: ElevatedButton(
                        onPressed: showtrend,
                        child: Text('TREND'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.teal,
                        ),
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
  List<Widget> testList = [
    Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(
          left: 30.0, top: 30.0, right: 30.0, bottom: 30.0),
      child: Row(
        children: [
          Text('Number'),
          SizedBox(
            width: 250,
          ),
          Text('Value'),
        ],
      ),
    )
  ];
  @override
  // void initState() {
  //   this.li = widget.li;
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer(builder: (context, Store provider, Widget child) {
      return Center(
        child: Container(
          padding: const EdgeInsets.only(
              left: 30.0, top: 50.0, right: 30.0, bottom: 30.0),
          child: ListView.builder(
            itemCount: provider.li.length + testList.length,
            itemBuilder: (BuildContext context, int index) {
              if (index < testList.length) {
                return testList[index];
              } else {
                var l = provider.li[index - testList.length];
                return Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 50,
                      ),
                      Text(l),
                      SizedBox(
                        width: 300,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        child: ElevatedButton(
                            child: Text('Remove'),
                            onPressed: () {
                              provider.remove(l);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              padding: EdgeInsets.symmetric(vertical: 2),
                            )),
                      )
                    ],
                  ),
                );
              }

              // return ListTile(
              //   title: Text(l),
              //   subtitle: Row(children: [
              // ElevatedButton(
              //   child: Text('Remove'),
              //   onPressed: () {
              //     provider.remove(l);
              //   },
              // )
              //   ]),
              // );
            },
          ),
        ),
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
                          onTap: () {},
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
