import 'package:flutter/cupertino.dart';

class CartProvider extends ChangeNotifier {
  final List<String> _resultBarcode = [];

  List<String> get resultBarcode => _resultBarcode;

  void addResultBarcode(String barcode) {
    _resultBarcode.add(barcode);
    notifyListeners();
  }
}