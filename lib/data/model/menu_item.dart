import 'package:flutter/cupertino.dart';

class MenuItem {
  String title;
  String subtitle;
  String event;
  IconData icon;
  Function() click;

  MenuItem({required this.title, required this.subtitle, required this.event, required this.icon, required this.click});
}