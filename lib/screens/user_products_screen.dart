import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Widget/user_products_item.dart';
import '../screens/DrawerScreen.dart';
import '../screens/edit_screen.dart';
import '../providers/Products_provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = "/user-product-screen";

  Future<void> _refresh(BuildContext ctx) async {
    await Provider.of<Products>(ctx, listen: false)
        .fetchAndSetProducts(filterByID: true);
  }

  @override
  Widget build(BuildContext context) {
    // final products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditScreen.routeName)
                    .then((value) {
                  if (value == 1) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Unable to connect to the server. Try again later"),
                      duration: Duration(seconds: 2),
                    ));
                  }
                });
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      drawer: Drawer(
        child: DrawerScreen(),
      ),
      body: FutureBuilder(
        future: _refresh(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () {
                      return _refresh(context);
                    },
                    child: Consumer<Products>(
                      builder: (ctx, products, _) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemBuilder: (_, index) {
                            return Column(children: [
                              UserProductItem(
                                  products.storeProducts[index].id,
                                  products.storeProducts[index].name,
                                  products.storeProducts[index].imageURL),
                              Divider()
                            ]);
                          },
                          itemCount: products.storeProducts.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
