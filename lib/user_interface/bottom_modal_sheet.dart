import 'package:coffeebrewbloc/authenticate/database.dart';
import 'package:flutter/material.dart';

class BottomModalSheet extends StatefulWidget {
  const BottomModalSheet({this.uid, this.database});

  final String uid;
  final Brew database;


  @override
  _BottomModalSheetState createState() => _BottomModalSheetState();
}

class _BottomModalSheetState extends State<BottomModalSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> sugars = <String>['0', '1', '2', '3', '4', '5'];
  String _currentName ;

  String _currentSugar;

  int _currentStrength;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentStrength = widget.database.strength;
    _currentSugar = widget.database.sugars;
    _currentName = widget.database.name;
  }

  @override
  Widget build(BuildContext context) {
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
            initialValue: widget.database.name,
            validator: (String val) =>
            val.isEmpty ? 'Please enter an name' : null,
            onChanged: (String val) => setState(()=> _currentName = val),
          ),
          const SizedBox(height: 20.0),
          DropdownButtonFormField<String>(
            value: _currentSugar ?? widget.database.sugars,
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
            value: (_currentStrength ?? widget.database.strength).toDouble(),
            activeColor: Colors.brown[_currentStrength ?? widget.database.strength],
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
                Navigator.pop(context);
                await Database(uid: widget.uid).updateUserData(
                    widget.uid,
                    _currentSugar ?? '0',
                    _currentName ?? 'new-crew-member',
                    _currentStrength ?? 100);
              }
            },
          )
        ],
      ),
    );
  }
}
