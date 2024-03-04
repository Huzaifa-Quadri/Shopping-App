import 'package:flutter/material.dart';
import 'package:shopping_app/data/categories.dart';
import 'package:shopping_app/models/categories.dart';
import 'package:shopping_app/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formkey = GlobalKey<FormState>(); //Creating a Global key ;Form Specific
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;

  void _saveItem(){
    if(_formkey.currentState!.validate()){  // This will trigger validator function through key
    _formkey.currentState!.save();

    Navigator.pop(context, GroceryItem(
      id: DateTime.now().toString(), 
      name: _enteredName,
      quantity: _enteredQuantity, 
      category: _selectedCategory));
    }
    print(_enteredQuantity);
    print(_enteredName);
    print(_selectedCategory);
    print(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a new Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key : _formkey,
          child: Column(
            children: [
              TextFormField(
                  //Instead of TextField used or bcz or favourable in form
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text("Name"),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.trim().length<=1 || value.trim().length>50 ) {
                      return "Enter between 1 to 50 characters";
                    }
                    return null;
                  },
                  onSaved: (value){
                    _enteredName = value!;
                  }
                  
                  ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      initialValue: '1',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty || int.tryParse(value) == null || int.tryParse(value)!<=0) {  //int.tryParse(value) => returns null if string cannot be converted to number; we are checking entered value is a number or not
                          return "Enter between 1 to 50 characters";
                        }
                        return null;
                      },
                      onSaved: (value){
                        _enteredQuantity = int.parse(value!);
                      }
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value, //! WHy not using this ?? 
                            child: Row(
                              children: [
                               Container(
                                width: 16,
                                height: 16,
                                color: category.value.color,
                               ),
                                const SizedBox(width: 6),
                                Text(category.value.title),
                              ],
                            ),
                          ),
                      ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed:(){
                     _formkey.currentState!.reset();
                    }, 
                    child: const Text("Reset")),

                  ElevatedButton(
                    onPressed: _saveItem, 
                    child: const Text("Add Item")
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}