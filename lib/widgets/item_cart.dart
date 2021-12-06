import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:ewarung/common/styles.dart';
import 'package:ewarung/data/model/products_user_result.dart';
import 'package:ewarung/provider/cart_provider.dart';
import 'package:ewarung/provider/preferences_provider.dart';
import 'package:ewarung/utils/get_formatted.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:string_validator/string_validator.dart';

class ItemCart extends StatefulWidget {
  final int index;
  final Products product;
  final CartProvider cart;
  final PreferencesProvider pref;
  const ItemCart({Key? key, required this.index, required this.product, required this.cart, required this.pref}) : super(key: key);

  @override
  State<ItemCart> createState() => _ItemCartState();
}

class _ItemCartState extends State<ItemCart> {
  final TextEditingController _valueTextController = TextEditingController();
  bool _isTimerActive = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      setState(() {
        _valueTextController.text = widget.cart.amountProduct[widget.index].toString();
      });
      Timer t = Timer(const Duration(milliseconds: 50), () {
        calculatePrice();
        _isTimerActive = false;
      });
      if (_isTimerActive) {
        t;
      } else {
        setState(() {
          t.cancel();
        });
      }
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(top: 12.0),
      decoration: BoxDecoration(
        color: textColorWhite,
        borderRadius: BorderRadius.circular(30.0)
      ),
      child: Row(
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
              "https://e-warung.my.id/assets/users/${widget.pref.userLogin.id}/products/abc ?? ""}",
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
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (int.parse(_valueTextController.text) > 1) {
                            widget.cart.decreaseAmount(widget.index);
                          } else if (_valueTextController.text.isEmpty) {
                            widget.cart.changeAmount(widget.index, 1);
                          }
                          calculatePrice();
                        });
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(
                            color: textColorGrey,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "-",
                            style: TextStyle(
                              color: colorBlack,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 30,
                      height: 25,
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.symmetric(
                          horizontal: BorderSide(color: textColorGrey),
                        ),
                      ),
                      child: Center(
                          child: TextField(
                            controller: _valueTextController,
                            keyboardType: TextInputType.number,
                            maxLength: 3,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            textAlign: TextAlign.center,
                            showCursor: false,
                            decoration: const InputDecoration(
                                counterText: ''
                            ),
                            onSubmitted: (value) {
                              if (isNumeric(value)) {
                                if (int.parse(value) < 1) {
                                  widget.cart.changeAmount(widget.index, 1);
                                } else {
                                  widget.cart.changeAmount(widget.index, int.parse(value));
                                }
                              } else {
                                widget.cart.changeAmount(widget.index, 1);
                              }
                              calculatePrice();
                            },
                          )
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_valueTextController.text.isEmpty) {
                            widget.cart.changeAmount(widget.index, 1);
                          } else if (_valueTextController.text != "999") {
                            widget.cart.increaseAmount(widget.index);
                          }
                          calculatePrice();
                        });
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(
                            color: textColorGrey,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "+",
                            style: TextStyle(
                              color: colorBlack,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 120,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: IconButton(
                onPressed: (){
                  setState(() {
                    widget.cart.removeResultBarcode(widget.index);
                  });
                },
                icon: const Icon(
                  Icons.remove_shopping_cart_outlined,
                  color: colorBlack,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void calculatePrice() {
    // int price = widget.cart.amountProduct[widget.index] * int.parse(widget.product.harga);
    widget.cart.setTotalPrice(widget.index);
  }

  @override
  void dispose() {
    _valueTextController.dispose();
    super.dispose();
  }
}