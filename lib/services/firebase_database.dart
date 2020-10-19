import 'package:article_app_v4/helper/helper_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseMethod {
  var _storage = FirebaseStorage.instance;

  Future saveUserInfo(userMap) async {
    return await FirebaseFirestore.instance.collection("users").add(userMap);
  }

  Future<bool> deleteArticle(docId) async {
    await FirebaseFirestore.instance
        .runTransaction((Transaction myTransaction) async {
      myTransaction.delete(docId);
      print('success');
    });
    return true;
  }

  Future<bool> updateArticle(articleMap, docId) async {
    try {
      await FirebaseFirestore.instance
          .runTransaction((Transaction myTransaction) async {
        myTransaction.update(docId, articleMap);
        print('success');
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateUserInfo(userMap, docId) async {
    try {
      await FirebaseFirestore.instance
          .runTransaction((Transaction myTransaction) async {
        myTransaction.update(docId, userMap);
        print('success');
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  getUserNamebyEmail(String email) async {
    try {
      QuerySnapshot response = await FirebaseFirestore.instance
          .collection('users')
          .where("email", isEqualTo: email)
          .get();

      // await HelperPrefs.saveFullNameInPrefs(
      //     response.docs[0].data()['firstname'] +
      //         ' ' +
      //         response.docs[0].data()['lastname']);
      // await HelperPrefs.saveUserImageInPrefs(
      //     response.docs[0].data()['imageUrl']);
      // await HelperPrefs.saveUserEmailInPrefs(email);
      return response;
    } catch (e) {
      print(e.message);
      return null;
    }
  }

  Future saveArticle(articleMap) async {
    try {
      CollectionReference article =
          FirebaseFirestore.instance.collection("articles");
      await article.add(articleMap);
      return article;
    } catch (e) {
      print(e);
    }
  }

  Future addComment(id, commentMap) async {
    try {
      CollectionReference article = FirebaseFirestore.instance
          .collection("articles")
          .doc(id)
          .collection('comments');
      await article.add(commentMap);
      return article;
    } catch (e) {
      print(e);
    }
  }

  Future<String> uploadImage(String imageName, file) async {
    try {
      var snapshot = await _storage
          .ref()
          .child('ImageFolder/$imageName')
          .putFile(file)
          .onComplete;
      var downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<String> uploadUserImage(String imageName, file) async {
    try {
      var snapshot = await _storage
          .ref()
          .child('UserImageFolder/$imageName')
          .putFile(file)
          .onComplete;
      var downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print(e.message);
      return null;
    }
  }

  getPublishedArticles() async {
    try {
      return FirebaseFirestore.instance
          .collection("articles")
          .orderBy('dateCreated', descending: true)
          .get()
          .asStream();
    } catch (e) {
      print(e);
    }
  }

  getArticleComments(id) async {
    try {
      return FirebaseFirestore.instance
          .collection("articles")
          .doc(id)
          .collection('comments')
          .orderBy('dateTime', descending: true)
          .get()
          .asStream();
    } catch (e) {
      print(e);
    }
  }

  getArticlesofUser(String userId) async {
    try {
      return FirebaseFirestore.instance
          .collection("articles")
          .where("userId", isEqualTo: userId)
          .orderBy('dateCreated', descending: true)
          .get()
          .asStream();
    } catch (e) {
      print(e);
    }
  }
}
