import 'package:educationdashboard/bloc/edu_event.dart';
import 'package:educationdashboard/models/GroupEdu.dart';
import 'package:educationdashboard/pages/home.dart';
import 'package:educationdashboard/pages/login_page.dart';
import 'package:educationdashboard/providers/simple_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'api/repository.dart';
import 'bloc/groupbloc.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => SimpleProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: TextTheme(
            // headline1: TextStyle(color: Colors.white),
            // headline2: TextStyle(color: Colors.white),
            // // bodyText1: TextStyle(color: Colors.white),
            //subtitle1: TextStyle(color: Colors.white)
            ),
        // primarySwatch: Colors.black54,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => Home(),
      },
    );
  }
}
