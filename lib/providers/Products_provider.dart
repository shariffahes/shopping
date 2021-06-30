import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping/models/http_Exception.dart';
import 'product.dart';
import 'dart:convert';

class Products with ChangeNotifier {
  final String? _token;
  final String? _userID;
  List<Product> _storeProducts = [];

  Products(this._token, this._storeProducts, this._userID);

  List<Product> get storeProducts {
    return [..._storeProducts];
  }

  List<Product> get favProducts {
    return _storeProducts.where((element) => element.isFavorite).toList();
  }

  Product productWith({required String id}) {
    return _storeProducts.firstWhere((product) => product.id == id);
  }

  Future<void> removeProduct(String id) {
    final url = Uri.https('shoppers-3a656-default-rtdb.firebaseio.com',
        '/products/$id.json', {'auth': _token});
    int productIndex = _storeProducts.indexWhere((element) => element.id == id);
    var _tempHoldProduct = _storeProducts[productIndex];
    _storeProducts.removeAt(productIndex);
    notifyListeners();
    return http.delete(url).then((response) {
      if (response.statusCode >= 400)
        throw HttpException("Something went wrong. Unable to delete the item.");
      _tempHoldProduct.dispose();
    }).catchError((error) {
      _storeProducts.insert(productIndex, _tempHoldProduct);
      notifyListeners();
      throw error;
    });
  }

  Future<void> addProduct(Product product) async {
    int index =
        _storeProducts.indexWhere((element) => element.id == product.id);
    final url = Uri.https('shoppers-3a656-default-rtdb.firebaseio.com',
        '/products.json', {'auth': _token});
    if (index == -1) {
      try {
        final response = await http.post(url,
            body: json.encode({
              "name": product.name,
              "description": product.description,
              "price": product.price,
              "imageUrl": product.imageURL,
              "storeID": _userID,
            }));

        final dummy = Product(
            id: json.decode(response.body)['name'],
            name: product.name,
            description: product.description,
            price: product.price,
            imageURL: product.imageURL);
        _storeProducts.add(dummy);
        notifyListeners();
      } catch (error) {
        throw error;
      }
    } else {
      bool prevValue = _storeProducts[index].isFavorite;
      _storeProducts[index] = product;
      _storeProducts[index].isFavorite = prevValue;

      final url = Uri.https('shoppers-3a656-default-rtdb.firebaseio.com',
          '/products/${product.id}.json', {'auth': _token});

      await http.patch(url,
          body: json.encode({
            'name': product.name,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageURL,
          }));
      notifyListeners();
    }
  }

  Future<void> fetchAndSetProducts({bool filterByID = false}) async {
    var url;
    if (!filterByID)
      url = Uri.https('shoppers-3a656-default-rtdb.firebaseio.com',
          '/products.json', {'auth': _token});
    else
      url = Uri.https(
          'shoppers-3a656-default-rtdb.firebaseio.com', '/products.json', {
        'auth': _token,
        "orderBy": json.encode("storeID"),
        "equalTo": json.encode(_userID)
      });

    try {
      final response = await http.get(url);
      final extractedProductsData =
          json.decode(response.body) as Map<String, dynamic>;
      if (extractedProductsData == null) return;
      final List<Product> loadedProducts = [];

      url = Uri.https('shoppers-3a656-default-rtdb.firebaseio.com',
          '/userFavorites/$_userID.json', {'auth': _token});
      final favResponse = await http.get(url);
      final favData = json.decode(favResponse.body);
      extractedProductsData.forEach((prodID, productInfo) {
        loadedProducts.add(Product(
          id: prodID,
          name: productInfo['name'],
          description: productInfo['description'],
          price: productInfo['price'],
          imageURL: productInfo['imageUrl'],
          isFavorite: favData == null ? false : (favData[prodID] ?? false),
        ));
      });
      _storeProducts = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
