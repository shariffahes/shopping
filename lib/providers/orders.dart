import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shopping/models/http_Exception.dart';
import 'package:shopping/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> orderedProducts;
  final DateTime orderedDate;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.orderedProducts,
      required this.orderedDate});
}

class Orders with ChangeNotifier {
  final String? token;
  final String? _userId;
  List<OrderItem> _orders = [];

  Orders(this.token, this._userId, this._orders);

  List<OrderItem> get getOrders {
    return [..._orders];
  }


  Future<void> addOrder(List<CartItem> orderedItems, double total) async {
    final url = Uri.https('shoppers-3a656-default-rtdb.firebaseio.com',
        '/orders/$_userId.json', {'auth': token});
    final date = DateTime.now();

    try {
      final response = await http.post(url,
          body: json.encode({
            "amount": total,
            "date": date.toIso8601String(),
            "orderedProducts": orderedItems.map((element) {
              return {
                'id': element.id,
                'name': element.name,
                'price': element.priceOfProduct,
                'quantity': element.quantity,
              };
            }).toList()
          }));
      _orders.insert(
          0,
          OrderItem(
              id: json.decode(response.body)['name'],
              amount: total,
              orderedProducts: orderedItems,
              orderedDate: date));
      notifyListeners();
    } catch (error) {
      throw HttpException("Error connecting to the server");
    }
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.https('shoppers-3a656-default-rtdb.firebaseio.com',
        '/orders/$_userId.json', {'auth': token});

    final response = await http.get(url);
    
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<OrderItem> loadedOrders = [];
    if (extractedData == null) return;
    extractedData.forEach((orderID, orderInfo) {
      loadedOrders.insert(
          0,
          OrderItem(
              id: orderID,
              amount: orderInfo['amount'],
              orderedProducts: (orderInfo['orderedProducts'] as List<dynamic>)
                  .map((element) => CartItem(
                      id: element['id'],
                      name: element['name'],
                      quantity: element['quantity'],
                      priceOfProduct: element['price']))
                  .toList(),
              orderedDate: DateTime.parse(orderInfo['date'])));
    });
    _orders = loadedOrders;
    notifyListeners();
  }
}
