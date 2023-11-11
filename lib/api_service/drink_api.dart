import 'dart:convert';

import 'package:drink_app/models/drink_model.dart';
import 'package:http/http.dart' as http;

class DrinkApi {
  static var client = http.Client();
  static Future<Drink> fetchRandomDrink() async {
    var response = await client.get(
        Uri.parse("https://www.thecocktaildb.com/api/json/v1/1/random.php"));
    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      return (responseJson['drinks'] as List)
          .map((e) => Drink.fromJson(e))
          .toList()
          .elementAt(0);
    } else {
      throw Exception("Failed to load");
    }
  }

  static Future<List<Drink>> searchDrink(String name) async {
    var response = await client.get(Uri.parse(
        "http://www.thecocktaildb.com/api/json/v1/1/search.php?s=$name"));
    if (response.statusCode == 200) {
      var responseJson = jsonDecode((response.body));
      return (responseJson['drinks'] as List)
          .map((e) => Drink.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to load");
    }
  }

  static Future<List<Drink>> fetchByTypeDrinks(String type) async {
    var response = await client.get(Uri.parse(
        "http://www.thecocktaildb.com/api/json/v1/1/filter.php?a=$type"));
    if (response.statusCode == 200) {
      var responseJson = jsonDecode((response.body));
      return (responseJson['drinks'] as List)
          .map((e) => Drink.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to load");
    }
  }

  static Future<Drink> fetchDrinkById(String id) async {
    var response = await client.get(Uri.parse(
        "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=$id"));
    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      return (responseJson['drinks'] as List)
          .map((e) => Drink.fromJson(e))
          .toList()
          .elementAt(0);
    } else {
      throw Exception("Failed to load");
    }
  }
}
