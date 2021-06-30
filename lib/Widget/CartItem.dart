import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  final String cartId;
  final String productId;
  final String name;
  final int quantity;
  final double price;

  const CartItemWidget(
      {required this.cartId,
      required this.productId,
      required this.name,
      required this.quantity,
      required this.price});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Dismissible(
          key: Key(cartId),
          direction: DismissDirection.endToStart,
          confirmDismiss: (_) {
            return showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                      title: Text('Alert'),
                      content: Text(
                          'Do you want to remove the item from the cart ?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop(true);
                            },
                            child: Text("Yes")),
                        TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop(false);
                            },
                            child: Text("No"))
                      ],
                    ));
          },
          onDismissed: (_) =>
              Provider.of<Cart>(context, listen: false).removeItem(productId),
          background: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Text(
                    "Delete",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Icon(
                  Icons.delete,
                  size: 30,
                  color: Colors.white,
                )
              ],
            ),
            alignment: Alignment.centerRight,
            color: Theme.of(context).errorColor,
            padding: const EdgeInsets.all(8.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FittedBox(
                      child: Text(
                    '\$${price}',
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
              title: Text(name),
              subtitle: Text('total: \$${quantity * price}'),
              trailing: Text('x${quantity}'),
            ),
          ),
        ));
  }
}
