import 'package:article_app_v4/helper/constants.dart';
import 'package:article_app_v4/services/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class CommentSection extends StatefulWidget {
  final String id;

  const CommentSection({Key key, this.id}) : super(key: key);
  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  TextEditingController commentController = TextEditingController();
  DocumentSnapshot articleDoc;
  String userImage;
  String userName;
  @override
  void initState() {
    DatabaseMethod().getUserNamebyEmail(Constants.email).then((val) {
      
      userImage = val.docs[0].data()['imageUrl'];
      userName = val.docs[0].data()['firstname'] +
          ' ' +
          val.docs[0].data()['lastname'];
    });
    getArticleComments();
    super.initState();
  }

  getArticleComments() async {
    FirebaseFirestore.instance
        .collection('articles')
        .doc(widget.id)
        .get()
        .then((value) {
      setState(() {
        articleDoc = value;
      });
    });
  }

  Widget commentTile({String comment, Timestamp timeDate}) {
    var jiffyNow = Jiffy(timeDate.toDate(), "yyyy MM dd").fromNow();

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: ListTile(
        tileColor: Colors.grey[200],
        isThreeLine: false,
        leading: CachedNetworkImage(
          fit: BoxFit.cover,
          width: 40,
          height: 40,
          imageUrl: userImage,
          progressIndicatorBuilder: (
            context,
            imageUrl,
            downloadProgress,
          ) =>
              Center(
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress)),
        ),
        title: Row(
          children: [
            Text(
              userName,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            Spacer(),
            Text(
              jiffyNow,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            )
          ],
        ),
        subtitle: Text(
          comment,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          'Comments',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        Row(children: [
          Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    errorStyle:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    hintText: 'Type your comment here...',
                  ),
                  controller: commentController,
                ),
              )),
          Expanded(
              flex: 2,
              child: IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    Map<String, dynamic> commentsMap = {
                      "comment": commentController.text,
                      "userId": Constants.userId,
                      "dateTime": DateTime.now(),
                    };
                    DatabaseMethod()
                        .addComment(widget.id, commentsMap)
                        .then((value) {
                      commentController.clear();
                    });
                  }))
        ]),
        const SizedBox(height: 10),
        Expanded(
          child: Container(
            child: articleDoc == null
                ? Center(child: CircularProgressIndicator())
                : StreamBuilder(
                    stream: articleDoc.reference
                        .collection('comments')
                        .orderBy('dateTime', descending: true)
                        .snapshots(),
                    builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                      return snapshot.hasData
                          ? ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                return commentTile(
                                  comment: snapshot.data.docs[index]
                                      .data()["comment"],
                                  timeDate: snapshot.data.docs[index]
                                      .data()["dateTime"],
                                );
                              })
                          : Center(child: CircularProgressIndicator());
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

// class CommentBox extends StatelessWidget {
//   final String userId;

//   final String comment;
//   final Timestamp commentTime;

//   const CommentBox({
//     Key key,
//     this.comment,
//     this.commentTime,
//     this.userId,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {

//   }
// }
