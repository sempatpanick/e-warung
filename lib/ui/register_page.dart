import 'package:ewarung/common/styles.dart';
import 'package:ewarung/data/model/register_result.dart';
import 'package:ewarung/provider/register_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  static const routeName = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    RegisterProvider auth = Provider.of<RegisterProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: _isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 45.0, horizontal: 43.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset("assets/img_phone_user.png"),
                ),
                const SizedBox(height: 20,),
                Text(
                  "Register",
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
                        signUp(auth);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: Text(
                      "Register",
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
                    const Text("or"),
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
                        Navigator.pop(context);
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
                      "Login",
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

  signUp(RegisterProvider auth) async {
    try {
      final Future<RegisterResult> response = auth.fetchRegister(_emailTextController.text, _passwordTextController.text);

      response.then((value) {
        if (value.status) {
          setState(() {
            _isLoading = false;
          });
          showNotification(context, "Akun berhasil didaftarkan, silahkan login");
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