import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shopping/models/http_Exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageURL;
  bool isFavorite;

  Product(
      {required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.imageURL,
      this.isFavorite = false});

  Future<void> toggleFavorite(String? token, String? userId) async {
    isFavorite = !isFavorite;
    final url = Uri.https('shoppers-3a656-default-rtdb.firebaseio.com',
        '/userFavorites/$userId/$id.json', {'auth': token});
    notifyListeners();
    try {
      final response = await http.put(url,
          body: json.encode(
            isFavorite,
          ));

      if (response.statusCode >= 400)
        throw HttpException("Error occured connecting to the server");
    } catch (error) {
      isFavorite = !isFavorite;
      notifyListeners();
      throw error;
    }
  }
}
