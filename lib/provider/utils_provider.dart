import 'package:ewarung/data/model/form_product.dart';
import 'package:ewarung/data/model/recommended_product_result.dart';
import 'package:flutter/cupertino.dart';

class UtilsProvider extends ChangeNotifier {
  bool _isFormInputProduct = false;
  RecommendedProduct _recommendedProduct = RecommendedProduct(id: "", nama: "", keterangan: "", harga: "", gambar: "");
  FormProduct _formProduct = FormProduct(title: "", type: "");
  int _indexBottomNav = 0;

  bool get isFormInputProduct => _isFormInputProduct;
  RecommendedProduct get recommendedProduct => _recommendedProduct;
  FormProduct get formProduct => _formProduct;
  int get indexBottomNav => _indexBottomNav;

  void setIsFormInputProduct(bool state) {
    _isFormInputProduct = state;
    notifyListeners();
  }

  void setRecommendedProduct(RecommendedProduct recommendedProduct) {
    _recommendedProduct = recommendedProduct;
    notifyListeners();
  }

  void setFormProduct(FormProduct formProduct) {
    _formProduct = formProduct;
    notifyListeners();
  }

  void setIndexBottomNav(int index) {
    _indexBottomNav = index;
    notifyListeners();
  }
}