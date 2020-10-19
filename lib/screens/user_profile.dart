import 'dart:io';
import 'package:article_app_v4/helper/constants.dart';
import 'package:article_app_v4/models/user.dart';
import 'package:article_app_v4/root.dart';
import 'package:article_app_v4/services/firebase_auth.dart';
import 'package:article_app_v4/services/firebase_database.dart';
import 'package:article_app_v4/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
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
  DocumentReference docUserId;
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
      Map<String, String> userInfoMap = {
        "firstname": firstNameController.text,
        "lastname": lastNameController.text,
        "imageUrl": imageUrl ?? Constants.imageUrl,
      };
      DatabaseMethod().updateUserInfo(userInfoMap, docUserId).then((value) {
        setState(() => isLoading = false);
        Navigator.pushNamedAndRemoveUntil(
            context, '/', ModalRoute.withName('/articlelist'));
      });
    }
  }

  @override
  void initState() {
    DatabaseMethod().getUserNamebyEmail(Constants.email).then((value) {
      setState(() {
        firstNameController.text = value.docs[0].data()['firstname'];
        lastNameController.text = value.docs[0].data()['lastname'];
        imageUrl = value.docs[0].data()['imageUrl'];
        docUserId = value.docs[0].reference;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMhhmmkkmmss').format(now);
    String picName = 'picimage$formattedDate';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage your profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
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
                      const SizedBox(height: 10),
                      Stack(
                        children: [
                          ClipOval(
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              width: 250,
                              height: 250,
                              imageUrl: imageUrl ?? Constants.imageUrl,
                              progressIndicatorBuilder: (
                                context,
                                imageUrl,
                                downloadProgress,
                              ) =>
                                  Center(
                                child: CircularProgressIndicator(
                                    value: downloadProgress.progress),
                              ),
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
                            // TextFieldLogin(
                            //   validator: (val) {
                            //     return val.length < 7 || val.isEmpty
                            //         ? "Choose a stronger password."
                            //         : null;
                            //   },
                            //   controller: passwordController,
                            //   hint: 'Password',
                            //   isObscureText: true,
                            // ),
                            // TextFieldLogin(
                            //   validator: (val) {
                            //     return val != passwordController.text
                            //         ? "Password did not match."
                            //         : null;
                            //   },
                            //   controller: rePasswordController,
                            //   hint: 'Retype Password',
                            //   isObscureText: true,
                            // ),
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
                                'Update Information',
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
