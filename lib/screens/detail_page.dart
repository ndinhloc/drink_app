import 'package:drink_app/api_service/drink_api.dart';
import 'package:drink_app/box.dart';
import 'package:drink_app/models/drink_model.dart';
import 'package:drink_app/models/favorite.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPage extends StatefulWidget {
  final String drinkId;

  const DetailPage({super.key, required String id}) : drinkId = id;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Drink> drink;
  @override
  void initState() {
    drink = DrinkApi.fetchDrinkById(widget.drinkId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Drink>(
      future: drink,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.favorite),
                    onPressed: () {
                      setState(() {
                        if (favoriteBox.containsKey(snapshot.data!.idDrink)) {
                          favoriteBox.delete(snapshot.data!.idDrink);
                          return;
                        }
                        favoriteBox.put(
                            snapshot.data!.idDrink,
                            Favorite(
                                imgUrl: snapshot.data!.strDrinkThumb,
                                name: snapshot.data!.strDrink,
                                id: snapshot.data!.idDrink));
                      });
                    },
                  ),
                ],
              ),
              body: Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 250,
                    width: 250,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(snapshot.data!.strDrinkThumb),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    snapshot.data!.strDrink,
                    style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Text("Instruction: ",
                            style: TextStyle(fontSize: 20)),
                        Text(snapshot.data!.strInstructions,
                            style: const TextStyle(fontSize: 16)),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.ingredientsList.length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: Image.network(snapshot
                                      .data!.ingredientsList[index].image),
                                ),
                                Text(
                                  snapshot.data!.ingredientsList[index]
                                      .strIngredientName,
                                  style: const TextStyle(fontSize: 25),
                                ),
                                Text(
                                    snapshot.data!.ingredientsList[index]
                                        .strMeasure,
                                    style: const TextStyle(fontSize: 25))
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              )));
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        // By default show a loading spinner.
        return const SizedBox(
            height: 300, width: 300, child: const CircularProgressIndicator());
      },
    );
  }
}
