import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_vote/store.dart';
import 'package:provider/provider.dart';

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
              ElevatedButton(onPressed:(){
                provider.setlabel(this.label);
              } , child: Text('next'))
            ],
          ));
        }));
  }
}

class Vote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
