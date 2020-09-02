import "dart:convert";
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:encrypt/encrypt.dart';

// import 'package:html/parser.dart';
// import 'package:html/dom.dart' as Dom;

import 'package:flutter/material.dart';

import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';

import 'package:product_scrapper/result.dart';
import 'package:product_scrapper/services/getlink.dart';
import 'package:product_scrapper/advanced.dart';

import 'main.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _productController = TextEditingController();
  TextEditingController _countryController = TextEditingController();

  SnackBar snackbar;
  Location location = Location();
  bool allowLocation = true;

  double _height = 80.0;
  double _width = 50.0;
  double _padding = 20.0;

  bool finished = true;
  String timestamp;
  String product;
  int randKey = 0;

  RaisedButton cacheButton = RaisedButton();

  @override
  Widget build(BuildContext context) {
    final countryExtension = Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _countryController,
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: "Enter country code, Eg. in, de, us",
          labelStyle: TextStyle(color: Colors.white38),
          prefixIcon: Icon(
            Icons.toys,
            color: Colors.blue,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (value) {},
      ),
    );

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("Scrapper"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.restore),
                onPressed: () {
                  setState(() {
                    finished = true;
                  });
                }),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => Advanced()));
              },
            )
          ],
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 100, left: 10, right: 10),
              child: TextField(
                controller: _productController,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Enter product to search",
                  labelStyle: TextStyle(color: Colors.blue),
                  prefixIcon: Icon(
                    Icons.toys,
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
            Container(
                padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                child: (finished)
                    ? RaisedButton(
                        child: Text("Search"),
                        onPressed: () async {
                          setState(() {
                            finished = false;
                          });
                          print("length: " + Advanced.lengthController.text);
                          if (Advanced.lengthController.text == "" ||
                              Advanced.lengthController.text == "0") {
                            Advanced.lengthController.text = "100";
                          }
                          product = _productController.text;
                          await preprocess(product,
                              int.parse(Advanced.lengthController.text));
                        },
                      )
                    : Text("Running...")),
            SizedBox(height: 30),
            Row(
              children: <Widget>[
                FaIcon(FontAwesomeIcons.solidHandPointRight),
                SizedBox(width: 10),
                Text("No.of products: No.of products to search in each E-store")
              ],
            ),
            Row(
              children: <Widget>[
                SizedBox(width: 30),
                FaIcon(FontAwesomeIcons.dotCircle, size: 20),
                SizedBox(width: 10),
                Text("Higher the number slower the results")
              ],
            ),
            SizedBox(height: 30),
            Row(
              children: <Widget>[
                FaIcon(FontAwesomeIcons.solidHandPointRight),
                SizedBox(width: 10),
                Text("Please don't close the app, let it run in background")
              ],
            ),
            Row(
              children: <Widget>[
                SizedBox(width: 30),
                FaIcon(FontAwesomeIcons.dotCircle, size: 20),
                SizedBox(width: 10),
                Text(
                    "Your cache data will be flushed after an hour of creation."),
              ],
            ),
            SizedBox(height: 30),
            Row(
              children: [
                SizedBox(width: 10),
                FaIcon(FontAwesomeIcons.file),
                SizedBox(width: 20),
                Text("Have cache file? "),
                SizedBox(width: 20),
                RaisedButton(
                  child: Text("Import"),
                  onPressed: () async {
                    String cache_path = await FilePicker.getFilePath(
                        type: FileType.custom,
                        allowedExtensions: ["cache", "json"],
                        onFileLoading: (value) {
                          print(value);
                        });
                    File file = File(cache_path);
//                    file.readAsBytes().then((final value) => print(value));
                    Stream<List<int>> inputStream = file.openRead();
                    inputStream
                        .transform(utf8.decoder)
                        .transform(LineSplitter())
                        .listen((String line) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ResultPage(products: jsonDecode(line))));
                    }, onDone: () {
                      print("closed");
                    }, onError: (e) {
                      print(e.toString());
                    });
                  },
                )
              ],
            ),
            Row(
              children: <Widget>[
                SizedBox(width: 30),
                (finished) ? Container() : cacheButton,
                Spacer(),
              ],
            ),
            (finished)
                ? Container()
                : Row(
                    children: <Widget>[
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.info),
                        onPressed: () {
                          AwesomeDialog(
                              context: context,
                              dialogType: DialogType.INFO,
                              animType: AnimType.SCALE,
                              title: "Cache listener",
                              desc:
                                  "This will let the app to listen to the server for each ten seconds for any change in your product request. May CONSUME more battery life",
                              btnOkOnPress: () {})
                            ..show();
                        },
                      ),
                      Text("Cache listener: "),
                      Spacer(),
                      LiteRollingSwitch(
                        value: false,
                        textOn: "Listen",
                        textOff: "Off",
                        colorOn: Colors.greenAccent[700],
                        colorOff: Colors.redAccent[700],
                        iconOn: Icons.done_all,
                        iconOff: Icons.remove_circle_outline,
                        textSize: 16.0,
                        onChanged: (bool state) {
                          if (state) {
                            Fluttertoast.showToast(
                                msg: "Listening to cache population",
                                backgroundColor: Colors.white,
                                textColor: Colors.black);
                            cache_listener(timestamp, product);
                          }
                        },
                      ),
                      Spacer(),
                    ],
                  ),
          ],
        ));
  }

  Future<bool> check_permission() async {
    if (await Permission.locationWhenInUse.serviceStatus.isDisabled) {
      Permission.locationWhenInUse.request();
    } else if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
      return true;
    } else {
      return false;
    }
  }

  Future<List> getLocation() async {
    Position position = await Geolocator().getCurrentPosition();
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    final country = placemark[0].country;
    final countryCode = placemark[0].isoCountryCode;

    return [country, countryCode.toLowerCase()];
  }

  preprocess(String productName, int length) async {
    bool locationPermission = await check_permission();
    setState(() {
      allowLocation = locationPermission;
    });

    String country;
    String countryCode;
    if (locationPermission) {
      List locationResult = await getLocation();
      country = locationResult[0];
      countryCode = locationResult[1];
    }
    scrap(productName, countryCode, length, false);
  }

  scrap(String product, String countryCode, int length, bool override) async {
    var client = Client();

    String link = await getlink(client);
    timestamp = DateTime.now().toString();
    Map advanced = {
      "sites": Advanced.sites,
      "email": Advanced.emailController.text,
    };
    final options = jsonEncode(advanced);
    print("$link?product=$product&country=$countryCode&length=$length&timestamp=$timestamp&override=${override.toString()}&options=$options");

    Response res = await client.get(
        "$link?product=$product&country=$countryCode&length=$length&timestamp=$timestamp&override=${override.toString()}&options=$options");
    final data = jsonDecode(res.body);

    if (data == 0) {
      setState(() {
        Fluttertoast.showToast(
            msg: "Request sent!",
            textColor: Colors.black,
            backgroundColor: Colors.white);
        cacheButton = RaisedButton(
          child: Text("Get cached data"),
          onPressed: () {
            get_cache(timestamp, product);
          },
        );
      });
    } else if (data["cache"]) {
      ControlPage.products = data;
      AwesomeDialog(
          context: context,
          dialogType: DialogType.WARNING,
          animType: AnimType.TOPSLIDE,
          title: "Cache Warning",
          desc:
              "Do you want to continue with the cached data  or want to scrap fresh data",
          btnOkText: "Continue",
          btnCancelText: "Get fresh data",
          btnOkOnPress: () {
            setState(() {
              finished = true;
            });
            goToResults();
          },
          btnCancelOnPress: () {
            scrap(product, countryCode, length, true);
          })
        ..show();
      Fluttertoast.showToast(
          msg: ControlPage.products.keys.length.toString() + " results",
          backgroundColor: Colors.white,
          textColor: Colors.black);
    } else {
      setState(() {
        finished = true;
      });
      goToResults();
    }
  }

  goToResults() {
    ControlPage.products.remove("cache");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResultPage(products: ControlPage.products)));
  }

  get_cache(String timestamp, String product) async {
    var client = Client();
    String link = await getlink(client);
    Response res = await client.get(
        "$link/cache?timestamp=$timestamp&product=$product&override=$randKey");
    final data = jsonDecode(res.body);
    print(data);

    if (data != -1) {
      ControlPage.products = data;
      setState(() {
        finished = true;
      });
      print(ControlPage.products);
      goToResults();
    } else {
      Fluttertoast.showToast(
          msg: "Your cache is not populated yet!",
          textColor: Colors.black,
          backgroundColor: Colors.white);
    }
  }

  cache_listener(String timestamp, String product) async {
    var client = Client();
    String link = await getlink(client);
    Response res =
        await client.get("$link/cache?timestamp=$timestamp&product=$product");
    final data = jsonDecode(res.body);
    if (data == -1) {
      await Future.delayed(Duration(seconds: 10))
          .then((value) => cache_listener(timestamp, product));
    } else {
      ControlPage.products = data;
      setState(() {
        finished = true;
      });
      goToResults();
    }
  }

  bool isNumeric(String str) {
    try {
      var value = double.parse(str);
    } on FormatException {
      return false;
    } finally {
      return true;
    }
  }
}
