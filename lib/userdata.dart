import 'dart:io';

import 'package:flutter/services.dart';

class Userdata{

  static String name = "John";
  static String lastname = "Doe";
  static String username = "JohnDoe123";
  static List<dynamic> lovedRecipes = [];
  static List<Map<String, String>> recipes = [];

  static void clear(){
    Userdata.name = "";
    Userdata.lastname = "";
    Userdata.username = "";
    Userdata.lovedRecipes = [];
  }

  static Future<void> getLocalRecipes() async {
    List<Map<String, String>> recipes = [];
    final String response = await rootBundle.loadString('lib/allRecipes_diabetes_recipes.csv');
    List<String> lines = response.split("\n");
    for (int i = 1; i < lines.length - 1; i++){
      List<String> elements = lines[i].split(";");
      Map<String, String> recipe = {'recipe_id':elements[0], 'name': elements[1],'url': elements[2], 'ingredients': elements[3]};
      recipes.add(recipe);
    }
    Userdata.recipes = recipes;
  }

}