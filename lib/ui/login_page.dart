import 'package:ewarung/common/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                  placeholder: 'Password',
                  placeholderStyle: const TextStyle(
                    color: textFieldColorGrey,
                    fontSize: 16.0,
                  ),
                  prefix: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.remove_red_eye_outlined,
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
                const SizedBox(height: 22,),
                SizedBox(
                  width: double.infinity,
                  height: 40.0,
                  child: ElevatedButton(
                    onPressed: () {},
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
                  width: double.infinity,
                  height: 40.0,
                  child: ElevatedButton(
                    onPressed: () {},
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

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }
}