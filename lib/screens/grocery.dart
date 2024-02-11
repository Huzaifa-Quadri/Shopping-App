import 'package:flutter/material.dart';
import 'package:shopping_app/data/dummy_items.dart';

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Your Groceries",
            style: TextStyle(color: Colors.white),
          ),
        ),
        );
  }
}
