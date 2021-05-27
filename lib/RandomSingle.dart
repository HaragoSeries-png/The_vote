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
    Store().setdefalt();
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
                          child: provider.li.length < 10
                              ? FortuneWheel(

                                  // changing the return animation when the user stops dragging
                                  physics: CircularPanPhysics(
                                    duration: Duration(seconds: 3),
                                    curve: Curves.decelerate,
                                  ),
                                  onFling: () {
                                    controller.add(1);
                                  },
                                  animateFirst: false,
                                  selected: controller.stream,
                                  items: (provider.li.asMap().entries.map((e) {
                                    return FortuneItem(
                                        style: FortuneItemStyle(
                                          color: (e.key % 2 == 1)
                                              ? provider.ccolor[0]
                                              : provider.ccolor[1],
                                        ),
                                        child: Container(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(e.value.toString(),
                                                style:
                                                    TextStyle(fontSize: 16))));
                                  }).toList()))
                              : Column(
                                  children: [
                                    FortuneBar(
                                      height: 300,
                                      animateFirst: false,
                                      selected: controller.stream,
                                      items:
                                          provider.li.asMap().entries.map((e) {
                                        return FortuneItem(
                                            style: FortuneItemStyle(
                                              color: (e.key % 2 == 1)
                                                  ? Color(0xff6DC8F3)
                                                  : Color(0xff73A1F9),
                                            ),
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Text(e.toString(),
                                                    style: TextStyle(
                                                        fontSize: 16))));
                                      }).toList(),
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          controller.add(1);
                                        },
                                        child: Text('Random'))
                                  ],
                                ),
                        )
                      : Text('add more'),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 80),
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
                        margin: const EdgeInsets.only(bottom: 80),
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
  TextEditingController _textFieldController = TextEditingController();
  List<Widget> testList = [
    Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(
          left: 30.0, top: 30.0, right: 30.0, bottom: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Number'),
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
      void savedata(cardname) {
        provider.createcard(cardname);
      }

      void printall() {
        provider.printall(1);
      }

      _displayDialog(BuildContext context) async {
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('What is your Lucky Number'),
                content: TextField(
                  controller: _textFieldController,
                  textInputAction: TextInputAction.go,
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(hintText: "Enter your number"),
                ),
                actions: <Widget>[
                  new ElevatedButton(
                    child: new Text('Submit'),
                    onPressed: () {
                      savedata(_textFieldController.text);
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }

      return Center(
        child: Container(
          child: Column(
            children: [
              Expanded(
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(l),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: ElevatedButton(
                                  child: Text('Remove'),
                                  onPressed: () {
                                    provider.remove(l);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
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
              ElevatedButton(
                  onPressed: () {
                    _displayDialog(context);
                  },
                  child: Text('Save')),
              ElevatedButton(onPressed: printall, child: Text('print'))
            ],
          ),
        ),
      );
    }));
  }
}

class Trendshow extends StatefulWidget {
  @override
  _TrendshowState createState() => _TrendshowState();
}

class _TrendshowState extends State<Trendshow> {
  final db = DatabaseHelper.instace;
  Future<bool> getlist() async {
    cuslist = await db.getcardlist();
    return true;
  }
  Future<bool> _showConfirmationDialog(BuildContext context, String action) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Do you want to $action this item?'),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Yes'),
            onPressed: () {
              
              Navigator.pop(context, true); // showDialog() returns true
            },
          ),
          ElevatedButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.pop(context, false); // showDialog() returns false
            },
          ),
        ],
      );
    },
  );
}
  

  List<Map<String, dynamic>> cuslist;
  @override
  void initState() {
    print('init');
    getlist();
    super.initState();
  }

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
                FutureBuilder(
                  future: getlist(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                          children: cuslist.map((e) {
                        return Dismissible(
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (DismissDirection dismissDirection) async {                        
                            return await _showConfirmationDialog(context, 'delete') == true;     
                          },
                          onDismissed: (DismissDirection dismissDirection){
                            provider.delcard(e['id']);
                          },
                          key: UniqueKey(),
                          background: Container(color: Colors.red[400],child: Icon(Icons.cancel),),
                          child: Card(
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
                                      provider.getcarddata(e['id']);
                                      Navigator.pop(
                                        context,
                                      );
                                    },
                                  ),
                                  height: 240,
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  e['columnCardname'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 24,
                                      letterSpacing: 2.5),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList());
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                )
              ],
            )),
          ],
        );
      }),
    );
  }
}
