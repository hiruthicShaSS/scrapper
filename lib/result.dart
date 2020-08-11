import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:product_scrapper/more.dart";
import 'package:auto_size_text/auto_size_text.dart';

import 'advanced.dart';
import 'main.dart';

class ResultPage extends StatefulWidget {
  Map products;

  ResultPage({Key key, @required this.products}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    List productsList = [];
    widget.products.forEach((key, value) => productsList.add(key));
    Color cardColor = Colors.grey;

    buildProducts(index) {
      String source = widget.products[productsList[index]]["source"];

      if (source == "Amazon")
        cardColor = Colors.blue[300];
      else if (source == "Flipkart")
        cardColor = Colors.blueAccent[700];
      else if (source == "ebay") cardColor = Colors.orange;

      return ListTile(
        title: AutoSizeText(
          productsList[index],
          maxLines: 3,
          maxFontSize: 18,
        ),
        leading: Image.network(
          getImage(productsList, index),
          height: 64,
          width: 64,
        ),
        onTap: () async {
          ControlPage.product = {
            productsList[index]: widget.products[productsList[index]]
          };
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => More(product: ControlPage.product)));
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Results"),
        actions: [
          Column(
            children: [
              Row(
                children: [
                  FaIcon(FontAwesomeIcons.squareFull,
                      color: Colors.blue[300], size: 15),
                  Text(" Amazon", style: TextStyle(fontSize: 15)),
                ],
              ),
              SizedBox(width: 10),
              Row(
                children: [
                  FaIcon(FontAwesomeIcons.squareFull,
                      color: Colors.blueAccent[700], size: 15),
                  Text("  Flipkart", style: TextStyle(fontSize: 15)),
                ],
              ),
              SizedBox(width: 10),
              Row(
                children: [
                  FaIcon(FontAwesomeIcons.squareFull,
                      color: Colors.orange, size: 15),
                  Text("       ebay", style: TextStyle(fontSize: 15)),
                ],
              ),
              SizedBox(width: 20),
            ],
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemCount: productsList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
              child: Card(
                color: cardColor,
                child: buildProducts(index),
              ),
            );
          },
        ),
      ),
    );
  }

  String getImage(List productsList, int index) {
    if (widget.products[productsList[index]]["image"] == null)
      return "https://bitsofco.de/content/images/2018/12/broken-1.png";
    try {
      return widget.products[productsList[index]]["image"];
    } catch (e) {
      return "https://bitsofco.de/content/images/2018/12/broken-1.png";
    }
  }
}
