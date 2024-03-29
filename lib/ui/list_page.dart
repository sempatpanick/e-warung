import 'package:ewarung/common/styles.dart';
import 'package:ewarung/data/model/products_user_result.dart';
import 'package:ewarung/provider/cart_provider.dart';
import 'package:ewarung/provider/preferences_provider.dart';
import 'package:ewarung/provider/user_provider.dart';
import 'package:ewarung/provider/utils_provider.dart';
import 'package:ewarung/ui/form_product_page.dart';
import 'package:ewarung/widgets/custom_notification_snackbar.dart';
import 'package:ewarung/widgets/expandable_fab.dart';
import 'package:ewarung/widgets/item_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ListPage extends StatefulWidget {
  static const routeName = '/list_page';
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  bool _isSearch = false;
  List<Products> listSearch = [];
  late Products product;

  final TextEditingController _searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    PreferencesProvider pref = Provider.of<PreferencesProvider>(context);
    CartProvider cart = Provider.of<CartProvider>(context);
    UserProvider userProv = Provider.of<UserProvider>(context);
    UtilsProvider utilsProvider = Provider.of<UtilsProvider>(context);

    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () async {
        await userProv.fetchProductsUser(pref.userLogin.id).then((value) {
          if (value.status) {
            cart.addUserProducts(value.data ?? []);
          } else {
            CustomNotificationSnackbar(context: context, message: value.message);
          }
        });
      },
      child: Scaffold(
        backgroundColor: colorWhiteBlue,
        floatingActionButton: const ExpandableFab(),
        body: utilsProvider.isFormInputProduct ? FormProductPage(utilsProvider: utilsProvider, cart: cart, userProv: userProv, pref: pref,) : _buildListPage(pref, cart, userProv, utilsProvider),
      ),
    );
  }

  Widget _buildListPage(PreferencesProvider pref, CartProvider cart, UserProvider userProv, UtilsProvider utilsProvider) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 24.0, top: 24.0, right: 24.0, bottom: 60.0),
          child: Column(
            children: [
              CupertinoTextField(
                controller: _searchTextController,
                keyboardType: TextInputType.emailAddress,
                placeholder: 'Search',
                placeholderStyle: const TextStyle(
                  color: textFieldColorGrey,
                  fontSize: 16.0,
                ),
                prefix: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.search,
                    size: 20,
                    color: textFieldColorGrey,
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: textColorWhite,
                ),
                onChanged: (value) {
                  if (value == "") {
                    setState(() {
                      _isSearch = false;
                    });
                  } else {
                    listSearch.clear();
                    listSearch.addAll(cart.listProducts.where((element) => element.nama.toLowerCase().contains(value.toLowerCase())));
                    setState(() {
                      _isSearch = true;
                    });
                  }
                },
              ),
              const SizedBox(height: 16,),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _isSearch ? listSearch.length : cart.listProducts.length,
                itemBuilder: (context, index) {
                  var product = _isSearch ? listSearch[index] : cart.listProducts[index];
                  return ItemProduct(index: index, utilsProvider: utilsProvider, product: product, cart: cart, userProv: userProv, pref: pref,);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }
}

