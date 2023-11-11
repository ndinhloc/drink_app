import 'package:drink_app/box.dart';
import 'package:drink_app/models/favorite.dart';
import 'package:drink_app/screens/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ValueListenableBuilder(
            valueListenable:
                Hive.box<Favorite>('favoriteDrinksBox').listenable(),
            builder: (context, favoriteBox, _) {
              if (favoriteBox.values.isEmpty) {
                return const Center(
                  child: Text("No favorite drink yet, try adding one."),
                );
              }
              return ListView.builder(
                  itemCount: favoriteBox.values.length,
                  itemBuilder: (context, index) {
                    Favorite currentDrink = favoriteBox.getAt(index)!;
                    return InkWell(
                      onLongPress: () {/* ... */},
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailPage(
                                    id: favoriteBox.getAt(index)!.id)));
                      },
                      child: ListTile(
                          trailing: IconButton(
                              onPressed: () {
                                favoriteBox.deleteAt(index);
                              },
                              icon: Icon(Icons.delete_outline_rounded)),
                          leading: Image.network(currentDrink.imgUrl),
                          title: Text(currentDrink.name)),
                    );
                  });
            }));
  }
}
