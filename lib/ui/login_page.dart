import 'package:ewarung/common/styles.dart';
import 'package:ewarung/data/model/login_result.dart';
import 'package:ewarung/provider/login_provider.dart';
import 'package:ewarung/provider/preferences_provider.dart';
import 'package:ewarung/ui/main_page.dart';
import 'package:ewarung/ui/register_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    LoginProvider auth = Provider.of<LoginProvider>(context);
    PreferencesProvider pref = Provider.of<PreferencesProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: _isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 45.0, horizontal: 43.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset("assets/img_door_user.png"),
                ),
                const SizedBox(height: 20,),
                Text(
                  "Login",
                  style: Theme.of(context).textTheme.headline5!.copyWith(color: primaryColor, fontSize: 24.0, fontWeight: FontWeight.bold, letterSpacing: 0.75),
                ),
                const SizedBox(height: 22,),
                CupertinoTextField(
                  controller: _emailTextController,
                  keyboardType: TextInputType.emailAddress,
                  placeholder: 'Email address',
                  placeholderStyle: const TextStyle(
                    color: textFieldColorGrey,
                    fontSize: 16.0,
                  ),
                  prefix: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.email_outlined,
                      size: 20,
                      color: textFieldColorGrey,
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: textColorGrey,
                  ),
                  onSubmitted: (value) {
                  },
                ),
                const SizedBox(height: 16,),
                CupertinoTextField(
                  controller: _passwordTextController,
                  keyboardType: TextInputType.text,
                  obscureText: _passwordVisible,
                  placeholder: 'Password',
                  placeholderStyle: const TextStyle(
                    color: textFieldColorGrey,
                    fontSize: 16.0,
                  ),
                  prefix: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: IconButton(
                        padding: const EdgeInsets.all(0),
                        alignment: Alignment.centerLeft,
                        icon: _passwordVisible ? const Icon(Icons.visibility_outlined) : const Icon(Icons.visibility_off_outlined),
                        iconSize: 22,
                        color: textFieldColorGrey,
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: textColorGrey,
                  ),
                  onSubmitted: (value) {
                  },
                ),
                const SizedBox(height: 22,),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 40.0,
                  child: ElevatedButton(
                    onPressed: () {
                      String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regExp = RegExp(pattern);

                      if (_emailTextController.text.isEmpty || _passwordTextController.text.isEmpty) {
                        showNotification(context, "Username or password can't be empty");
                      } else if (!regExp.hasMatch(_emailTextController.text)) {
                        showNotification(context, "Invalid Email");
                      } else {
                        setState(() {
                          _isLoading = true;
                        });
                        signIn(auth, pref);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: Text(
                      "Login",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColorWhite, fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 16,),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                          child: const Divider(
                            color: primaryColor,
                            height: 1,
                          )),
                    ),
                    Text(
                      "or",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 12.0),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                        child: const Divider(
                          color: primaryColor,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16,),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 40.0,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        Navigator.pushNamed(context, RegisterPage.routeName);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: textColorWhite,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(color: primaryColor)
                      ),
                    ),
                    child: Text(
                      "Register",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: primaryColor, fontSize: 16.0, fontWeight: FontWeight.bold),
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

  signIn(LoginProvider auth, PreferencesProvider pref) async {
    try {
      final Future<LoginResult> response = auth.fetchLogin(_emailTextController.text, _passwordTextController.text);

      response.then((value) {
        if (value.status) {
          setState(() {
            _isLoading = false;
          });
          pref.setUserLogin(value.user!);
          Navigator.pushReplacementNamed(context, MainPage.routeName);
          showNotification(context, "Selamat datang ${value.user!.nama ?? value.user!.email}");
        } else {
          setState(() {
            _isLoading = false;
          });
          showNotification(context, value.message);
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showNotification(context, "Error : $e");
    }
  }

  void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }
}