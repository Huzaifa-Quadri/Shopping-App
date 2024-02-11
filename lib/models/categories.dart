// import 'package:flutter/material.dart';

// enum Categories{
//   vegetables,
//   meat,
//   dairy,
//   sweets,
//   spices,
//   convenience,
//   hygiene,
//   carbs,
//   fruit,
//   other
// }

// class Category{
//   const Category(this.title,this.color);


//   final String title;
//   final Color color;
// }
import 'package:flutter/material.dart';

enum Categories {
  vegetables,
  fruit,
  meat,
  dairy,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other
}

class Category {
  const Category(this.title, this.color);

  final String title;
  final Color color;
}