import 'package:article_app_v4/helper/constants.dart';
import 'package:article_app_v4/helper/helper_prefs.dart';
import 'package:article_app_v4/models/article.dart';
import 'package:article_app_v4/screens/screens.dart';
import 'package:article_app_v4/services/firebase_auth.dart';
import 'package:article_app_v4/services/firebase_database.dart';
import 'package:article_app_v4/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ArticleLists extends StatefulWidget {
  @override
  _ArticleListsState createState() => _ArticleListsState();
}

class _ArticleListsState extends State<ArticleLists> {
  Stream articleStream;
  String userImage;
  String userName;
  getUserInfo() async {
    Constants.fullName = await HelperPrefs.getFullNameInPrefs();
    Constants.imageUrl = await HelperPrefs.getUserImageInPrefs();
    Constants.userId = await HelperPrefs.getUserIdInPrefs();
    Constants.email = await HelperPrefs.getUserEmailInPrefs();

    await DatabaseMethod().getUserNamebyEmail(Constants.email).then((val) {
      userImage = val.docs[0].data()['imageUrl'];
      userName = val.docs[0].data()['firstname'] +
          ' ' +
          val.docs[0].data()['lastname'];
      print(userImage + "   " + userName);
    });
  }

  @override
  void initState() {
    getUserInfo();

    DatabaseMethod().getPublishedArticles().then((value) {
      setState(() {
        articleStream = value;
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              curve: Curves.fastLinearToSlowEaseIn,
              duration: Duration(milliseconds: 10000),
              child: Center(
                child: Column(
                  children: [
                    ClipOval(
                        child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                      imageUrl: 
                      //userImage,
                              'https://apexgloballearning.com/wp-content/themes/apex/images/domain/noimage.jpg',
                      progressIndicatorBuilder: (
                        context,
                        imageUrl,
                        downloadProgress,
                      ) =>
                          Center(
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress)),
                    )
                        //                        ??
                      
                        ),
                    const SizedBox(height: 5),
                    Text(
                        userName,
                      // ??
                    //  'weh',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.person_outline),
              title: Text(
                'My Profile',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/userprofile');
              },
            ),
            ListTile(
              leading: Icon(Icons.article),
              title: Text(
                'My Articles',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/myarticle');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                    fontWeight: FontWeight.w800, color: Colors.red[400]),
              ),
              onTap: () {
                AuthMethod().signOutGoogle();
                HelperPrefs.clearSharedPrefs();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'ARTICLES',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            Icon(
              Icons.book,
              color: Colors.black54,
            ),
            Spacer(),
            Text(
              Constants.fullName,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
      body: Container(
        height: height,
        width: width,
        child: StreamBuilder<QuerySnapshot>(
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
                        child: ArticleCard(
                            article: Article(
                          id: snapshot.data.docs[index].reference.id,
                          title: snapshot.data.docs[index].data()["title"],
                          author: snapshot.data.docs[index].data()["author"],
                          imageUrl:
                              snapshot.data.docs[index].data()["imageUrl"],
                          dateCreated:
                              snapshot.data.docs[index].data()["dateCreated"],
                          context: snapshot.data.docs[index].data()["context"],
                        )),
                      );
                    },
                  )
                : Container(
                    child: Center(
                      child: Text(
                        'No articles available.',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/writearticle'),
        child: Icon(Icons.create),
      ),
    );
  }
}
