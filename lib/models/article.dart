import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  final String title;
  final String author;
  final String context;
  final int dateCreated;
  final String status;
  final String imageUrl;
  final String id;
  final String userId;

  Article({
    this.userId,
    this.id,
    this.title,
    this.author,
    this.context,
    this.dateCreated,
    this.status,
    this.imageUrl,
  });
}
