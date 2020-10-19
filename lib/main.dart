import 'package:article_app_v4/screens/screens.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:article_app_v4/root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Article App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "/",
      routes: {
        '/': (context) => Root(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUp(),
        '/articlelist': (context) => ArticleLists(),
        '/articlepage': (context) => ArticlePage(),
        '/userprofile': (context) => UserProfile(),
        '/editarticle': (context) => EditArticle(),
        '/writearticle': (context) => WriteArticle(),
        '/myarticle': (context) => MyArticles(),
      },

    );
  }
}
