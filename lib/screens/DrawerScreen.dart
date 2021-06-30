import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/helpers/CustomRoute.dart';
import 'package:shopping/providers/auth.dart';
import 'package:shopping/screens/Order_Screen.dart';
import 'package:shopping/screens/user_products_screen.dart';

class DrawerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text('Navigator'),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
          title: Text('Shop Store'),
          leading: Icon(Icons.shop),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        Divider(),
        ListTile(
          title: Text('Order History'),
          leading: Icon(Icons.history),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            // Navigator.of(context)
            //     .pushReplacement(CustomeRoute(builder: (ctx) => OrderScreen()));
          },
        ),
        Divider(),
        ListTile(
          title: Text('Manage Your Products'),
          leading: Icon(Icons.store),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(UserProductScreen.routeName);
          },
        ),
        Divider(),
        ListTile(
          title: Text("Logout"),
          leading: Icon(Icons.logout),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/');
            Provider.of<Auth>(context, listen: false).logout();
          },
        )
      ],
    );
  }
}
