import 'package:flutter/cupertino.dart';

class CartProvider extends ChangeNotifier {
  final List<String> _resultBarcode = [];
  final List<int> _amountProduct = [];

  List<String> get resultBarcode => _resultBarcode;
  List<int> get amountProduct => _amountProduct;

  void addResultBarcode(String barcode) {
    if (_resultBarcode.contains(barcode)) {
      int index = _resultBarcode.indexOf(barcode);
      _amountProduct[index] += 1;
    } else {
      _resultBarcode.add(barcode);
      _amountProduct.add(1);
    }

    notifyListeners();
  }

  void removeResultBarcode(int index) {
    _resultBarcode.removeAt(index);
    _amountProduct.removeAt(index);
    notifyListeners();
  }

  void increaseAmount(int index) {
    _amountProduct[index] += 1;
    notifyListeners();
  }

  void decreaseAmount(int index) {
    _amountProduct[index] -= 1;
    notifyListeners();
  }

  void changeAmount(int index, int value) {
    _amountProduct[index] = value;
    notifyListeners();
  }
}