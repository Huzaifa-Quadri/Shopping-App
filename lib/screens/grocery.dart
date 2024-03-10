import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_app/data/categories.dart';
// import 'package:shopping_app/data/dummy_items.dart'; //We are giving totaly new values now 
import 'package:shopping_app/models/grocery_item.dart';
import 'package:shopping_app/screens/new_item.dart';

import 'package:http/http.dart' as http;



class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {

  List<GroceryItem> _groceryItems = []; //since we are now overriding it to another list (removed final)
  var _isLoading = true;
  String? _errorCode;

  @override
  void initState() {   //invoking func drom init state as it needs to feth data whenever the app restarts or reloades
    super.initState();
    _loaditemsfromDB();  //not including await here since we are not returning any data
  }
  _loaditemsfromDB() async {
    final url = Uri.https('shopping-demo-app-cdce7-default-rtdb.firebaseio.com','shopping-list.json');
    final response = await http.get(url);
    print(response.statusCode);
    if(response.statusCode > 400){ //! Codes greater than 400 are error codes or indicate error
      setState(() {
        _errorCode = "Failed to fetch data! Try Again Later.";  
      });
    }

    final Map<String,dynamic> listData = json.decode(response.body);
    final List<GroceryItem> loadedlistitems = [];   //Temp list to store items
    for (final item in listData.entries) {
      final category = categories.entries.firstWhere((catItem) => catItem.value.title == item.value['category']).value; //.value will give identified category
      //? lHS side is comaping title from map set categories in model and RHS is comparing value of category title that is returned by database

      loadedlistitems.add(
        GroceryItem(
          id: item.key,
          name : item.value['name'],
          quantity : item.value['quantity'],
          category : category,
        )
      );
    }
    setState(() {
      _groceryItems = loadedlistitems;
      _isLoading = false;
    });
    // print(response.body);
  }
  

  void _onTap() async { 
    final newItem = await Navigator.of(context).push<GroceryItem>(    //removed varibale initialization since same reason as below
      MaterialPageRoute(builder: (ctx) =>const NewItem())
    );

    if (newItem == null) {
      return ;
    }
    setState(() {
      _groceryItems.add(newItem);
    });

    // _loaditemsfromDB(); //! It is Retundent to perform HTTP request if we can send bakc data and stroing it on database at same time, so now we only perform GET Request when re-loading entire app.  
                //? Things same as just before using http request(GET Method) ; Now, only using GET in case of reloading screen 
  }

  void  _removeItem(GroceryItem item) async{
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });
    final url = Uri.https('shodeault-rtdb.firebaseio.com','shopping-list/${item.id}.json');
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Some Error Occured, Item cannot be deleted !", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),backgroundColor: Colors.redAccent,));
        _groceryItems.insert(index, item);
      });
    } 

/*  //?  Delete WITHOUT Error Handling
    final url = Uri.https('shopping-demo-app-cdce7-default-rtdb.firebaseio.com','shopping-list/${item.id}.json');
    final response = http.delete(url);
*/
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

    if (_isLoading) {
      bodyContent =const Center(child: CircularProgressIndicator(),); 
    }

    if (_errorCode != null) {
      bodyContent = Center(child: Text(_errorCode!),);
    }
        

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
