import 'package:flutter/material.dart';

import 'package:product_scrapper/dependencies.dart';
import 'package:product_scrapper/result.dart';
import "package:product_scrapper/search.dart";

import 'more.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ControlPage());
}

class ControlPage extends StatefulWidget {
  static Map products = {
    "product": {
      "price": "dummy price",
      "currency": "",
      "image": "dummy image",
    }
  };
  static Map product = {};

  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Product Scrapper",
      darkTheme: ThemeData.dark(),
      home: HomeController(),
      routes: <String, WidgetBuilder>{
        "/results": (BuildContext context) =>
            ResultPage(products: ControlPage.products),
        "/more": (BuildContext context) => More(product: ControlPage.product),
        "/home": (BuildContext context) => HomeController()
      },
    );
  }
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Search();
  }
}
