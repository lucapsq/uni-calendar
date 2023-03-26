import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Image> getMeme() async {
  final uri = Uri.parse('https://meme-api.com/gimme');

  http.Response response = await http.get(uri);

  Image memeImage = Image.network(jsonDecode(response.body)['url']);

  return memeImage;
}
