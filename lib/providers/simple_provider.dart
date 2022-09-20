
import 'package:flutter/material.dart';

class SimpleProvider with ChangeNotifier {
  int indexpage = 1;


  int get getindexpage => indexpage;

  void changeindexpage(int newindex) {
    this.indexpage = newindex;
    notifyListeners();
  }

}
