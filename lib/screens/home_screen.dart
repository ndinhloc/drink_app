import 'package:drink_app/screens/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../api_service/drink_api.dart';
import '../models/drink_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  late Future<Drink> randomDrink;
  late Future<List<Drink>> drinks;
  String type = 'Alcoholic';
  @override
  void initState() {
    super.initState();
    randomDrink = DrinkApi.fetchRandomDrink();
    drinks = DrinkApi.fetchByTypeDrinks(type);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Header(),
              Container(
                width: double.infinity,
                height: 150,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.8),
                    borderRadius: const BorderRadius.all(Radius.circular(16))),
                child: getRandomDrink(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        type = "Alcoholic";
                        drinks = DrinkApi.fetchByTypeDrinks(type);
                      });
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: const Text("Alcoholic"),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        type = "Non_Alcoholic";
                        drinks = DrinkApi.fetchByTypeDrinks(type);
                      });
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: const Text("Non Alcoholic"),
                    ),
                  ),
                ],
              ),
              getDrinksList()
            ]),
      ),
    );
  }

  FutureBuilder<Drink> getRandomDrink() {
    return FutureBuilder<Drink>(
      future: randomDrink,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DetailPage(id: snapshot.data!.idDrink)));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      snapshot.data!.strDrink,
                      style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      softWrap: true,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(snapshot.data!.strDrinkThumb),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString(), style: GoogleFonts.inter());
        }
        return const FittedBox(child: CircularProgressIndicator());
      },
    );
  }

  FutureBuilder<List<Drink>> getDrinksList() {
    return FutureBuilder<List<Drink>>(
      future: drinks,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1),
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailPage(
                                    id: snapshot.data![index].idDrink)));
                      },
                      child: Card(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        elevation: 5,
                        clipBehavior: Clip.antiAlias,
                        child:
                            Stack(alignment: Alignment.bottomCenter, children: [
                          Image.network(snapshot.data![index].strDrinkThumb),
                          Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.8),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8))),
                            child: Text(
                              snapshot.data![index].strDrink,
                              style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              softWrap: true,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          )
                        ]),
                      ),
                    );
                  }),
            ),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        // By default show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Find your drink recipe!",
                style: GoogleFonts.inter(fontSize: 20),
              ),
              Text(
                "Here is a recommendation:",
                style: GoogleFonts.inter(fontSize: 16),
              )
            ],
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                image: const DecorationImage(
                    image: AssetImage('assets/images/cocktailglass.png'),
                    fit: BoxFit.fill)),
          )
        ],
      ),
    );
  }
}
