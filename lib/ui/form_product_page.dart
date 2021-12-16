import 'dart:convert';
import 'dart:io';

import 'package:ewarung/common/styles.dart';
import 'package:ewarung/data/model/geeneral_result.dart';
import 'package:ewarung/data/model/products_user_result.dart';
import 'package:ewarung/data/model/recommended_product_result.dart';
import 'package:ewarung/provider/cart_provider.dart';
import 'package:ewarung/provider/preferences_provider.dart';
import 'package:ewarung/provider/user_provider.dart';
import 'package:ewarung/provider/utils_provider.dart';
import 'package:ewarung/widgets/custom_notification_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:string_validator/string_validator.dart';

class FormProductPage extends StatefulWidget {
  final UtilsProvider utilsProvider;
  final CartProvider cart;
  final UserProvider userProv;
  final PreferencesProvider pref;
  const FormProductPage({Key? key, required this.utilsProvider, required this.cart, required this.userProv, required this.pref}) : super(key: key);

  @override
  State<FormProductPage> createState() => _FormProductPageState();
}

class _FormProductPageState extends State<FormProductPage> {
  final formKey = GlobalKey<FormState>();
  bool _isLoadingAdd = false;
  final ImagePicker _picker = ImagePicker();
  XFile? imageChoosed;

  final TextEditingController _textIdProductController = TextEditingController();
  final TextEditingController _textNameProductController = TextEditingController();
  final TextEditingController _textDescriptionProductController = TextEditingController();
  final TextEditingController _textPriceProductController = TextEditingController();
  final TextEditingController _textStockProductController = TextEditingController();

  Future<void> chooseImage(ImageSource source) async {
    final choseImage = await _picker.pickImage(source: source, imageQuality: 25);
    setState(() {
      imageChoosed = choseImage;
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to cancel this form?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                widget.utilsProvider.setIsFormInputProduct(false);
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      )
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      setState(() {
        _textIdProductController.text = widget.utilsProvider.recommendedProduct.id;
        _textNameProductController.text = widget.utilsProvider.recommendedProduct.nama;
        _textDescriptionProductController.text = widget.utilsProvider.recommendedProduct.keterangan ?? "";
        _textPriceProductController.text = widget.utilsProvider.recommendedProduct.harga;
        _textStockProductController.text = widget.utilsProvider.recommendedProduct.stok ?? "";
      });
    }
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: colorWhiteBlue,
        appBar: AppBar(
          backgroundColor: primaryColor,
          leading: IconButton(
            onPressed: () {
              setState(() {
                widget.utilsProvider.setIsFormInputProduct(false);
              });
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(
            widget.utilsProvider.formProduct.title,
            style: Theme.of(context).textTheme.headline6!.copyWith(color: textColorWhite),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                _isLoadingAdd ? const LinearProgressIndicator() : Container(),
                Container(
                  margin: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    title: const Center(child: Text("Select From"),),
                                    content:  Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            setState(() {
                                              setProductForm();
                                              Navigator.pop(context);
                                            });
                                            chooseImage(ImageSource.gallery);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: primaryColor
                                          ),
                                          icon: const Icon(Icons.photo),
                                          label: const Text("Gallery"),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            setState(() {
                                              setProductForm();
                                              Navigator.pop(context);
                                            });
                                            chooseImage(ImageSource.camera);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              primary: primaryColor
                                          ),
                                          icon: const Icon(Icons.camera_alt),
                                          label: const Text("Camera"),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(color: textFieldColorGrey),
                                        ),
                                        onPressed: () {
                                          setProductForm();
                                          setState(() {
                                            Navigator.pop(context);
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                }
                            );
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: primaryColor,
                            ),
                            child: imageChoosed != null
                                ? Image.file(File(imageChoosed!.path))
                                : widget.utilsProvider.recommendedProduct.gambar != ""
                                  ? Image.network(
                                      "https://e-warung.my.id/assets/users/${widget.utilsProvider.recommendedProduct.gambar}",
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
                        ),
                        const SizedBox(height: 16.0,),
                        TextFormField(
                          controller: _textIdProductController,
                          enabled: widget.utilsProvider.formProduct.type == 'update_product' ? false : true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: widget.utilsProvider.formProduct.type == 'update_product' ? textFieldColorGrey : textColorWhite,
                            labelText: "ID Product",
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: textColorWhite),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: textColorWhite),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                          ),
                          validator: (value) {
                            if (value == "") {
                              return "ID product can't be empty";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 16.0,),
                        TextFormField(
                          controller: _textNameProductController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: textColorWhite,
                            labelText: "Product Name",
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: textColorWhite),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: textColorWhite),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                          ),
                          validator: (value) {
                            if (value == "") {
                              return "Product name can't be empty";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 16.0,),
                        TextFormField(
                          controller: _textDescriptionProductController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: textColorWhite,
                            labelText: "Product Description (optional)",
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: textColorWhite),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: textColorWhite),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0,),
                        TextFormField(
                          controller: _textPriceProductController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: textColorWhite,
                            labelText: "Product Price",
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: textColorWhite),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: textColorWhite),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == "") {
                              return "Product price can't be empty";
                            } else {
                              if (!isNumeric(value!)) {
                                return "only numeric!";
                              } else {
                                return null;
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 16.0,),
                        TextFormField(
                          controller: _textStockProductController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: textColorWhite,
                            labelText: "Product Stock",
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: textColorWhite),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: textColorWhite),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == "") {
                              return "Product stock can't be empty";
                            } else {
                              if (!isNumeric(value!)) {
                                return "only numeric!";
                              } else {
                                return null;
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 16.0,),
                        SizedBox(
                          width: 150.0,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                            onPressed: _isLoadingAdd ? null : () {
                              setProductForm();
                              final isValid = formKey.currentState!.validate();
                              if (isValid) {
                                if (widget.utilsProvider.formProduct.type == "add_product") {
                                  setState(() {
                                    _isLoadingAdd = true;
                                  });
                                  formKey.currentState!.save();

                                  addProduct();
                                } else if (widget.utilsProvider.formProduct.type == "update_product") {
                                  setState(() {
                                    _isLoadingAdd = true;
                                  });
                                  formKey.currentState!.save();

                                  updateProduct();
                                }
                              }
                            },
                            child: _isLoadingAdd ? const CircularProgressIndicator() : Text(
                              widget.utilsProvider.formProduct.title,
                              style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorWhite),
                            ),
                          ),
                        ),
                      ],
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

  Future<void> addProduct() async {
    try {
      Future<GeneralResult> response;
      if (imageChoosed != null) {
        File filePath = File(imageChoosed!.path);
        List<int> imageBytes = filePath.readAsBytesSync();
        String baseImage = base64Encode(imageBytes);
        response = widget.userProv.fetchAddProductUser(widget.pref.userLogin.id, _textIdProductController.text, _textNameProductController.text, _textDescriptionProductController.text, int.parse(_textPriceProductController.text), int.parse(_textStockProductController.text), "${widget.pref.userLogin.id}/products/${path.basename(imageChoosed!.path)}", baseImage);
      } else {
        response = widget.userProv.fetchAddProductUser(widget.pref.userLogin.id, _textIdProductController.text, _textNameProductController.text, _textDescriptionProductController.text, int.parse(_textPriceProductController.text), int.parse(_textStockProductController.text), widget.utilsProvider.recommendedProduct.gambar ?? "", "");
      }

      response.then((value) {
        if (value.status) {
          try {
            final Future<ProductsUserResult> responseProducts = widget.userProv.fetchProductsUser(widget.pref.userLogin.id);

            responseProducts.then((valueProducts) {
              setState(() {
                _isLoadingAdd = false;
              });

              if (valueProducts.status) {
                setState(() {
                  widget.cart.addUserProducts(valueProducts.data ?? []);
                  widget.utilsProvider.setIsFormInputProduct(false);
                  widget.utilsProvider.setRecommendedProduct(RecommendedProduct(id: "", nama: "", keterangan: "", harga: "", gambar: ""));
                });

                CustomNotificationSnackbar(context: context, message: value.message);
              } else {
                CustomNotificationSnackbar(context: context, message: valueProducts.message);
              }
            });
          } catch (e) {
            setState(() {
              _isLoadingAdd = false;
            });

            CustomNotificationSnackbar(context: context, message: "Error : $e");
          }
        } else {
          setState(() {
            _isLoadingAdd = false;
          });

          CustomNotificationSnackbar(context: context, message: value.message);
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingAdd = false;
      });

      CustomNotificationSnackbar(context: context, message: "Error: $e");
    }
  }

  Future<void> updateProduct() async {
    try {
      Future<GeneralResult> response;
      if (imageChoosed != null) {
        File filePath = File(imageChoosed!.path);
        List<int> imageBytes = filePath.readAsBytesSync();
        String baseImage = base64Encode(imageBytes);
        response = widget.userProv.fetchUpdateProductUser(widget.pref.userLogin.id, _textIdProductController.text, _textNameProductController.text, _textDescriptionProductController.text, int.parse(_textPriceProductController.text), int.parse(_textStockProductController.text), "${widget.pref.userLogin.id}/products/${path.basename(imageChoosed!.path)}", baseImage);
      } else {
        response = widget.userProv.fetchUpdateProductUser(widget.pref.userLogin.id, _textIdProductController.text, _textNameProductController.text, _textDescriptionProductController.text, int.parse(_textPriceProductController.text), int.parse(_textStockProductController.text), widget.utilsProvider.recommendedProduct.gambar ?? "", "");
      }

      response.then((value) {
        if (value.status) {
          try {
            final Future<ProductsUserResult> responseProducts = widget.userProv.fetchProductsUser(widget.pref.userLogin.id);

            responseProducts.then((valueProducts) {
              setState(() {
                _isLoadingAdd = false;
              });

              if (valueProducts.status) {
                setState(() {
                  widget.cart.addUserProducts(valueProducts.data ?? []);
                  widget.utilsProvider.setIsFormInputProduct(false);
                  widget.utilsProvider.setRecommendedProduct(RecommendedProduct(id: "", nama: "", keterangan: "", harga: "", gambar: ""));
                });

                CustomNotificationSnackbar(context: context, message: value.message);
              } else {
                CustomNotificationSnackbar(context: context, message: valueProducts.message);
              }
            });
          } catch (e) {
            setState(() {
              _isLoadingAdd = false;
            });

            CustomNotificationSnackbar(context: context, message: "Error : $e");
          }
        } else {
          setState(() {
            _isLoadingAdd = false;
          });

          CustomNotificationSnackbar(context: context, message: value.message);
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingAdd = false;
      });

      CustomNotificationSnackbar(context: context, message: "Error: $e");
    }
  }

  void setProductForm() {
    if (imageChoosed != null) {
      widget.utilsProvider.setRecommendedProduct(RecommendedProduct(id: _textIdProductController.text, nama: _textNameProductController.text, keterangan: _textDescriptionProductController.text, harga: _textPriceProductController.text, stok: _textStockProductController.text, gambar: "${widget.pref.userLogin.id}/products/${path.basename(imageChoosed!.path)}"));
    } else {
      widget.utilsProvider.setRecommendedProduct(RecommendedProduct(id: _textIdProductController.text, nama: _textNameProductController.text, keterangan: _textDescriptionProductController.text, harga: _textPriceProductController.text, stok: _textStockProductController.text, gambar: widget.utilsProvider.recommendedProduct.gambar));
    }
  }

  @override
  void dispose() {
    _textIdProductController.dispose();
    _textNameProductController.dispose();
    _textDescriptionProductController.dispose();
    _textPriceProductController.dispose();
    _textStockProductController.dispose();

    super.dispose();
  }
}
