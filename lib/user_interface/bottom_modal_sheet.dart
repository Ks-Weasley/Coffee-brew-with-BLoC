import 'package:coffeebrewbloc/authenticate/database.dart';
import 'package:flutter/material.dart';

class BottomModalSheet extends StatefulWidget {
  const BottomModalSheet({this.uid});

  final String uid;


  @override
  _BottomModalSheetState createState() => _BottomModalSheetState();
}

class _BottomModalSheetState extends State<BottomModalSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> sugars = <String>['0', '1', '2', '3', '4', '5'];
  Brew database;
  String _currentName;

  String _currentSugar;

  int _currentStrength;

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    super.initState();
  }
  void getCurrentUser() async{
    database= await Database(uid: widget.uid).currentUser;
    _currentStrength = database.strength;
    _currentName=database.name;
    _currentSugar = database.sugars;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {

    });
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          const Text(
            'Update your brew settings',
            style: const TextStyle(fontSize: 18.0),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextFormField(
            initialValue: database.name,
            validator: (String val) =>
            val.isEmpty ? 'Please enter an name' : null,
            onChanged: (String val) => setState(()=> _currentName = val),
          ),
          const SizedBox(height: 20.0),
          DropdownButtonFormField<String>(
            value: _currentSugar ?? database.sugars,
            items: sugars.map((String sugar) {
              return DropdownMenuItem<String>(
                value: sugar,
                child: Text('$sugar sugar(s)'),
              );
            }).toList(),
            onChanged: (String val) => setState(()=>_currentSugar = val),
          ),
          const SizedBox(height: 20.0),
          Slider(
            value: (_currentStrength ?? database.strength).toDouble(),
            activeColor: Colors.brown[_currentStrength ?? database.strength],
            min: 100,
            max: 900,
            divisions: 8,
            onChanged: (double val) => setState(()=>_currentStrength = val.round()),
          ),
          const SizedBox(
            height: 20.0,
          ),
          RaisedButton(
            child: Text(
              'Update',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.brown,
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                await Database(uid: widget.uid).updateUserData(
                    widget.uid,
                    _currentSugar ?? '0',
                    _currentName ?? 'new-crew-member',
                    _currentStrength ?? 100);
              }
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
