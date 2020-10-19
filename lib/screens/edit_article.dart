import 'dart:io';
import 'package:article_app_v4/models/article.dart';
import 'package:article_app_v4/root.dart';
import 'package:article_app_v4/services/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditArticle extends StatefulWidget {
  final Article article;

  const EditArticle({Key key, this.article}) : super(key: key);

  @override
  _EditArticleState createState() => _EditArticleState();
}

class _EditArticleState extends State<EditArticle> {
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
        maxHeight: 500,
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
        'context': contextController.text,
        'imageUrl': imageUrl ?? widget.article.imageUrl,
        'status': status,
        'dateCreated': DateTime.now().microsecondsSinceEpoch,
      };
      DatabaseMethod()
          .updateArticle(articleMap, widget.article.id)
          .then((value) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/', ModalRoute.withName('/articlelist'));
      });
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
    titleController.text = widget.article.title;
    contextController.text = widget.article.context;
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
                    imageUrl: imageUrl ?? widget.article.imageUrl,
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
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
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
