import 'package:auto_size_text/auto_size_text.dart';
import 'package:ewarung/common/styles.dart';
import 'package:ewarung/data/model/geeneral_result.dart';
import 'package:ewarung/data/model/product_transaction.dart';
import 'package:ewarung/data/model/products_user_result.dart';
import 'package:ewarung/provider/cart_provider.dart';
import 'package:ewarung/provider/history_transaction_provider.dart';
import 'package:ewarung/provider/preferences_provider.dart';
import 'package:ewarung/provider/user_provider.dart';
import 'package:ewarung/utils/get_formatted.dart';
import 'package:ewarung/utils/result_state.dart';
import 'package:ewarung/widgets/custom_alert_dialog.dart';
import 'package:ewarung/widgets/custom_notification_snackbar.dart';
import 'package:ewarung/widgets/custom_notification_widget.dart';
import 'package:ewarung/widgets/item_cart.dart';
import 'package:ewarung/widgets/item_order_history.dart';
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
  final formKey = GlobalKey<FormState>();
  late Products product;
  bool _isLoadingProduct = true;
  bool _isButtonDisabled = true;
  bool _isLoadingTransaction = false;
  int totalPrice = 0;

  final TextEditingController _textPaidController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    PreferencesProvider pref = Provider.of<PreferencesProvider>(context);
    CartProvider cart = Provider.of<CartProvider>(context);
    UserProvider userProv = Provider.of<UserProvider>(context);

    if (mounted) {
      if (cart.resultBarcode.isNotEmpty) {
        _isButtonDisabled = false;
      } else {
        _isButtonDisabled = true;
      }
    }

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: primaryColor,
          appBar: const TabBar(
            labelColor: textColorWhite,
            indicatorColor: textColorWhite,
            unselectedLabelColor: Colors.white54,
            tabs: [
              Tab(text: "Cart",),
              Tab(text: "History Transaction",)
            ]
          ),
          body: Container(
            color: colorWhiteBlue,
            child: TabBarView(
              children: [
                SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        _isLoadingTransaction ? const LinearProgressIndicator() : Container(),
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
                              onPressed: _isButtonDisabled ? null : _isLoadingTransaction ? null : () {
                                checkout(userProv, cart, pref);
                              },
                              icon: Icon(Icons.shopping_cart_outlined, color: _isLoadingTransaction ? Colors.transparent : textColorWhite,),
                              label: _isLoadingTransaction ? const CircularProgressIndicator() : Text(
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
                SingleChildScrollView(
                  child: ChangeNotifierProvider<HistoryTransactionProvider>(
                    create: (_) => HistoryTransactionProvider(pref.userLogin.id),
                    child: Consumer<HistoryTransactionProvider>(
                      builder: (context, state, _) {
                        if (state.stateHistoryTransaction == ResultState.loading) {
                          return SizedBox(height: MediaQuery.of(context).size.height/2, child: const Center(child: CircularProgressIndicator(),));
                        } else if (state.stateHistoryTransaction == ResultState.hasData) {
                          var dataTransactions = state.resultHistoryTransaction.data;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: dataTransactions.length,
                            itemBuilder: (context, index) {
                              return ItemOrderHistory(dataTransaction: dataTransactions[index]);
                            }
                          );
                        } else if (state.stateHistoryTransaction == ResultState.noData) {
                          return SizedBox(height: 50, child: CustomNotificationWidget(message: state.messageHistoryTransaction));
                        } else if (state.stateHistoryTransaction == ResultState.error) {
                          return SizedBox(height: 50, child: CustomNotificationWidget(message: state.messageHistoryTransaction));
                        } else {
                          return const SizedBox(height: 50, child: CustomNotificationWidget(message: "Error: Went Something Wrong.."));
                        }
                      }
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void checkout(UserProvider user, CartProvider cart, PreferencesProvider pref) {
    showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: formKey,
          child: CustomAlertDialog(
            title: Center(
              child: Text(
                "Checkout",
                style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorBlue, fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _textPaidController,
                  decoration: const InputDecoration(
                      labelText: "Money",
                      border: OutlineInputBorder()
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (int.parse(value!) < cart.totalPrice.sum) {
                      return "money is not enough";
                    } else {
                      return null;
                    }
                  },
                ),
              ],
            ),
            submit: () {
              final isValid = formKey.currentState!.validate();

              if (isValid) {
                setState(() {
                  _isLoadingTransaction = true;
                });
                
                formKey.currentState!.save();
                transaction(user, cart, pref);
                
                Navigator.pop(context);
              }
            }
          ),
        );
      }
    );
  }
  
  transaction(UserProvider user, CartProvider cart, PreferencesProvider pref) async {
    try {
      int paid = int.parse(_textPaidController.text);
      int chargeBack = paid - cart.totalPrice.sum;
      List<Map<String, dynamic>> listProduct = [];

      cart.resultBarcode.asMap().forEach((index, element) {
        var dataProduct = cart.listProducts.where((product) => product.idProduk == element);
        listProduct.add(ProductTransaction(idProduct: element, amount: cart.amountProduct[index], price: int.parse(dataProduct.first.harga)).toJson());
      });
      
      final Future<GeneralResult> responseProducts = user.fetchTransaction(pref.userLogin.id, cart.totalPrice.sum, paid, chargeBack, listProduct);

      responseProducts.then((value) {
        if (value.status) {
          try {
            final Future<ProductsUserResult> responseProducts = user.fetchProductsUser(pref.userLogin.id);

            responseProducts.then((valueProducts) {
              setState(() {
                _isLoadingTransaction = false;
              });

              if (valueProducts.status) {
                setState(() {
                  cart.addUserProducts(valueProducts.data ?? []);
                  cart.clear();
                });

                CustomNotificationSnackbar(context: context, message: value.message);
              } else {
                CustomNotificationSnackbar(context: context, message: valueProducts.message);
              }
            });
          } catch (e) {
            setState(() {
              _isLoadingTransaction = false;
            });

            CustomNotificationSnackbar(context: context, message: "Error : $e");
          }
        } else {
          CustomNotificationSnackbar(context: context, message: value.message);
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingTransaction = false;
      });

      CustomNotificationSnackbar(context: context, message: "Error : $e");
    }
  }
}