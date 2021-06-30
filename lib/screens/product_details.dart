import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/providers/product.dart';
import 'package:shopping/providers/Products_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const String routeName = "/product-details-page";

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context, listen: false);
    String productID = ModalRoute.of(context)!.settings.arguments as String;

    final Product currentProduct = productsProvider.productWith(id: productID);

    return Scaffold(
        // appBar: AppBar(
        //   title: Text(currentProduct.name),
        // ),
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(currentProduct.name),

            background: Hero(
              tag: currentProduct.id,
              child: Image.network(
                currentProduct.imageURL,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          // Container(
          //   height: 300,
          //   width: double.infinity,
          //   child: Hero(
          //     tag: currentProduct.id,
          //     child: Image.network(
          //       currentProduct.imageURL,
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          SizedBox(height: 10),
          Text(
            "Price: \$${currentProduct.price}",
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            width: double.infinity,
            child: Text(
              currentProduct.description,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          )
        ]))
      ],
    ));
  }
}
