import 'package:auto_size_text/auto_size_text.dart';
import 'package:ewarung/common/styles.dart';
import 'package:ewarung/data/model/delete_product_user_result.dart';
import 'package:ewarung/data/model/products_user_result.dart';
import 'package:ewarung/provider/cart_provider.dart';
import 'package:ewarung/provider/preferences_provider.dart';
import 'package:ewarung/provider/user_provider.dart';
import 'package:ewarung/utils/get_formatted.dart';
import 'package:ewarung/widgets/custom_alert_dialog.dart';
import 'package:ewarung/widgets/custom_notification_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemProduct extends StatefulWidget {
  final int index;
  final Products product;
  final CartProvider cart;
  final UserProvider userProv;
  final PreferencesProvider pref;
  const ItemProduct({Key? key, required this.index, required this.product, required this.cart, required this.userProv, required this.pref}) : super(key: key);

  @override
  State<ItemProduct> createState() => _ItemProductState();
}

class _ItemProductState extends State<ItemProduct> {
  bool _isLoadingDelete = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: textColorWhite,
          borderRadius: BorderRadius.circular(30.0)
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: primaryColor,
                ),
                child: widget.product.gambar != null
                    ? Image.network(
                  "https://e-warung.my.id/assets/users/${widget.pref.userLogin.id}/products/abc",
                  fit: BoxFit.fill,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return const Icon(Icons.broken_image, size: 70.0, color: textColorWhite,);
                  },
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                )
                    : const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              const SizedBox(width: 16.0,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      widget.product.nama,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorBlue, fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8,),
                    AutoSizeText(
                      "Rp. ${GetFormatted().number(int.parse(widget.product.harga != "" ? widget.product.harga : "0"))}",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textFieldColorGrey, fontSize: 15.0),
                    ),
                    const SizedBox(height: 8,),
                    Row(
                      children: [
                        AutoSizeText(
                          "Qty:",
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorBlue, fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8,),
                        AutoSizeText(
                          GetFormatted().number(int.parse(widget.product.stok != "" ? widget.product.stok : "0")),
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textFieldColorGrey, fontSize: 15.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
                width: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  verticalDirection: VerticalDirection.up,
                  children: [
                    Tooltip(
                      message: "Add to cart",
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          primary: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            widget.cart.addResultBarcode(widget.product.idProduk);
                            CustomNotificationSnackbar(context: context, message: "${widget.product.nama} has added to cart");
                          });
                        },
                        child: const Icon(
                          Icons.add_shopping_cart,
                          size: 20.0,
                          color: textColorWhite,
                        ),
                      ),
                    ),
                    Tooltip(
                      message: "Remove product from store",
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          primary: colorRed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CustomAlertDialog(
                                title: Center(
                                  child: Text(
                                    "Remove Product",
                                    style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorBlue, fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                content: Text(
                                  "Are you sure to remove this product from your store?",
                                  style: Theme.of(context).textTheme.subtitle1!.copyWith(color: colorBlack, fontSize: 14.0),
                                ),
                                submit: () {
                                  setState(() {
                                    _isLoadingDelete = true;
                                  });
                                  deleteProduct();
                                  Navigator.pop(context);
                                }
                              );
                            }
                          );
                        },
                        child: const Icon(
                          Icons.highlight_remove,
                          size: 20.0,
                          color: textColorWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _isLoadingDelete ?
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: const LinearProgressIndicator(),
          ) : Container(),
        ],
      ),
    );
  }

  deleteProduct() async {
    try {
      final Future<DeleteProductUserResult> response = widget.userProv.fetchDeleteProductUser(widget.pref.userLogin.id, widget.product.idProduk);

      response.then((value) {
        if (value.status) {
          try {
            final Future<ProductsUserResult> responseProducts = widget.userProv.fetchProductsUser(widget.pref.userLogin.id);

            responseProducts.then((valueProducts) {
              setState(() {
                _isLoadingDelete = false;
              });

              if (valueProducts.status) {
                setState(() {
                  widget.cart.addUserProducts(valueProducts.data ?? []);
                });

                CustomNotificationSnackbar(context: context, message: value.message);
              } else {
                CustomNotificationSnackbar(context: context, message: valueProducts.message);
              }
            });
          } catch (e) {
            setState(() {
              _isLoadingDelete = false;
            });

            CustomNotificationSnackbar(context: context, message: "Error : $e");
          }
        } else {
          setState(() {
            _isLoadingDelete = false;
          });

          CustomNotificationSnackbar(context: context, message: value.message);
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingDelete = false;
      });

      CustomNotificationSnackbar(context: context, message: "Error: $e");
    }
  }
}