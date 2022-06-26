import 'package:flutter/material.dart';

class Loader extends StatefulWidget {

  @override
  _Loader createState() => _Loader();
}

class _Loader extends State<Loader> {
  Map arguments = {};
  Map buttonStatus = {
    'dashboard': const Color(0xFF25832B),
    'tasks': Colors.white,
    'plants': Colors.white,
  };

  Map navigationBarData = {};
  Map userData = {
    'token': 'Token 42380a205a0c5188f385652589c8a221f751dee0',
    'userURL': 'https://my-biosphere.herokuapp.com/users/1/'
  };

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Column(children: <Widget>[
          const Expanded(
            flex: 1,
              child:Text("Loading"),
          ),
          Expanded(
            flex: 1,
            child:TextButton(
              child: const Text("Connexion",
                textAlign: TextAlign.center,),
              onPressed: () {
                setState(() {
                  buttonStatus.forEach((key, value) {
                    buttonStatus[key] = Colors.white;
                  });
                  buttonStatus['dashboard'] = const Color(0xFF25832B);
                  Navigator.of(context).pushNamed('/dashboard', arguments: {
                    "navigationBarData": buttonStatus,
                    "userData": userData,
                  });
                });
              },
            )
          ),

        ]));
  }
}
