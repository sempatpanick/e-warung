import 'package:auto_size_text/auto_size_text.dart';
import 'package:ewarung/common/styles.dart';
import 'package:ewarung/data/model/products_user_result.dart';
import 'package:ewarung/provider/cart_provider.dart';
import 'package:ewarung/provider/preferences_provider.dart';
import 'package:ewarung/utils/get_formatted.dart';
import 'package:ewarung/widgets/item_cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class CartPage extends StatefulWidget {
  static const routeName = '/cart_page';

  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Products product;
  bool _isLoadingProduct = true;
  bool _isButtonDisabled = true;
  int totalPrice = 0;

  @override
  Widget build(BuildContext context) {
    PreferencesProvider pref = Provider.of<PreferencesProvider>(context);
    CartProvider cart = Provider.of<CartProvider>(context);

    if (mounted) {
      if (cart.resultBarcode.isNotEmpty) {
        _isButtonDisabled = false;
      } else {
        _isButtonDisabled = true;
      }
    }

    return Scaffold(
      backgroundColor: colorWhiteBlue,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cart.resultBarcode.length,
                itemBuilder: (context, index) {
                  var id = cart.resultBarcode[index];
                  var dataProduct = cart.listProducts.where((element) => element.idProduk == id);
                  if (dataProduct.isNotEmpty) {
                    product = Products(
                        id: dataProduct.first.id,
                        idUsers: dataProduct.first.idUsers,
                        idProduk: dataProduct.first.idProduk,
                        nama: dataProduct.first.nama,
                        keterangan: dataProduct.first.keterangan,
                        harga: dataProduct.first.harga,
                        stok: dataProduct.first.stok,
                        gambar: dataProduct.first.gambar
                    );
                    _isLoadingProduct = false;
                  }
                  return _isLoadingProduct ? const SizedBox(height: 70.0,child: Center(child: CircularProgressIndicator(),)) : ItemCart(index: index, product: product, cart: cart, pref: pref,);
                },
              ),
              const SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        "Total",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(color: primaryColor, fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      AutoSizeText(
                        "Rp. ${GetFormatted().number(cart.totalPrice.sum)}",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(color: colorBlack, fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                      primary: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: _isButtonDisabled ? null :() {
                      checkout();
                    },
                    icon: const Icon(Icons.shopping_cart_outlined, color: textColorWhite,),
                    label: Text(
                      "Checkout",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorWhite, fontSize: 17.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void checkout() {

  }
}