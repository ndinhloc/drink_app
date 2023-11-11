import 'package:drink_app/screens/detail_page.dart';
import 'package:drink_app/api_service/drink_api.dart';
import 'package:drink_app/models/drink_model.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  final _textController = TextEditingController();

  Future<List<Drink>>? resultDrinks;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.9,
          child: TextField(
            controller: _textController,
            onEditingComplete: () {
              setState(() {
                resultDrinks = DrinkApi.searchDrink(_textController.text);
              });
            },
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              hintText: "Find a drink...",
              suffixIcon: IconButton(
                onPressed: () {
                  _textController.clear();
                  setState(() {
                    resultDrinks = null;
                  });
                },
                icon: const Icon(Icons.clear),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: resultDrinks,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text("No result."));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DetailPage(id: snapshot.data![index].idDrink)));
                  },
                  child: ListTile(
                      leading:
                          Image.network(snapshot.data![index].strDrinkThumb),
                      title: Text(snapshot.data![index].strDrink)),
                );
              },
            );
          }
        },
      ),
    );
  }
}
