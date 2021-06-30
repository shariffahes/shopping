import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Widget/order_item.dart';
import '../providers/orders.dart';
import '../screens/DrawerScreen.dart';

class OrderScreen extends StatelessWidget {
  static const String routeName = '/orders-history';
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Order'),
        ),
        drawer: Drawer(
          child: DrawerScreen(),
        ),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (_, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapShot.error == null) {
                return Consumer<Orders>(builder: (_, orderData, child) {
                  return ListView.builder(
                    itemBuilder: (_, index) => OrderItemWidget(
                      orderData.getOrders[index],
                    ),
                    itemCount: orderData.getOrders.length,
                  );
                });
              } else {
                return Center(
                  child: Text("Error 404"),
                );
              }
            }
          },
        ));
  }
}
