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
  List<String> cate = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'The Vote',
            style: TextStyle(fontFamily: 'Lobster'),
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
                      if(number!=null){
                        provider.setnumber(number);
                      }                    
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      hintText: "จำนวนผู้ร่วมการ vote",
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                    controller: _textController,
                    onSubmitted: (text) {
                      String cheker = text.trim();
                      if(cheker.isNotEmpty){
                        print('empty');
                        setState(() {                        
                          label.add(text);
                        });
                      }                     
                      _textController.clear();
                    },
                    decoration: InputDecoration(
                      hintText: "ตัวเลือก",
                    )),
              ),
              Container(
                height: 300,
                padding: EdgeInsets.only(left: 80, right: 80),
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
                                  child: Text(l),
                                  alignment: Alignment.center,
                                );
                              },
                            )
                          : Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Text("CURRENT CHOICE"))),
                ),
              ),
              
              (label.length > 1 && provider.li > 2)
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('The Vote'),
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
                          child: Center(child: Text(e)),
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
        body: Consumer(builder: (context, Votestore provider, Widget child) {
      return Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(provider.topic!=null)Text(provider.topic),
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: provider.votemap.asMap().entries.map((e){
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: 40,
                      height: e.value.toDouble()*60,
                      color: Colors.grey,
                      
                      child:Text(provider.label[e.key])
                    );
                  }).toList()
                ),
              ),
              Text(provider.label.toString()),
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
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Result())),
                      child: Text('Show result'),
                    ),
                  ),
                )
              : Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            child: Text(
                          'Give Phone to the other',
                          style: new TextStyle(
                              fontSize: 30,
                              fontFamily: 'PetitFormalScript',
                              fontWeight: FontWeight.w200),
                        )),
                        Container(
                          child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Ready")),
                        ),
                      ]),
                );
        }));
  }
}
