import 'package:coffeebrewbloc/authenticate/database.dart';
import 'package:flutter/material.dart';
import 'brew_tile.dart';

class BrewList extends StatelessWidget {
  const BrewList({Key key, this.brew}) : super(key: key);

  final List<Brew> brew;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: brew.length,
        itemBuilder: (BuildContext context, int index) {
          return brew.isEmpty ? Container(child:const Text('no documents yet!')) : BrewTile(brew: brew[index]);
        });
  }
}
