import 'package:flutter/material.dart';
// import 'package:shopping_app/data/dummy_items.dart'; //We are giving totaally new values now 
import 'package:shopping_app/models/grocery_item.dart';
import 'package:shopping_app/screens/new_item.dart';


class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  
  final List<GroceryItem> _groceryItems = [];

  void _onTap() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(builder: (ctx) =>const NewItem())
    );

    if (newItem == null) {
      return ;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }
  void _removeItem(GroceryItem item){
    setState(() {
      _groceryItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget bodyContent =const Scaffold(
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text("Hurry Up!!", style: Theme.of(context).textheadline ),
            Text("No List Item here !", style: TextStyle(fontSize: 30),),
          ],
        ),
      ),
    );
        

  if (_groceryItems.isNotEmpty) {
    bodyContent = ListView.builder(
          itemCount: _groceryItems.length,
          itemBuilder: (ctx, index) => Dismissible(
            key: ValueKey(_groceryItems[index].id),
            onDismissed: (direction) => _removeItem(_groceryItems[index]),

            child: ListTile(
              title: Text(_groceryItems[index].name),
              leading : SizedBox.square(
                dimension: 24,
                child: ColoredBox(color: _groceryItems[index].category.color),
              ),
            
              // Icon(Icons.square, color: groceryItems[index].category.color, size: 34),
              //? ALternative approach to Sizedbox 
              // Container( height: 24, width: 24, //? Alternative to Icon & Sizedbox approach
              //   color: groceryItems[index].category.color,
              // )
              trailing: Text(_groceryItems[index].quantity.toString()),
            ),
          ),
        );
  
  }

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Your Groceries",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(onPressed: _onTap, icon:const Icon(Icons.add),
        )]
        ),
        body: bodyContent
      );
  }
}
