import 'package:article_app_v4/helper/constants.dart';
import 'package:article_app_v4/models/article.dart';
import 'package:article_app_v4/services/firebase_database.dart';
import 'package:article_app_v4/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyArticles extends StatefulWidget {
  @override
  _MyArticlesState createState() => _MyArticlesState();
}

class _MyArticlesState extends State<MyArticles> {
  Stream articleStream;

  @override
  void initState() {
    DatabaseMethod().getArticlesofUser(Constants.userId).then((value) {
      setState(() {
        articleStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'My Articles',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: articleStream,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: MyArticleCard(
                            article: Article(
                          id: snapshot.data.docs[index].reference.id,
                          title: snapshot.data.docs[index].data()["title"],
                          author: snapshot.data.docs[index].data()["author"],
                          imageUrl:
                              snapshot.data.docs[index].data()["imageUrl"],
                              status: snapshot.data.docs[index].data()["status"],
                          dateCreated:
                              snapshot.data.docs[index].data()["dateCreated"],
                          context: snapshot.data.docs[index].data()["context"],
                        )),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      'No articles available.',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
          },
        ));
  }
}
