import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/Products_provider.dart';
import './Product_Item.dart';

class ProductsGridView extends StatelessWidget {
  final bool _showFavOnly;
  ProductsGridView(this._showFavOnly);

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);

    final storeProducts = _showFavOnly
        ? productsProvider.favProducts
        : productsProvider.storeProducts;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        childAspectRatio: 3 / 3,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
      ),
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: storeProducts[index],
          child: ProductItem(),
        );
      },
      itemCount: storeProducts.length,
    );
  }
}
