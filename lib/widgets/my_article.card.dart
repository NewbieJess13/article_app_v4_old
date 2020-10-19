import 'package:article_app_v4/models/article.dart';
import 'package:article_app_v4/screens/screens.dart';
import 'package:article_app_v4/services/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyArticleCard extends StatelessWidget {
  final Article article;

  const MyArticleCard({Key key, this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final dateWritten = DateFormat("MMM dd yyyy, hh:mm aa")
        .format(DateTime.fromMicrosecondsSinceEpoch(article.dateCreated));
    return Container(
      child: Card(
        color: Colors.grey[200],
        elevation: 10,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: article.imageUrl,
                    progressIndicatorBuilder:
                        (context, imageUrl, downloadProgress) => Align(
                      alignment: Alignment.topCenter,
                      child: LinearProgressIndicator(
                          value: downloadProgress.progress),
                    ),
                    height: 180,
                    width: width,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                        color: article.status == "1"
                            ? Colors.green[300]
                            : Colors.grey[300]),
                    child: Text(
                      article.status == "1" ? 'Published' : 'In Drafts',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'By ${article.author}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '·',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        dateWritten,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  const SizedBox(height: 10),
                  Text(
                    article.context,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditArticle(
                            article: article,
                          ),
                        ),
                      );
                    //  Navigator.pushNamed(context, '/editarticle',arguments: );
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[500],
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                        height: 40,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        )),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      DatabaseMethod().deleteArticle(article.id).then((val) {
                        Scaffold.of(context).showSnackBar(
                          new SnackBar(
                              content: Text(
                            'Article deleted.',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          )),
                        );
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red[300],
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        height: 40,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        )),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
