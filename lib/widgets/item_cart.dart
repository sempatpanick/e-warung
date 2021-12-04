import 'package:auto_size_text/auto_size_text.dart';
import 'package:ewarung/common/styles.dart';
import 'package:ewarung/provider/cart_provider.dart';
import 'package:ewarung/provider/preferences_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemCart extends StatefulWidget {
  final int index;
  final String id;
  const ItemCart({Key? key, required this.index, required this.id}) : super(key: key);

  @override
  State<ItemCart> createState() => _ItemCartState();
}

class _ItemCartState extends State<ItemCart> {
  final TextEditingController _valueTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PreferencesProvider pref = Provider.of<PreferencesProvider>(context);
    CartProvider cart = Provider.of<CartProvider>(context);
    if (mounted) {
      setState(() {
        _valueTextController.text = cart.amountProduct[widget.index].toString();
      });
    }

    return Container(
      margin: const EdgeInsets.only(top: 12.0),
      decoration: BoxDecoration(
        color: textColorWhite,
        borderRadius: BorderRadius.circular(30.0)
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(16.0),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: primaryColor,
            ),
            child: pref.userLogin.alamat != ""
                ? Image.network(
              "https://e-warung.my.id/assets/users/${pref.userLogin.id}/products/abc ?? ""}",
              fit: BoxFit.fill,
            )
                : const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
              size: 50,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  widget.id,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorBlue, fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8,),
                Text(
                  "Rp. 20.000",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textFieldColorGrey, fontSize: 15.0),
                ),
                const SizedBox(height: 8,),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (int.parse(_valueTextController.text) > 1) {
                            cart.decreaseAmount(widget.index);
                          } else if (_valueTextController.text.isEmpty) {
                            cart.changeAmount(widget.index, 1);
                          }
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
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              if (value == "") {
                                cart.changeAmount(widget.index, 1);
                              } else {
                                cart.changeAmount(widget.index, int.parse(value));
                              }
                            },
                          )
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_valueTextController.text.isEmpty) {
                            cart.changeAmount(widget.index, 1);
                          } else {
                            cart.increaseAmount(widget.index);
                          }
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
                    cart.removeResultBarcode(widget.index);
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

  @override
  void dispose() {
    _valueTextController.dispose();
    super.dispose();
  }
}