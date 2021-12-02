import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomNotification extends StatelessWidget {
  final String message;

  const CustomNotification({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 16.0),
      ),
    );
  }
}
