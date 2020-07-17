import 'package:coffeebrewbloc/user_interface/brew_list.dart';
import 'package:flutter/material.dart';
import 'package:coffeebrewbloc/authenticate/database.dart';

class UserHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<List<Brew>>(
        stream: Database().currentBrewList,
        builder: (BuildContext context, AsyncSnapshot<List<Brew>> snapshot) {
          if (snapshot.hasData)
            return BrewList(
              brew: snapshot.data,
            );
          return Container();
        });
  }
}
