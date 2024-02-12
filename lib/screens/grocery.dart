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
        body: ListView.builder(
          itemCount: groceryItems.length,
          itemBuilder: (ctx, index) => ListTile(
            title: Text(groceryItems[index].name),
            leading : SizedBox.square(
              dimension: 24,
              child: ColoredBox(color: groceryItems[index].category.color),
            ),

            // Icon(Icons.square, color: groceryItems[index].category.color, size: 34),
            //? ALternative approach to Sizedbox 
            // Container( height: 24, width: 24, //? Alternative to Icon & Sizedbox approach
            //   color: groceryItems[index].category.color,
            // )
            trailing: Text(groceryItems[index].quantity.toString()),
          ),
        ));
  }
}
