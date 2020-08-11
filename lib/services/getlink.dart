import "package:http/http.dart";
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'dart:convert';

Future<String> getlink(BaseClient client) async {
//  Response response = await client.get("https://pastebin.com/NQNdrkGW");
//  var doc = parse(response.body);
//  List<Element> link = doc.getElementsByTagName("textarea");
//  return link[0].text;
  return "https://14f5e4f55d05.ngrok.io";
}