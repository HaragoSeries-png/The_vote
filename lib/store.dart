import 'package:flutter/material.dart';
import 'package:the_vote/database_helper.dart';

class Store extends ChangeNotifier {
  var li = <String>[];
  final db = DatabaseHelper.instace;
  List<Color> ccolor = [Color(0xff6DC8F3), Color(0xff73A1F9)];
  void add(data) {
    li.add(data);
    notifyListeners();
  }

  void remove(data) {
    li.remove(data);
    notifyListeners();
  }

  void changecategory(cat) {

    if (cat == 'travel') {
      li = ['หัวหิน', 'ทะเล', 'ภูเขา', 'คลอง'];
      ccolor = [
        Color(0xffade4f7),
        Color(0xff86beda),
        Color(0xffd9d9db),
        Color(0xff203542)
      ];
    } else if (cat == 'food') {
      li = ['ต้มยำ', 'กระเพรา', 'ข้าวผัด', 'คะน้าหมูกรอบ'];
      ccolor = [
        Color(0xffc3073f),
        Color(0xffff652f),
        Color(0xffbc896a),
        Color(0xfffbeec1)
      ];
    } else if (cat == 'luck') {
      li = ['เกลือ', 'เกลือมาก', 'เกลือที่สุด', 'เกลื่อเหมือนกันแต่เปลี่ยนสี'];
      ccolor = [
        Color(0xff479761),
        Color(0xffcebe81),
        Color(0xffa16e83),
        Color(0xffb19f9e)
      ];
    }
    notifyListeners();
  }

  void setdefalt() {

    ccolor = [Color(0xff6DC8F3), Color(0xff73A1F9)];
    li = [];

    notifyListeners();
  }

  void createcard(String cardname) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnCardname: cardname,
    };
    var r = await db.createcard(row);

    li.forEach((element) async {
      print(element);
      Map<String, dynamic> drow = {
        DatabaseHelper.parentid: r,
        DatabaseHelper.columnCarddata: element.toString()
      };

      await db.insertdata(drow);
    });
  }

  void savecard(int cardID) async {
    Map<String, dynamic> drow = {
      DatabaseHelper.parentid: 1,
      DatabaseHelper.columnCarddata: 'one'
    };
    await db.insertdata(drow);
  }

  void printall(int cardID) async {
    var q = await db.getcarddata(1);

  }

  Future<List<Map<String, dynamic>>> getcardlist() async {
    var r = await db.getcardlist();
    return r;
  }

  void getcarddata(cardid) async {
    var r = await db.getcarddata(cardid);

    li = r.map((e) {
      return e['columnCarddata'].toString();
    }).toList();
    notifyListeners();
  }

  void delcard(int cardid) async {
    await db.delete(cardid);
    await db.deletecarddata(cardid);
  }
}

class Votestore extends ChangeNotifier {
  String topic;
  var li =0 ;
  bool finish=false;
  List<String> label ;
  List<int> votemap;
  int votenum =0;
  double result;
  void setnumber(data) {
    li = int.parse(data);
    finish=false;
    notifyListeners();
  }

  void vote(index) {
    votemap[index]++;

  }

  void setlabel(List<String> l) {
    label = l;
    votemap = [for (var i = 0; i < l.length; i++) 0];

  }

  void calresult() {
    int la = 0;
    String re;
    for (var i = 0; i < votemap.length; i++) {
      if (votemap[i] > la) {
        la = votemap[i];
        re = label[i];
      }
    }
    result = la.toDouble();
    finish=true;
  }
}
