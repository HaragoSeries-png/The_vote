import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:the_vote/store.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:the_vote/main.dart';

class ThevotePage extends StatefulWidget {
  @override
  _ThevotePageState createState() => _ThevotePageState();
}

class _ThevotePageState extends State<ThevotePage> {
  StreamController controller = StreamController();
  final TextEditingController _textController = new TextEditingController();
  List<String> label = [];
  List<String> cate = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'The Vote',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Color(0xffD76EF5),
        ),
        body: Consumer(builder: (context, Votestore provider, Widget child) {
          return Center(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                    onChanged: (text) {
                      provider.topic = text;
                    },
                    decoration: InputDecoration(
                      hintText: "Topic",
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                    onChanged: (number) {
                      if (number != null) {
                        provider.setnumber(number);
                      }
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      hintText: "Number of people (atleast 3 or more)",
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                    controller: _textController,
                    onSubmitted: (text) {
                      String cheker = text.trim();
                      if (cheker.isNotEmpty) {
                        setState(() {
                          label.add(text);
                        });
                      }
                      _textController.clear();
                    },
                    decoration: InputDecoration(
                      hintText: "Choice",
                    )),
              ),
              Container(
                height: 300,
                padding: EdgeInsets.only(left: 40, right: 40),
                child: SizedBox(
                  child: Expanded(
                      child: label.length > 0
                          ? GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 2),
                              itemCount: label.length,
                              itemBuilder: (BuildContext context, int index) {
                                var l = label[index];
                                return Container(
                                  margin: EdgeInsets.only(top: 30, left: 0),
                                  child: Text(l,style: TextStyle(fontSize: 18),),
                                  alignment: Alignment.center,
                                );
                              },
                            )
                          : Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Text("CURRENT CHOICE"))),
                ),
              ),
              ((label.length > 1) && (provider.li > 2))
                  ? Container(
                      child: ElevatedButton(
                        onPressed: () {
                          provider.setlabel(this.label);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Vote()));
                        },
                        child: Text('NEXT'),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xffD76EF5),
                        ),
                      ),
                    )
                  : Container(
                      child: ElevatedButton(
                        child: Text('NEXT'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                        ),
                        onPressed: () {},
                      ),
                    )
            ],
          ));
        }));
  }
}

class Vote extends StatefulWidget {
  @override
  _VoteState createState() => _VoteState();
}

class _VoteState extends State<Vote> {
  int vindex;
  int round = 1;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('The vote'),
          backgroundColor: Color(0xffD76EF5),
        ),
        body: Consumer(builder: (context, Votestore provider, Widget child) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                Container(
                  child: Text(
                    round.toString() + '/' + provider.li.toString(),
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: provider.label.map((e) {
                      var ti = provider.label.indexOf(e);
                      return InkWell(
                        onTap: () {
                          setState(() {
                            vindex = ti;
                          });
                        },
                        child: Container(
                          width: 160.0,
                          margin: const EdgeInsets.only(
                              top: 20, left: 10, right: 10, bottom: 0),
                          color:
                              vindex == ti ? Colors.red[200] : Colors.red[100],
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              (e),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary:
                              vindex != null ? Color(0xffD76EF5) : Colors.grey),
                      onPressed: () {
                        provider.vote(vindex);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ConfirmPage()));
                        setState(() {
                          if (vindex != null) vindex = null;
                          if (round == provider.li) return provider.calresult();
                          round++;
                        });
                      },
                      child: vindex != null ? Text("Next") : Text("Next")),
                )
              ],
            ),
          );
        }));
  }
}

class Result extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('The Vote'),
          backgroundColor: Color(0xffD76EF5),
        ),
        body: Consumer(builder: (context, Votestore provider, Widget child) {
          return Column(children: [
            if (provider.topic != null)
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 60),
                child: Center(
                    child: Text(
                  'Topic',
                  style: TextStyle(fontSize: 30),
                )),
              ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 60),
              child: Center(
                  child: Text(
                provider.topic,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              )),
            ),
            Spacer(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: provider.label.asMap().entries.map((e) {
                            int indx = e.key;
                            var hi = provider.votemap[indx].toDouble();
                            double max = provider.result;
                            return Column(
                              children: [
                                Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      hi.toInt().toString(),
                                    )),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  width: 40,
                                  height: (hi / max) * 200,
                                  color: Color(0xffD76EF5),
                                ),
                                Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text(e.value)),
                              ],
                            );
                          }).toList()),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text('All Choice')),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xffD76EF5),
                      ),
                      onPressed: () => Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Mainpags())),
                      child: Text('END'),
                    ),
                  )
                ],
              ),
            ),
          ]);
        }));
  }
}

class ConfirmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'The Vote',
            style: TextStyle(fontFamily: 'Lobster'),
          ),
          backgroundColor: Color(0xffD76EF5),
        ),
        body: Consumer(builder: (context, Votestore provider, Widget child) {
          return provider.finish
              ? Container(
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xffD76EF5),
                      ),
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Result())),
                      child: Text('SHOW RESULT'),
                    ),
                  ),
                )
              : Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            child: Image(
                          image: NetworkImage(
                              'https://media.tenor.com/images/5c0287f4786253f196eca9959f5e64fd/tenor.gif'),
                          width: 300,
                          height: 300,
                        )),
                        Container(
                            child: Text(
                          'Give phone to the other',
                          style: new TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w200),
                        )),
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xffD76EF5),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text("Ready"),
                          ),
                        ),
                      ]),
                );
        }));
  }
}
