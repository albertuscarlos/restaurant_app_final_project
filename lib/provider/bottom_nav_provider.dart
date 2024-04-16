import 'package:flutter/material.dart';

class BottomNavProvider extends ChangeNotifier {
  int _bottomNavIndex = 0;

  int get bottomNavIndex => _bottomNavIndex;

  void bottomNav(int value) {
    _bottomNavIndex = value;
    notifyListeners();
  }
}
