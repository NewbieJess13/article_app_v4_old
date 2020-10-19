import 'package:article_app_v4/helper/constants.dart';
import 'package:article_app_v4/helper/helper_prefs.dart';
import 'package:article_app_v4/screens/screens.dart';
import 'package:article_app_v4/services/firebase_auth.dart';
import 'package:article_app_v4/services/firebase_database.dart';
import 'package:article_app_v4/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  getUserInfo() async {
    Constants.fullName = await HelperPrefs.getFullNameInPrefs();
    Constants.imageUrl = await HelperPrefs.getUserImageInPrefs();
    Constants.userId = await HelperPrefs.getUserIdInPrefs();
    Constants.email = await HelperPrefs.getUserEmailInPrefs();
    print(Constants.fullName);
    print(Constants.imageUrl);
  }

//Login Function
  void signIn() {
    if (_formKey.currentState.validate()) {
      if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~"
                  r"]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(emailController.text) &&
          passwordController.text.length >= 8) {
        //login
        DatabaseMethod()
            .getUserNamebyEmail(emailController.text.trim())
            .then((_) {
          getUserInfo();
          AuthMethod()
              .signInWithEmailandPassword(
                  emailController.text, passwordController.text)
              .then((value) {
            if (value) {
            } else {
              _scaffoldKey.currentState.showSnackBar(new SnackBar(
                  content: Text('Incorrect email or password',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold))));
            }
            setState(() => isLoading = false);
          });
        });
      } else {
        setState(() => isLoading = false);
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
            content: Text(
          'Invalid email or password',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        )));
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(children: [
                    const SizedBox(height: 200),
                    Text(
                      'Article App',
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -2.0),
                    ),
                    const SizedBox(height: 50),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFieldLogin(
                            controller: emailController,
                            hint: 'Email',
                          ),
                          TextFieldLogin(
                            controller: passwordController,
                            hint: 'Password',
                            isObscureText: true,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Ink(
                              height: 40,
                              width: MediaQuery.of(context).size.width - 10,
                              decoration: BoxDecoration(
                                  color: Colors.blue[600],
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: InkWell(
                                onTap: () {
                                  setState(() => isLoading = true);
                                  signIn();
                                },
                                child: Center(
                                    child: Text('Login',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold))),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                              flex: 1,
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  shape: BoxShape.circle,
                                ),
                                height: 40,
                                width: 40,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(60),
                                  onTap: () {
                                    AuthMethod().signInWithGoogle().then((_) {
                                      getUserInfo();
                                    });
                                  },
                                  child: Image.asset('images/Google.webp',
                                      height: 30, width: 30),
                                ),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text('Sign Up',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                    )
                  ]),
                ),
              ],
            ),
    );
  }
}
