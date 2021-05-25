import 'package:flutter/material.dart';
import 'dart:math';

class Groupb extends StatefulWidget {
  @override
  _GroupbState createState() => _GroupbState();
}

class _GroupbState extends State<Groupb> {
  final TextEditingController _textController = new TextEditingController();
  final random = Random();
  List<String> li = ['1','2','3','4'];
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

  void randd() {
    result = [];
    List pool = List.of(li);
    var retemp = [];
    var gsize = (li.length.toDouble() / ng.toDouble()).ceil();
    print('ng '+ng.toString());
    print('gsize '+gsize.toString());
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: li.length > 1
                  ? [
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
                    ]
                  : [Text('')],
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
                  scrollDirection: Axis.horizontal,
              itemCount: result.length,
              itemBuilder: (BuildContext context, int index) {
                List l = result[index];
                return Container(
                    width: 160.0,
                    margin: const EdgeInsets.all(10),
                    
                    color: Colors.red[100],
                    child: Center(
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        
                        children: l.map((e){
                        return Text(e); }
                      ).toList())
                    )) ;
              },
            )),
          ],
        ));
  }
}
