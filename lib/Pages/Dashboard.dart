import 'package:flutter/material.dart';

import 'package:my_biosphere_app/Widgets/Co2.dart';
import 'package:my_biosphere_app/Datamodels/Co2Data.dart';
import 'package:my_biosphere_app/Widgets/Temperature.dart';
import 'package:my_biosphere_app/Widgets/Humidity.dart';
import 'package:my_biosphere_app/Datamodels/Co2RatioData.dart';
import 'package:my_biosphere_app/Widgets/NavBar.dart' as NavBar;

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _Dashboard createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {

  Map arguments = {};
  Map buttonStatus = {
    'dashboard': Colors.white,
    'tasks': Colors.white,
    'plants': Colors.white,
  };
  Map navigationBarData = {};
  Map userData = {};

  List<Co2Data> co2Data = [
    Co2Data('Co²', 33, const Color(0x8100DE27)),
    Co2Data('air', 77, const Color(0xFFFFFFFF)),
  ];

  List<Co2RatioData> co2RatioData = [
    Co2RatioData('Co²', 33, 100, const Color(0x8100DE27)),
  ];

  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context)?.settings.arguments as Map;
    buttonStatus = arguments["navigationBarData"];
    userData = arguments["userData"];

    return Scaffold(
      body: Column(
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
            flex: 4,
            child: Co2(co2Data: co2Data),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: const [
                Expanded(
                  flex: 1,
                  child: Temperature(),
                ),
                Expanded(
                  flex: 1,
                  child: Humidity(),
                ),
              ],
            ),
          ),
          // TODO clean ratio widget
          // Expanded(
          //   flex: 2,
          //   child: Co2Ratio(co2RatioData: co2RatioData),
          // ),
          Expanded(flex: 1, child: NavBar.NavigationBar(buttonStatus, userData))
        ],
      ),
    );
  }
}
