import 'package:ewarung/data/model/products_user_result.dart';
import 'package:flutter/cupertino.dart';

class CartProvider extends ChangeNotifier {
  final List<String> _resultBarcode = ["8993176110081", "8994591070011"];
  final List<int> _amountProduct = [1, 1];
  final List<Products> _listProducts = [];
  final List<int> _totalPrice = [0, 0];

  List<String> get resultBarcode => _resultBarcode;
  List<int> get amountProduct => _amountProduct;
  List<Products> get listProducts => _listProducts;
  List<int> get totalPrice => _totalPrice;

  void addResultBarcode(String barcode) {
    if (_resultBarcode.contains(barcode)) {
      int index = _resultBarcode.indexOf(barcode);
      _amountProduct[index] += 1;
      setTotalPrice(index);
    } else {
      _resultBarcode.add(barcode);
      _amountProduct.add(1);
      _totalPrice.add(0);
    }

    notifyListeners();
  }

  void removeResultBarcode(int index) {
    _resultBarcode.removeAt(index);
    _amountProduct.removeAt(index);
    _totalPrice.removeAt(index);
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

  void addUserProducts(List<Products> list) {
    _listProducts.clear();
    _listProducts.addAll(list);
    notifyListeners();
  }

  void setTotalPrice(int index) {
    _totalPrice[index] = _amountProduct[index] * int.parse(_listProducts[index].harga);
    notifyListeners();
  }
}