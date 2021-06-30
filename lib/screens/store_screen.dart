import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/providers/Products_provider.dart';
import '../Widget/badge.dart';
import '../providers/cart.dart';
import '../screens/DrawerScreen.dart';
import '../screens/cart_screen.dart';
import '../Widget/product_grid_view.dart';

enum ViewOptions {
  Favorite,
  All,
}

class MyStoreScreen extends StatefulWidget {
  @override
  _MyStoreScreenState createState() => _MyStoreScreenState();
}

class _MyStoreScreenState extends State<MyStoreScreen> {
  var _showFavOnly = false;
  var _isLoading = true;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      Provider.of<Products>(context, listen: false)
          .fetchAndSetProducts()
          .catchError((error) {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text(
                  "Error",
                  textAlign: TextAlign.center,
                ),
                content: Text(
                    "Unable to connect to the server. Check your internet connection and try again later"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Dismiss",
                        textAlign: TextAlign.center,
                      ))
                ],
              );
            });
      }).then((_) => setState(() {
                _isLoading = false;
              }));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Store"),
          actions: [
            Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                child: ch,
                value: cart.productCount().toString(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_basket),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            ),
            PopupMenuButton(
                onSelected: (value) {
                  setState(() {
                    switch (value) {
                      case ViewOptions.Favorite:
                        _showFavOnly = true;
                        break;
                      case ViewOptions.All:
                        _showFavOnly = false;
                        break;
                    }
                  });
                },
                icon: Icon(Icons.more_vert),
                itemBuilder: (_) => [
                      PopupMenuItem(
                        child: Text("Show Only Favorite"),
                        value: ViewOptions.Favorite,
                      ),
                      PopupMenuItem(
                        child: Text("Show all"),
                        value: ViewOptions.All,
                      )
                    ])
          ],
        ),
        drawer: Drawer(child: DrawerScreen()),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ProductsGridView(_showFavOnly));
  }
}
