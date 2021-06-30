import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/Widget/splash.dart';
import '../providers/auth.dart';
import '../providers/orders.dart';
import '../screens/Order_Screen.dart';
import '../screens/auth_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/edit_screen.dart';
import '../screens/user_products_screen.dart';
import '../providers/cart.dart';
import './providers/Products_provider.dart';
import './screens/product_details.dart';
import './screens/store_screen.dart';

void main() {
  runApp(Main_Home());
}

// ignore: camel_case_types
class Main_Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
            create: (ctx) => Products("", [], ""),
            update: (ctx, auth, previosProducts) => Products(
                  auth.token,
                  previosProducts == null ? [] : previosProducts.storeProducts,
                  auth.userId,
                )),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => Orders("", "", []),
            update: (ctx, auth, previousOrders) => Orders(
                  auth.token,
                  auth.userId,
                  previousOrders == null ? [] : previousOrders.getOrders,
                )),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Store',
          theme: ThemeData(
            primaryColor: Colors.purple,
            accentColor: Colors.amber,
            fontFamily: "Lato",
          ),
          home: auth.isAuthenticated
              ? MyStoreScreen()
              : FutureBuilder(
                  future: auth.autoLoginAttempt(),
                  builder: (ctx, authResult) =>
                      authResult.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailsScreen.routeName: (context) => ProductDetailsScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrderScreen.routeName: (context) => OrderScreen(),
            UserProductScreen.routeName: (context) => UserProductScreen(),
            EditScreen.routeName: (context) => EditScreen(),
          },
        ),
      ),
    );
  }
}
