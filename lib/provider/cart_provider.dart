import 'package:ewarung/data/model/products_user_result.dart';
import 'package:flutter/cupertino.dart';

class CartProvider extends ChangeNotifier {
  final List<String> _resultBarcode = [];
  final List<int> _amountProduct = [];
  final List<Products> _listProducts = [];
  final List<int> _totalPrice = [];

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

  void clearAll() {
    _resultBarcode.clear();
    _amountProduct.clear();
    _totalPrice.clear();
    _listProducts.clear();
    notifyListeners();
  }

  void clear() {
    _resultBarcode.clear();
    _amountProduct.clear();
    _totalPrice.clear();
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
    var id = resultBarcode[index];
    var dataProduct = listProducts.where((element) => element.idProduk == id);
    _totalPrice[index] = _amountProduct[index] * int.parse(dataProduct.first.harga);
    notifyListeners();
  }
}