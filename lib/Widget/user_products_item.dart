import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/providers/Products_provider.dart';
import 'package:shopping/screens/edit_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageURL;

  UserProductItem(this.id, this.title, this.imageURL);

  @override
  Widget build(BuildContext context) {
    final _scaffoldMessenger = ScaffoldMessenger.of(context);
    final products = Provider.of<Products>(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageURL),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditScreen.routeName, arguments: id);
                },
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                )),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: Text(
                            "Delete Item",
                            textAlign: TextAlign.center,
                          ),
                          content: Text(
                              "This will delete the product from the main store. Are you sure you want to proceed ?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  products
                                      .removeProduct(id)
                                      .catchError((error) {
                                    _scaffoldMessenger.showSnackBar(
                                        SnackBar(
                                            content: Text(error.toString())));
                                  });
                                  Navigator.of(ctx).pop();
                                },
                                child: Text("Yes")),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: Text("No"))
                          ],
                        );
                      });
                },
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                )),
          ],
        ),
      ),
    );
  }
}
