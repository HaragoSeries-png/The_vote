

import 'package:flutter/material.dart';


class Store extends ChangeNotifier {
  var li = <String>[];

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
    if (cat == 'food') {
      li = ['ต้มยำ', 'กระเพรา', 'ข้าวผัด'];
    } else if (cat == 'travel') {
      li = ['หัวหิน', 'ทะเล', 'ภูเขา', 'ภูเรา'];
    } else if (cat == 'luck') {
      li = [
        'เกลือ',
        'เกลือมาก',
        'เกลือที่สุด',
        'เกลื่อเหมือนกันอแต่เป็นสีเขียว'
      ];
    }
  }
  notifyListeners();
}
class Votestore extends ChangeNotifier {
  var li ;
  List<String> label ;
  List<int> votemap;
  int votenum =0;
  void setnumber(data) {
    li = int.parse(data);
  }

  void vote(index) {
    li[index]++;
    
  }
  void setlabel(List<String> l ){
    label = l;
    votemap = [for (var i =0;i<l.length;i++) 0];
    print(votemap);
  }
 
}