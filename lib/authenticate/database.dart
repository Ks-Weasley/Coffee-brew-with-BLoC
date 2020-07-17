import 'package:cloud_firestore/cloud_firestore.dart';

class Brew {
  Brew({this.sugars, this.name, this.strength});

  final String sugars;
  final String name;
  final int strength;
}

class Database {
  Database({this.uid, this.brew});

  final String uid;
  final Brew brew;
  final CollectionReference brewCollection =
      Firestore.instance.collection('brews');

  Future<void> updateUserData(
      String uid, String sugars, String name, int strength) async {
    return brewCollection.document(uid).setData(<String, dynamic>{
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }
  Future<Brew> get currentUser {
    return brewCollection
        .document(uid)
        .get()
        .then((DocumentSnapshot doc) => Brew(
      name: doc.data['name'],
      sugars: doc.data['sugars'],
      strength: doc.data['strength'],
    ));
  }
  Stream<List<Brew>> get currentBrewList {
    return brewCollection.snapshots().map(mapToBrew);
  }

  List<Brew> mapToBrew(QuerySnapshot snapshot) {
    return snapshot.documents.map((DocumentSnapshot doc) {
      return Brew(
        name: doc.data['name'] ?? 'new-crew-member',
        sugars: doc.data['sugars'] ?? '0',
        strength: doc.data['strength'] ?? 1,
      );
    }).toList();
  }
}
