import "package:flutter/material.dart";
import 'package:product_scrapper/search.dart';

class Advanced extends StatefulWidget {
  static TextEditingController lengthController = TextEditingController();
  static TextEditingController emailController = TextEditingController();
  static Map<String, bool> sites = {
    "Amazon": true,
    "Flipkart": false,
    "ebay": false,
  };

  @override
  _AdvancedState createState() => _AdvancedState();
}

class _AdvancedState extends State<Advanced> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Advanced"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: Advanced.lengthController,
              decoration: InputDecoration(labelText: "No.of products"),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: TextField(
              controller: Advanced.emailController,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "We will mail you once it is completed",
                labelStyle: TextStyle(color: Colors.blue),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.blue,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text("Sites to scrap", style: TextStyle(color: Colors.amberAccent),),
          Expanded(
            child: ListView(
              children: Advanced.sites.keys.map((String key) {
                return new CheckboxListTile(
                  title: new Text(key),
                  value: Advanced.sites[key],
                  activeColor: Colors.blue,
                  checkColor: Colors.white,
                  onChanged: (bool value) {
                    setState(() {
                      Advanced.sites[key] = value;
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
