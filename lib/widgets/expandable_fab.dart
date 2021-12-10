import 'package:ewarung/common/styles.dart';
import 'package:ewarung/data/model/form_product.dart';
import 'package:ewarung/data/model/recommended_product_result.dart';
import 'package:ewarung/provider/cart_provider.dart';
import 'package:ewarung/provider/user_provider.dart';
import 'package:ewarung/provider/utils_provider.dart';
import 'package:ewarung/widgets/custom_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

import 'custom_notification_snackbar.dart';

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({Key? key}) : super(key: key);

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _textIdProductController = TextEditingController();
  bool _isOpened = false;
  late AnimationController _animationController;
  late Animation<Color?> _buttonColor;
  late Animation<double> _animateIcon;
  late Animation<double> _translateButton;
  final Curve _curve = Curves.easeOut;
  final double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
    AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: primaryColor,
      end: colorRed,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  animate() {
    if (!_isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    _isOpened = !_isOpened;
  }

  Widget addProductBarcode(UserProvider userProvider, CartProvider cartProvider, UtilsProvider utilsProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _isOpened
            ? Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: textColorBlue,
            border: Border.all(color: textColorGrey),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Text(
            "Add Product",
            style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorWhite, fontSize: 16.0, fontWeight: FontWeight.w600),
          ),
        )
            : Container(),
        FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () {
            scanBarcodeNormal(userProvider, cartProvider, utilsProvider);
          },
          tooltip: 'Add Product',
          child: const Icon(Icons.document_scanner_outlined),
        ),
      ],
    );
  }

  Widget addProductManual(UserProvider userProvider, CartProvider cartProvider, UtilsProvider utilsProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _isOpened
            ? Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: textColorBlue,
            border: Border.all(color: textColorGrey),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Text(
            "Add Product Manually",
            style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorWhite, fontSize: 16.0, fontWeight: FontWeight.w600),
          ),
        )
            : Container(),
        FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () {
            showDialog(context: context, builder: (context) {
              return Form(
                key: formKey,
                child: CustomAlertDialog(
                    title: Center(
                      child: Text(
                        "Add New Product",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorBlue, fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _textIdProductController,
                          decoration: const InputDecoration(
                              labelText: "ID Product",
                              border: OutlineInputBorder()
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    submit: () {
                      final isValid = formKey.currentState!.validate();

                      if (isValid) {
                        formKey.currentState!.save();
                        processAdd(userProvider, cartProvider, utilsProvider, _textIdProductController.text, "manual");
                      }
                    }
                ),
              );
            });
          },
          tooltip: 'Add stock',
          child: const Icon(Icons.note_add_outlined),
        ),
      ],
    );
  }

  Widget toggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          backgroundColor: _buttonColor.value,
          onPressed: animate,
          tooltip: _isOpened ? 'Close Menu' : 'Open Menu',
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _animateIcon,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    UtilsProvider utilsProvider = Provider.of<UtilsProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: addProductBarcode(userProvider, cartProvider, utilsProvider),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: addProductManual(userProvider, cartProvider, utilsProvider),
        ),
        toggle(),
      ],
    );
  }

  Future<void> scanBarcodeNormal(UserProvider userProvider, CartProvider cartProvider, UtilsProvider utilsProvider) async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    if (barcodeScanRes != "-1") {
      processAdd(userProvider, cartProvider, utilsProvider, barcodeScanRes, "scan");
    }
  }

  processAdd(UserProvider userProvider, CartProvider cartProvider, UtilsProvider utilsProvider, String idProduct, String type) async {
    if (!cartProvider.listProducts.any((element) => element.idProduk == idProduct)) {
      try {
        final Future<RecommendedProductResult> response = userProvider.fetchRecommendedProduct(idProduct);

        response.then((value) {
          RecommendedProduct recommendedProduct = RecommendedProduct(id: idProduct, nama: "", keterangan: "", harga: "", gambar: "");
          FormProduct formProduct = FormProduct(title: "Add Product", type: "add_product");
          if (type == "manual") {
            setState(() {
              Navigator.pop(context);
            });
          }
          if(value.status) {
            setState(() {
              utilsProvider.setIsFormInputProduct(true);
              utilsProvider.setRecommendedProduct(value.data ?? recommendedProduct);
              utilsProvider.setFormProduct(formProduct);
            });
            CustomNotificationSnackbar(context: context, message: "There are recommendations for the same product");
          } else {
            setState(() {
              utilsProvider.setIsFormInputProduct(true);
              utilsProvider.setRecommendedProduct(recommendedProduct);
              utilsProvider.setFormProduct(formProduct);
            });
          }
        });
      } catch (e) {
        setState(() {
          utilsProvider.setIsFormInputProduct(false);
        });

        CustomNotificationSnackbar(context: context, message: "Error : $e");
      }
    } else {
      setState(() {
        utilsProvider.setIsFormInputProduct(false);
      });

      CustomNotificationSnackbar(context: context, message: "Produk tersebut sudah terdaftar di toko anda");
    }
  }

  @override
  dispose() {
    _textIdProductController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
