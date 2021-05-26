import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        
          title: Text('The Vote'),
          backgroundColor: Color(0xffD76EF5),
        ),
        body: Consumer(builder: (context, Votestore provider, Widget child) {
          return Center(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    onSubmitted: (number) {
                      provider.setnumber(number);
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      labelText: "จำนวนผู้ร่วมการ vote",
                      hintText: "จำนวนผู้ร่วมการ vote",
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: _textController,
                    onSubmitted: (text) {
                      setState(() {
                        label.add(text);
                      });
                      _textController.clear();
                    },
                    decoration: InputDecoration(
                      labelText: "ตัวเลือก",
                      hintText: "ตัวเลือก",
                    )),
              ),
              Expanded(
                  child: label.length > 0
                      ? ListView.builder(
                          itemCount: label.length,
                          itemBuilder: (BuildContext context, int index) {
                            var l = label[index];
                            return ListTile(
                              title: Text(l),
                            );
                          },
                        )
                      : Text("please input")),
              (label.length>1 && provider.li != null)?ElevatedButton(
                  onPressed: () {
                    provider.setlabel(this.label);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Vote()));
                  },
                  child: Text('next'),
                  style: ElevatedButton.styleFrom(
                    primary:   Colors.teal,
                  ),
              ):
              ElevatedButton(
                  child: Text('next'),
                  style: ElevatedButton.styleFrom(
                    primary:  Colors.grey,
                  ), onPressed: () {  },
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Vote'),
        ),
        body: Consumer(builder: (context, Votestore provider, Widget child) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                Text(round.toString() + '/' + provider.li.toString()),
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
                          margin: const EdgeInsets.all(10),
                          color:
                              vindex == ti ? Colors.red[200] : Colors.red[100],
                          child: Center(child: Text(e)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: vindex != null ? Colors.teal : Colors.grey),
                    onPressed: () {
                      provider.vote(vindex);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConfirmPage()));
                      setState(() {
                        if (vindex != null) vindex = null;
                        if(round==provider.li)return provider.calresult();
                        round++;
                      });
                    },
                    child: vindex != null ? Text("Next") : Text("No vote"))
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
        
        body: Consumer(builder: (context, Votestore provider, Widget child) {
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.result),
                  ElevatedButton(
                      onPressed: () => Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Mainpags())),
                      child: Text('End'),
                    )
                ],
              ),
            ),
          );
        }));
  }
}

class ConfirmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('result'),
        ),
        body: Consumer(builder: (context, Votestore provider, Widget child) {
          return provider.finish
              ? Container(
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Result())),
                      child: Text('Show result'),
                    ),
                  ),
                )
              : Container(
                  child: Center(
                    child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Ready")),
                  ),
                );
        }));
  }
}
