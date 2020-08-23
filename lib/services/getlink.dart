import "package:http/http.dart";
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'dart:convert';

Future<String> getlink(BaseClient client) async {
//  Response response = await client.get("https://pastebin.com/NQNdrkGW");
//  var doc = parse(response.body);
//  List<Element> link = doc.getElementsByTagName("textarea");
//  return link[0].text;
  return "https://b29a45bde267.ngrok.io";
}