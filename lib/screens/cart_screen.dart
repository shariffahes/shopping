import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Widget/CartItem.dart';
import '../providers/cart.dart';
import '../providers/orders.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = '/cart-screen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isOrdering = false;
  
  void submitOrder(Cart cart) async {
    setState(() {
      _isOrdering = true;
    });
    try {
      await Provider.of<Orders>(context, listen: false)
          .addOrder(cart.itemsInTheCart.values.toList(), cart.totalPrice);
      Navigator.of(context).pop();
      cart.clear();
    } catch (error) {
      setState(() {
        _isOrdering = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          error.toString(),
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartList = cart.itemsInTheCart.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(fontSize: 20),
                    ),
                    Spacer(),
                    Chip(
                      label: Text(
                        '\$${cart.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    _isOrdering
                        ? Container(padding: const EdgeInsets.all(10),child: CircularProgressIndicator())
                        : TextButton(
                            onPressed: cart.totalPrice <= 0 ? null :
                             () {
                              submitOrder(cart);
                            },
                            child: Text(
                              "Order Now",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            )),
                  ],
                )),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
                itemCount: cart.productCount(),
                itemBuilder: (context, index) {
                  return CartItemWidget(
                    productId: cart.itemsInTheCart.keys.toList()[index],
                    cartId: cartList[index].id,
                    name: cartList[index].name,
                    quantity: cartList[index].quantity,
                    price: cartList[index].priceOfProduct,
                  );
                }),
          ),
        ],
      ),
    );
  }
}
