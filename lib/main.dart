import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zapit_frontend_task/constants.dart';
import 'package:zapit_frontend_task/src/views/home/home_view.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(AppConstants.coinsListBox);
  await Hive.openBox(AppConstants.pricesListBox);
  runApp(
    const ZapitApp(),
  );
}

class ZapitApp extends StatelessWidget {
  const ZapitApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zapit Frontend Task',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      debugShowCheckedModeBanner: false,
      // initialRoute: RouteGenerator.homePage,
      // onGenerateRoute: RouteGenerator.generateRoute,
      home: const HomeView(),
    );
  }
}
