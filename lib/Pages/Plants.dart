import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_biosphere_app/Widgets/NavBar.dart' as NavBar;
import 'package:my_biosphere_app/Widgets/PlantCard.dart';
import 'package:my_biosphere_app/Datamodels/PlantData.dart';

class Plants extends StatefulWidget {
  final Map<String, dynamic>? args;
  const Plants(this.args, {Key? key}) : super(key: key);

  @override
  _Plants createState() => _Plants();
}

Future<List<Plant>> fetchPlants(token) async {
  final response = await http.get(
      Uri.parse('https://my-biosphere.herokuapp.com/plants'),
      headers: {
        "Authorization": token,
      },
  );

  if (response.statusCode == 200) {
    List data = jsonDecode(utf8.decode(response.bodyBytes));
    for( var i = 0 ; i < data.length; i++ ) {
      print(data[i]);
    }
    return Plant.userPlantList(data);
  }
  else {
    throw Exception('Plant list fetching failed : ' + response.statusCode.toString());
  }
}

Future<List> sortPlantsList(List userPlantList) async {
  Map sortedPlants = {};
  for( var i = 0 ; i < userPlantList.length; i++ ) {
    if(sortedPlants.containsKey(userPlantList[i].room)){
      sortedPlants[userPlantList[i].room]["plants"].add(
          userPlantList[i]
      );
    }
    else {
      sortedPlants[userPlantList[i].room] = {
        "name": userPlantList[i].room,
        "plants": [
          userPlantList[i]
        ],
      };
    }
  }
  List sortedPlantsList = [];
  sortedPlants.forEach((k, v) => sortedPlantsList.add(v));
  return sortedPlantsList;
}

class _Plants extends State<Plants> {
  late List plantsList = [];
  bool isLoading = true;

  @override
  initState() {
    super.initState();
    getPlants(widget.args!["userData"]["token"]);
  }

  Future<void> getPlants(token) async {
    List rawPlantsList = await fetchPlants(token);
    plantsList = await sortPlantsList(rawPlantsList);
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

  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context)?.settings.arguments as Map;
    buttonStatus = arguments["navigationBarData"];
    userData = arguments["userData"];

    return Scaffold(
      body: SafeArea(
          child: Column(children: <Widget>[
        Expanded(
          flex: 11,
          child: isLoading ?  const Center(child: CircularProgressIndicator()) :
          SingleChildScrollView(
            // physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 30.0, bottom: 15.0),
                    child: Text(
                      "Mes plantes",
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
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext, index) {
                    return Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                  top: 30.0,
                                  bottom: 15.0),
                              child: Text(
                                plantsList[index]["name"],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: DefaultTextStyle.of(context)
                                      .style
                                      .fontSize! /
                                      2,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext, indexPlants) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          '/plantDetail',
                                          arguments: {
                                            "navigationBarData": buttonStatus,
                                            "userData": userData,
                                            "plantDetail": plantsList
                                            [index]["plants"][indexPlants]
                                          });
                                    },
                                    child: PlantCard(plantsList
                                    [index]["plants"][indexPlants]));
                              },
                              itemCount: plantsList[index]["plants"].length,
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(5),
                              scrollDirection: Axis.vertical,
                            )
                          ],
                        ));
                  },
                  itemCount: plantsList.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(5),
                  scrollDirection: Axis.vertical,
                ),
              ],
            ),
          ),
        ),
        Expanded(flex: 1, child: NavBar.NavigationBar(buttonStatus, userData))
      ])),
      floatingActionButton: Align(
        alignment: const Alignment(1, 0.8),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
                '/addPlant',
                arguments: {
                  "navigationBarData": buttonStatus,
                  "userData": userData,
                });
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
      )
    );
  }
}

