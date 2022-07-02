import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
    'userURL': 'https://my-biosphere.herokuapp.com/users/1/',
    'notificationSent': false
  };

  final formKey = GlobalKey<FormState>();
  String name = '';
  String pwd = '';

  FlutterLocalNotificationsPlugin flutterNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = new IOSInitializationSettings();

    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterNotificationPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
        Expanded(flex: 4,
          child:Align(
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 30.0, bottom: 15.0),
            child: Text(
              "Ma Biosphère",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize:
                DefaultTextStyle.of(context).style.fontSize! / 1,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),),
          Expanded(flex: 8, child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              // padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildName(),
                    buildPwd(),
                    Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(50)),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ))),
                        onPressed: () {
                          setState(() {
                            buttonStatus.forEach((key, value) {
                              buttonStatus[key] = Colors.white;
                            });
                            buttonStatus['dashboard'] = const Color(0xFF25832B);
                            Navigator.of(context)
                                .pushNamed('/dashboard', arguments: {
                              "navigationBarData": buttonStatus,
                              "userData": userData,
                            });
                          });
                        },
                        child: Text(
                          'Connexion',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize:
                            DefaultTextStyle.of(context).style.fontSize! / 1.7,
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          ),)
        ],
      )
    ));
  }

  Widget buildName() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Entrer votre identifiant';
          } else {
            return null;
          }
        },
        onChanged: (String? value) {
          name = value!;
        },
        maxLength: 80,
      );

  Widget buildPwd() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Mot de passe',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Entrez votre mot de passe';
          } else {
            return null;
          }
        },
        onChanged: (String? value) {
          pwd = value!;
        },
        maxLength: 200,
      );
}
