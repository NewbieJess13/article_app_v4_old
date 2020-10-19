import 'dart:ui';

import 'package:article_app_v4/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ArticlePage extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;
  final String author;
  final String contexto;

  const ArticlePage(
      {Key key, this.imageUrl, this.title, this.author, this.contexto, this.id})
      : super(key: key);

  void _commentModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return CommentSection(
            id: id,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            brightness: Brightness.light,
            expandedHeight: 230,
            flexibleSpace: CachedNetworkImage(
              progressIndicatorBuilder: (context, imageUrl, downloadProgress) =>
                  Center(
                child:
                    CircularProgressIndicator(value: downloadProgress.progress),
              ),
              imageUrl: imageUrl,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        'by $author',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        contexto,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          _commentModalBottomSheet(context);
        },
        child: new Icon(Icons.comment_rounded),
      ),
    );
  }
}
