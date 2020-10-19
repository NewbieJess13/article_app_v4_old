import 'dart:io';
import 'package:article_app_v4/helper/constants.dart';
import 'package:article_app_v4/root.dart';
import 'package:article_app_v4/services/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class WriteArticle extends StatefulWidget {
  @override
  _WriteArticleState createState() => _WriteArticleState();
}

class _WriteArticleState extends State<WriteArticle> {
  String imageUrl;
  File _image;
  String status;
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController contextController = TextEditingController();

  Future uploadImage(String imageName) async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(
        source: ImageSource.gallery,
        maxWidth: 700,
        imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print(_image);
        DatabaseMethod()
            .uploadImage(imageName, _image)
            .then((value) => setState(() => imageUrl = value));
      } else {
        print('No image selected');
      }
    });
  }

  publishArticle() {
    if (_formKey.currentState.validate()) {
      Map<String, dynamic> articleMap = {
        'title': titleController.text,
        'author': Constants.fullName,
        'context': contextController.text,
        'imageUrl': imageUrl ??
            'https://apexgloballearning.com/wp-content/themes/apex/images/domain/noimage.jpg',
        'status': status,
        'dateCreated': DateTime.now().microsecondsSinceEpoch,
        'userId': Constants.userId,
      };
      DatabaseMethod().saveArticle(articleMap).then((value) =>
          Navigator.pushNamedAndRemoveUntil(
              context, '/', ModalRoute.withName('/articlelist')));
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMhhmmkkmmss').format(now);
    String picName = 'picimage$formattedDate';
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton.icon(
              onPressed: () {
                setState(() => status = '0');
                publishArticle();
              },
              icon: Icon(
                Icons.drafts,
                color: Colors.white,
              ),
              label: Text(
                'Save to drafts',
                style: TextStyle(fontWeight: FontWeight.w800),
              )),
          FlatButton.icon(
              onPressed: () {
                setState(() => status = '1');
                publishArticle();
              },
              icon: Icon(
                Icons.create,
                color: Colors.white,
              ),
              label: Text(
                'Publish',
                style: TextStyle(fontWeight: FontWeight.w800),
              )),
        ],
      ),
      body: CustomScrollView(slivers: [
        SliverFillRemaining(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  height: 300,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl != null
                        ? imageUrl
                        : 'https://apexgloballearning.com/wp-content/themes/apex/images/domain/noimage.jpg',
                    progressIndicatorBuilder:
                        (context, imageUrl, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress)),
                    fit: BoxFit.cover,
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: RaisedButton(
                  color: Colors.blue[600],
                  child: Text('Upload Image'),
                  onPressed: () => uploadImage(picName),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        validator: (val) {
                          return val.length < 10 ? "Title too short" : null;
                        },
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                            labelText: 'Title',
                            labelStyle: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      TextFormField(
                        controller: contextController,
                        validator: (val) {
                          return val.length < 10 ? "Title too short" : null;
                        },
                        maxLines: 5,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w700),
                        decoration: InputDecoration(
                            labelText: 'Context',
                            labelStyle: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ]),
    );
  }
}
