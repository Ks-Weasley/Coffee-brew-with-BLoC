import 'package:coffeebrewbloc/authenticate/database.dart';
import 'package:flutter/material.dart';

class BrewTile extends StatelessWidget {
  const BrewTile({Key key, this.brew}) : super(key: key);

  final Brew brew;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        elevation: 10.0,
        margin: const EdgeInsets.fromLTRB(16, 6, 16, 0),
        child: Container(
          height: 100,
          child: ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: CircleAvatar(
                child: Text('${brew.strength}', style: TextStyle(color: Colors.white),),
                radius: 25.0,
                backgroundColor: Colors.brown[brew.strength],
              ),
            ),
            title: Text(
              brew.name,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Takes ${brew.sugars} sugar(s)',
                style: const TextStyle(fontSize: 17.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
