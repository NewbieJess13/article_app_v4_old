import 'package:article_app_v4/helper/helper_prefs.dart';
import 'package:article_app_v4/screens/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          // User user = snapshot.data;
          if (snapshot.hasData) {
            print('user uid ${snapshot.data.uid}');
            HelperPrefs.saveUserIdInPrefs('${snapshot.data.uid}');
            return ArticleLists();
          }
          return LoginPage();
        } else {
          return Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        }
      },
    );
  }
}
