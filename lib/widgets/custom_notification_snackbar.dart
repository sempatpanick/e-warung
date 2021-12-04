import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomNotificationSnackbar {
  final BuildContext context;
  final String message;

  CustomNotificationSnackbar({required this.context, required this.message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}