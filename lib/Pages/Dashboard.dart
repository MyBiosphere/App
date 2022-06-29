import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_biosphere_app/Widgets/Co2.dart';
import 'package:my_biosphere_app/Datamodels/Co2Data.dart';
import 'package:my_biosphere_app/Widgets/Temperature.dart';
import 'package:my_biosphere_app/Widgets/Humidity.dart';
import 'package:my_biosphere_app/Widgets/NavBar.dart' as NavBar;

import '../Methods/notificationDefaultSound.dart';

class Dashboard extends StatefulWidget {
  final Map<String, dynamic>? args;
  const Dashboard(this.args, {Key? key}) : super(key: key);

  @override
  _Dashboard createState() => _Dashboard();
}

Future<Map> fetchMetrics(token) async {
  final response = await http.get(
    Uri.parse('https://my-biosphere.herokuapp.com/metrics'),
    headers: {
      "Authorization": token,
    },
  );

  if (response.statusCode == 200) {
    List data = jsonDecode(utf8.decode(response.bodyBytes));
    return data[0];
  }
  else {
    throw Exception('Plant list fetching failed : ' + response.statusCode.toString());
  }
}

class _Dashboard extends State<Dashboard> {
  late Map metrics = {};
  bool isLoading = true;
  late Timer timer;
  Map notification = {
    "co2" : {
      "title" : "Trop de co2 dans l'air",
      "desc": "Il faut aérer l'appartement"
    },
    "humidity_low" : {
      "title" : "L'air est trop sec",
      "desc": "Il faut aérer l'appartement et ajouter des plantes"
    },
    "humidity_high" : {
      "title" : "L'air est trop humide",
      "desc": "Il faut aérer l'appartement"
    },
    "temperature_low" : {
      "title" : "L'appartement est trop froid",
      "desc": "Il faut fermer les fenêtres et allumer le chaufage"
    },
    "temperature_high" : {
      "title" : "L'appartement est trop chaud",
      "desc": "Il faut fermer les volets et les fenêtres"
    },
  };

  FlutterLocalNotificationsPlugin flutterNotificationPlugin = FlutterLocalNotificationsPlugin();

  @override
  initState() {
    super.initState();
    getMetrics(widget.args!["userData"]["token"]);

    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterNotificationPlugin.initialize(initializationSettings);

    timer = Timer.periodic(const Duration(seconds: 10), (Timer t) => getMetrics(widget.args!["userData"]["token"]));
  }

  Future<void> getMetrics(token) async {
    metrics = await fetchMetrics(token);

    if(int.parse(metrics["co2"]) < 600) {
      metrics["co2Color"] = palette["good"];
    } else if(int.parse(metrics["co2"]) < 1000) {
      metrics["co2Color"] = palette["medium"];
    } else {
      metrics["notification"] = notification["co2"];
      metrics["co2Color"] = palette["bad"];
    }

    if(int.parse(metrics["temperature"]) > 15 && int.parse(metrics["temperature"]) < 25 ) {
      metrics["temperatureColor"] = palette["good"];
    } else if(int.parse(metrics["temperature"]) < 35) {
      metrics["temperatureColor"] = palette["medium"];
    } else {
      metrics["temperatureColor"] = palette["bad"];
      if (int.parse(metrics["temperature"]) < 15) {
        metrics["notification"] = notification["temperature_low"];
      }
      else {
        metrics["notification"] = notification["temperature_high"];
      }
    }

    if(int.parse(metrics["humidity"]) < 20) {
      metrics["notification"] = notification["humidity_low"];
      metrics["humidityColor"] = palette["bad"];
    } else if (int.parse(metrics["humidity"]) > 80) {
      metrics["notification"] = notification["humidity_high"];
      metrics["humidityColor"] = palette["bad"];
    } else if(int.parse(metrics["humidity"]) < 40 || int.parse(metrics["humidity"]) > 70) {
      metrics["humidityColor"] = palette["medium"];
    } else {
      metrics["humidityColor"] = palette["good"];
    }

    co2Data.add(Co2Data('Co²', int.parse(metrics["co2"]) /82, const Color(0x8100DE27)));
    co2Data.add(Co2Data('air', (8200 - int.parse(metrics["co2"])) /82, const Color(
        0xFFFFFFFF)));
    print(metrics);
    setState(() {
      isLoading = false;
    });
  }

  Map arguments = {};
  Map buttonStatus = {
    'dashboard': Colors.white,
    'tasks': Colors.white,
    'plants': Colors.white,
  };
  Map navigationBarData = {};
  Map userData = {};

  Map palette  = {
    'good': Colors.green,
    'medium': const Color(0xFFA16814),
    'bad': const Color(0xFF9B2323),
  };

  List<Co2Data> co2Data = [];

  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context)?.settings.arguments as Map;
    buttonStatus = arguments["navigationBarData"];
    userData = arguments["userData"];

    if (metrics.containsKey("notification") && !userData['notificationSent']){
      notificationDefaultSound(flutterNotificationPlugin, metrics['notification']['title'], metrics['notification']['desc']);
      userData['notificationSent'] = true;
    }


    return Scaffold(
      body: SafeArea(
          child: isLoading ?  const Center(child: CircularProgressIndicator()) :
          Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: SafeArea(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 30.0, bottom: 15.0),
                      child: Text(
                        "Ma Biosphère",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize:
                          DefaultTextStyle.of(context).style.fontSize! / 1.5,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Co2(co2Data: co2Data),
              ),
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Temperature(metrics["temperature"], metrics["temperatureColor"]),
                    ),
                    Expanded(
                      flex: 1,
                      child: Humidity(metrics["humidity"], metrics["humidityColor"]),
                    ),
                  ],
                ),
              ),
              Expanded(flex: 1, child: NavBar.NavigationBar(buttonStatus, userData)),
            ],
          ),
      )
    );
  }
}
