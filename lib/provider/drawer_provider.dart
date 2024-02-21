import 'package:flutter/material.dart';
import 'package:app_restaurant/model/drawer_item.dart';

class DrawerProvider extends ChangeNotifier {
  DrawerItem _drawerItem = DrawerItem.stores;
  DrawerItem get drawerItem => _drawerItem;

  void setDrawerItem(DrawerItem drawerItem) {
    _drawerItem = drawerItem;
    notifyListeners();
  }
}
