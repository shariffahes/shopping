import 'dart:math';

import 'package:flutter/material.dart';
import '../providers/orders.dart';
import 'package:intl/intl.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem orderInfo;
  OrderItemWidget(this.orderInfo);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  var _showDetails = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
              title: Text(
                  'Order Price: \$${widget.orderInfo.amount.toStringAsFixed(2)}'),
              subtitle: Text(DateFormat('dd/MM/yyyy - ')
                  .add_jm()
                  .format(widget.orderInfo.orderedDate)),
              trailing: IconButton(
                icon:
                    Icon(_showDetails ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _showDetails = !_showDetails;
                  });
                },
              )),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: _showDetails
                ? min(widget.orderInfo.orderedProducts.length * 20 + 60, 190)
                : 0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: widget.orderInfo.orderedProducts
                    .map((productItem) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                productItem.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  '${productItem.quantity} x \$${productItem.priceOfProduct}',
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
