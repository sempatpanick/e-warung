import 'package:ewarung/common/styles.dart';
import 'package:ewarung/provider/cart_provider.dart';
import 'package:ewarung/provider/preferences_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  static const routeName = '/profile_page';

  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    PreferencesProvider pref = Provider.of<PreferencesProvider>(context);
    CartProvider cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: colorWhiteBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 50.0),
                  padding: const EdgeInsets.all(15.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: textColorWhite,
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
                        child: pref.userLogin.avatar != ""
                          ? Image.network(
                              "https://e-warung.my.id/assets/users/${pref.userLogin.id}/${pref.userLogin.avatar ?? ""}",
                              fit: BoxFit.fill,
                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                  return const Icon(Icons.broken_image, size: 100.0, color: textColorWhite,);
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
                              Icons.person,
                              color: Colors.white,
                              size: 100,
                            ),
                      ),
                      const SizedBox(width: 16,),
                      Text(
                        pref.userLogin.email,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.black, fontSize: 15.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0,),
                SizedBox(
                  width: 120.0,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, LoginPage.routeName);
                      cart.clearAll();
                      pref.removeUserLogin();
                    },
                    child: Text(
                      "Logout",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorWhite, fontSize: 17.0),
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
}