import 'package:flutter/material.dart';
import 'dart:convert';

void main() => runApp(OrderApp());

class OrderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order App',
      home: OrderPage(),
    );
  }
}

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<Order> orders = [];
  List<Order> filteredOrders = [];

  final TextEditingController itemController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController currencyController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    String jsonString = '''
    [{"Item": "A1000","ItemName": "Iphone 15","Price": 1200,"Currency": "USD","Quantity":1},
    {"Item": "A1001","ItemName": "Iphone 16","Price": 1500,"Currency": "USD","Quantity":1}]
    ''';

    orders = (json.decode(jsonString) as List)
        .map((e) => Order.fromJson(e))
        .toList();

    filteredOrders = List.from(orders);
  }

  void addOrder() {
    final newOrder = Order(
      item: itemController.text,
      itemName: nameController.text,
      price: double.tryParse(priceController.text) ?? 0,
      currency: currencyController.text,
      quantity: int.tryParse(quantityController.text) ?? 1,
    );

    setState(() {
      orders.add(newOrder);
      filteredOrders = List.from(orders);
    });

    itemController.clear();
    nameController.clear();
    priceController.clear();
    currencyController.clear();
    quantityController.clear();
  }

  void searchOrder(String query) {
    setState(() {
      filteredOrders = orders
          .where((order) =>
          order.itemName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Widget buildOrderList() {
    return Expanded(
      child: ListView.builder(
        itemCount: filteredOrders.length,
        itemBuilder: (context, index) {
          final order = filteredOrders[index];
          return ListTile(
            title: Text('${order.itemName} (${order.item})'),
            subtitle:
            Text('${order.price} ${order.currency} - Qty: ${order.quantity}'),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Orders')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(labelText: 'Search ItemName'),
              onChanged: searchOrder,
            ),
            SizedBox(height: 10),
            buildOrderList(),
            Divider(),
            TextField(controller: itemController, decoration: InputDecoration(labelText: 'Item')),
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'ItemName')),
            TextField(controller: priceController, decoration: InputDecoration(labelText: 'Price')),
            TextField(controller: currencyController, decoration: InputDecoration(labelText: 'Currency')),
            TextField(controller: quantityController, decoration: InputDecoration(labelText: 'Quantity')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: addOrder, child: Text('Add Order')),
          ],
        ),
      ),
    );
  }
}

class Order {
  final String item;
  final String itemName;
  final double price;
  final String currency;
  final int quantity;

  Order({
    required this.item,
    required this.itemName,
    required this.price,
    required this.currency,
    required this.quantity,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      item: json['Item'],
      itemName: json['ItemName'],
      price: (json['Price'] as num).toDouble(),
      currency: json['Currency'],
      quantity: json['Quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Item': item,
      'ItemName': itemName,
      'Price': price,
      'Currency': currency,
      'Quantity': quantity,
    };
  }
}
