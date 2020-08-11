import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class More extends StatefulWidget {
  Map product = {};

  More({Key key, @required this.product}) : super(key: key);

  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  Widget build(BuildContext context) {
    String productName = widget.product.keys.toList()[0];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.heart),
                      onPressed: () {},
                    ),
                    Image.network(
                      widget.product[productName]["image"] ??
                          "https://bitsofco.de/content/images/2018/12/broken-1.png",
                      width: 400,
                      height: 400,
                    ),
                    SizedBox(height: 100),
                    Text(
                      productName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Row(
                        children: <Widget>[
                          Text(
                            widget.product[productName]["price"],
                            style: TextStyle(
                                color: Colors.amberAccent, fontSize: 20),
                          ),
                          SizedBox(width: 5),
                          Text(
                            widget.product[productName]["currency"],
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      Share.share(
                          "Check what have I found using this amazing app: ${widget.product[productName]["url"]}");
                    },
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.open_in_new),
                    onPressed: () {
                      goto(widget.product[productName]["url"]);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  goto(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Problem in opening url");
    }
  }
}
