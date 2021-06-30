import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_details.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context);

    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetailsScreen.routeName, arguments: product.id);
      },
      child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: GridTile(
            header: Text(
              "\$${product.price}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  backgroundColor: Colors.black54,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            footer: GridTileBar(
              backgroundColor: Colors.black54,
              leading: Consumer<Auth>(
                builder: (ctx, auth, child) {
                  return IconButton(
                    onPressed: () async {
                      try {
                        await product.toggleFavorite(auth.token, auth.userId);
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            error.toString(),
                            textAlign: TextAlign.center,
                          ),
                          duration: Duration(seconds: 2),
                        ));
                      }
                    },
                    icon: child,
                  );
                },
                child: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).accentColor,
                ),
              ),
              title: Text(
                product.name,
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                onPressed: () {
                  cart.addItem(product.id, product.name, product.price);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Item added to the cart"),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () {
                        cart.undoItem(product.id);
                      },
                    ),
                  ));
                },
                icon: Icon(
                  Icons.add_shopping_cart_rounded,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                placeholder: AssetImage('assets/image/product-placeholder.png'),
                image: NetworkImage(product.imageURL),
                fit: BoxFit.cover,
              ),
            ),
          )),
    );
  }
}
