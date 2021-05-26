import 'package:flutter/material.dart';
import 'package:the_vote/database_helper.dart';

class Store extends ChangeNotifier {
  var li = <String>[];
  final db = DatabaseHelper.instace;
  List<Color> ccolor =[Color(0xff6DC8F3),Color(0xff73A1F9)] ;
  void add(data) {
    li.add(data);
    notifyListeners();
  }

  void remove(data) {
    li.remove(data);
    notifyListeners();
  }

  void changecategory(cat) {
    print(cat);
    if (cat == 'travel') {
      li = ['หัวหิน', 'ทะเล', 'ภูเขา', 'ภูเรา'];
      ccolor =[Color(0xff1DC8F3),Color(0xff13A1F9)] ;
    } else if (cat == 'food') {
      li = ['ต้มยำ', 'กระเพรา', 'ข้าวผัด'];
      ccolor =[Color(0xffff2211),Color(0xff73A1F9)] ;
    } else if (cat == 'luck') {
      li = [
        'เกลือ',
        'เกลือมาก',
        'เกลือที่สุด',
        'เกลื่อเหมือนกันอแต่เป็นสีเขียว'
      ];
      ccolor =[Color(0xff6DC8F3),Color(0xff73A1F9)] ;
    }
    notifyListeners();
  }
  void setdefalt(){
    print('de');
    ccolor =[Color(0xff6DC8F3),Color(0xff73A1F9)];
    li =[];
    print(li);
    notifyListeners();
  }
  void createcard(String cardname)async{
    
    Map<String,dynamic> row ={
      DatabaseHelper.columnCardname :cardname,
    };
    var r = await db.createcard(row);
    print('row id '+r.toString());
    print(li.toString());
    li.forEach((element)async {
      print(element);
      Map<String,dynamic> drow ={
        DatabaseHelper.parentid:r,
        DatabaseHelper.columnCarddata:element.toString()
      };
      print('drow '+drow.toString());
      await db.insertdata(drow);
   
    });
  }

  void savecard(int cardID) async{
    Map<String,dynamic> drow ={
        DatabaseHelper.parentid:1,
        DatabaseHelper.columnCarddata:'one'
    };
    await db.insertdata(drow);
  }
  void printall(int cardID)async{
    var q = await db.getcarddata(1);
    print(q.toString());
  }
  Future<List<Map<String,dynamic>>> getcardlist()async{
    var r =  await db.getcardlist();
    return r;
  }
  void getcarddata(cardid)async{
    var r =  await db.getcarddata(cardid);
    print(r.toString());

    li = r.map((e){
      return e['columnCarddata'].toString();
    }).toList();
    notifyListeners();
  }
  
}
class Votestore extends ChangeNotifier {
  var li ;
  bool finish=false;
  List<String> label ;
  List<int> votemap;
  int votenum =0;
  String result;
  void setnumber(data) {
    li = int.parse(data);
    finish=false;
  }

  void vote(index) {
    votemap[index]++;
    print(votemap);
  }
  void setlabel(List<String> l ){
    label = l;
    votemap = [for (var i =0;i<l.length;i++) 0];
    print(votemap);
  }
  void calresult(){
    int la = 0;
    String re ;
    for (var i = 0; i < votemap.length; i++) {
      if (votemap[i] > la) {
        la = votemap[i];
        re = label[i];
      }     
    }
    result = re;
    finish=true;
  }
}
