import 'dart:io';

import 'package:article_app_v4/helper/constants.dart';
import 'package:article_app_v4/helper/helper_prefs.dart';
import 'package:article_app_v4/root.dart';
import 'package:article_app_v4/services/firebase_auth.dart';
import 'package:article_app_v4/services/firebase_database.dart';
import 'package:article_app_v4/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String imageUrl;
  File _image;
  bool isLoading = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();

  getUserInfo() async {
    Constants.fullName = await HelperPrefs.getFullNameInPrefs();
    Constants.imageUrl = await HelperPrefs.getUserImageInPrefs();
    Constants.userId = await HelperPrefs.getUserIdInPrefs();
    Constants.email = await HelperPrefs.getUserEmailInPrefs();
    print(Constants.fullName);
    print(Constants.imageUrl);
  }

  Future uploadImage(String imageName) async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(
        source: ImageSource.gallery,
        maxHeight: 500,
        maxWidth: 700,
        imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print(_image);
        DatabaseMethod()
            .uploadUserImage(imageName, _image)
            .then((value) => setState(() => imageUrl = value));
      } else {
        print('No image selected');
      }
    });
  }

  signUp() {
    if (_formKey.currentState.validate()) {
      String fullName =
          firstNameController.text + ' ' + lastNameController.text;
      String imageUrls = imageUrl ??
          'https://apexgloballearning.com/wp-content/themes/apex/images/domain/noimage.jpg';
      HelperPrefs.saveFullNameInPrefs(fullName);
      HelperPrefs.saveUserImageInPrefs(imageUrls);
      HelperPrefs.saveUserEmailInPrefs(emailController.text);

      AuthMethod()
          .signUpWithEmailandPassword(
              emailController.text, passwordController.text)
          .then((value) {
        if (value == false) {
          _scaffoldKey.currentState.showSnackBar(
            new SnackBar(
              content: Text(
                'Email already taken.',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
          setState(() {
            isLoading = false;
          });
        } else {
          Map<String, String> userInfoMap = {
            "firstname": firstNameController.text,
            "lastname": lastNameController.text,
            "email": emailController.text,
            "imageUrl": imageUrl,
          };

          DatabaseMethod().saveUserInfo(userInfoMap).then((value) {
            getUserInfo();
            setState(() {
              isLoading = false;
            });
            Navigator.pushNamedAndRemoveUntil(
                context, '/', ModalRoute.withName('login'));
          });
        }
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMhhmmkkmmss').format(now);
    String picName = 'picimage$formattedDate';
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      //     const SizedBox(height: 50),
                      Text(
                        'Article App',
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -2.0),
                      ),
                      const SizedBox(height: 10),
                      Stack(
                        children: [
                          ClipOval(
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              width: 250,
                              height: 250,
                              imageUrl: imageUrl ??
                                  'https://apexgloballearning.com/wp-content/themes/apex/images/domain/noimage.jpg',
                              progressIndicatorBuilder: (
                                context,
                                imageUrl,
                                downloadProgress,
                              ) =>
                                  Center(
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress)),
                            ),
                          ),
                          Positioned(
                            //right: 100,
                            bottom: 0,
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width - 10,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey[50].withOpacity(.6),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 25,
                            right: 105,
                            child: IconButton(
                              onPressed: () => uploadImage(picName),
                              icon: Icon(
                                Icons.add_a_photo,
                                color: Colors.blue,
                                size: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFieldLogin(
                              validator: (val) {
                                return val.length < 2
                                    ? "Invalid first name"
                                    : null;
                              },
                              controller: firstNameController,
                              hint: 'First Name',
                            ),
                            TextFieldLogin(
                              validator: (val) {
                                return val.length < 2
                                    ? "Invalid last name"
                                    : null;
                              },
                              controller: lastNameController,
                              hint: 'Last Name',
                            ),
                            TextFieldLogin(
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~"
                                            r"]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val)
                                    ? null
                                    : "Enter valid email.";
                              },
                              controller: emailController,
                              hint: 'Email',
                            ),
                            TextFieldLogin(
                              validator: (val) {
                                return val.length < 7 || val.isEmpty
                                    ? "Choose a stronger password."
                                    : null;
                              },
                              controller: passwordController,
                              hint: 'Password',
                              isObscureText: true,
                            ),
                            TextFieldLogin(
                              validator: (val) {
                                return val != passwordController.text
                                    ? "Password did not match."
                                    : null;
                              },
                              controller: rePasswordController,
                              hint: 'Retype Password',
                              isObscureText: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Ink(
                          height: 40,
                          width: MediaQuery.of(context).size.width - 10,
                          decoration: BoxDecoration(
                              color: Colors.blue[600],
                              borderRadius: BorderRadius.circular(12.0)),
                          child: InkWell(
                            onTap: () {
                              setState(() => isLoading = true);
                              signUp();
                            },
                            child: Center(
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
