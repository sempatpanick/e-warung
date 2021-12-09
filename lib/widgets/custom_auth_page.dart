import 'package:ewarung/common/styles.dart';
import 'package:ewarung/data/model/login_result.dart';
import 'package:ewarung/data/model/register_result.dart';
import 'package:ewarung/provider/login_provider.dart';
import 'package:ewarung/provider/preferences_provider.dart';
import 'package:ewarung/provider/register_provider.dart';
import 'package:ewarung/provider/user_provider.dart';
import 'package:ewarung/ui/main_page.dart';
import 'package:ewarung/ui/register_page.dart';
import 'package:ewarung/widgets/custom_notification_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

class CustomAuthPage extends StatefulWidget {
  final bool isLogin;

  const CustomAuthPage({Key? key, required this.isLogin}) : super(key: key);

  @override
  State<CustomAuthPage> createState() => _CustomAuthPageState();
}

class _CustomAuthPageState extends State<CustomAuthPage> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    LoginProvider authLogin = Provider.of<LoginProvider>(context);
    RegisterProvider authRegister = Provider.of<RegisterProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
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
                  child: widget.isLogin ? Image.asset("assets/img_door_user.png") : Image.asset("assets/img_phone_user.png"),
                ),
                const SizedBox(height: 20,),
                Text(
                  widget.isLogin ? "Login" : "Register",
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

                      if (_emailTextController.text.isEmpty || _passwordTextController.text.isEmpty) {
                        CustomNotificationSnackbar(context: context, message: "Username or password can't be empty");
                      } else if (isEmail(_emailTextController.text)) {
                        setState(() {
                          _isLoading = true;
                        });
                        widget.isLogin ? signIn(authLogin, userProvider, pref) : signUp(authRegister);
                      } else {
                        CustomNotificationSnackbar(context: context, message: "Invalid Email");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: Text(
                      widget.isLogin ? "Login" : "Register",
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
                        widget.isLogin ? Navigator.pushNamed(context, RegisterPage.routeName) : Navigator.pop(context);
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
                      widget.isLogin ? "Register" : "Login",
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

  signIn(LoginProvider auth, UserProvider userProvider, PreferencesProvider pref) async {
    try {
      final Future<LoginResult> response = auth.fetchLogin(_emailTextController.text, _passwordTextController.text);

      response.then((value) {
        if (value.status) {
          setState(() {
            _isLoading = false;
          });

          pref.setUserLogin(value.user!);
          Navigator.pushReplacementNamed(context, MainPage.routeName);

          CustomNotificationSnackbar(context: context,
              message: "Selamat datang ${value.user!.nama ??
                  value.user!.email}");
        } else {
          setState(() {
            _isLoading = false;
          });

          CustomNotificationSnackbar(context: context, message: value.message);
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      CustomNotificationSnackbar(context: context, message: "Error : $e");
    }
  }

  signUp(RegisterProvider auth) async {
    try {
      final Future<RegisterResult> response = auth.fetchRegister(_emailTextController.text, _passwordTextController.text);

      response.then((value) {
        if (value.status) {
          setState(() {
            _isLoading = false;
          });

          CustomNotificationSnackbar(context: context, message: "Akun berhasil didaftarkan, silahkan login");
        } else {
          setState(() {
            _isLoading = false;
          });

          CustomNotificationSnackbar(context: context, message: value.message);
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      CustomNotificationSnackbar(context: context, message: "Error : $e");
    }
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }
}