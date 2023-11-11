import 'package:drink_app/utils.dart' as utils;

class Drink {
  String idDrink;
  String strDrink;
  String strDrinkAlternate;
  String strTags;
  List<Ingredients> ingredientsList;
  String strVideo;
  String strCategory;
  String strIBA;
  String strAlcoholic;
  String strGlass;
  String strInstructions;
  String strDrinkThumb;
  String strCreativeCommonsConfirmed;

  Drink(
      {required this.idDrink,
      required this.strDrink,
      required this.strDrinkAlternate,
      required this.strTags,
      required this.ingredientsList,
      required this.strVideo,
      required this.strCategory,
      required this.strIBA,
      required this.strAlcoholic,
      required this.strGlass,
      required this.strInstructions,
      required this.strDrinkThumb,
      required this.strCreativeCommonsConfirmed});

  factory Drink.fromJson(Map<String, dynamic> jsonResponse) {
    return Drink(
        idDrink: jsonResponse["idDrink"].toString(),
        strDrink: jsonResponse["strDrink"].toString(),
        strDrinkAlternate: jsonResponse["strDrinkAlternate"].toString(),
        strTags: jsonResponse["strTags"].toString(),
        ingredientsList: _getIngredientList(
            jsonResponse, jsonResponse["idDrink"].toString()),
        strVideo: jsonResponse["strVideo"].toString(),
        strCategory: jsonResponse["strCategory"].toString(),
        strIBA: jsonResponse["strIBA"].toString(),
        strAlcoholic: jsonResponse["strAlcoholic"].toString(),
        strGlass: jsonResponse["strGlass"].toString(),
        strInstructions: jsonResponse["strInstructions"].toString(),
        strDrinkThumb: jsonResponse["strDrinkThumb"].toString(),
        strCreativeCommonsConfirmed:
            jsonResponse["strCreativeCommonsConfirmed"].toString());
  }
  static List<Ingredients> _getIngredientList(
      Map<String, dynamic> jsonResponse, String drinkId) {
    List<Ingredients> ingredientList = <Ingredients>[];

    for (var i = 1; i <= 15; i++) {
      if (jsonResponse["strIngredient$i"].toString() != "null" &&
          jsonResponse["strIngredient$i"].toString().isNotEmpty) {
        var ingredient = Ingredients(
            strIngredientName: jsonResponse["strIngredient$i"].toString(),
            strMeasure: jsonResponse["strMeasure$i"].toString(),
            image:
                utils.getImageUrl(jsonResponse["strIngredient$i"].toString()),
            id: drinkId);
        ingredientList.add(ingredient);
      }
    }
    return ingredientList;
  }
}

class Ingredients {
  String strIngredientName;
  String strMeasure;
  String image;
  String id;

  Ingredients(
      {required this.strIngredientName,
      required this.strMeasure,
      required this.image,
      required this.id});
}
