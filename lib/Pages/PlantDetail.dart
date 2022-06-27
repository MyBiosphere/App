import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:my_biosphere_app/Widgets/NavBar.dart' as NavBar;
import 'package:my_biosphere_app/Widgets/PlantDetailTile.dart';
import 'package:my_biosphere_app/Datamodels/PlantData.dart';

class PlantDetail extends StatefulWidget {
  const PlantDetail({Key? key}) : super(key: key);

  @override
  _PlantDetail createState() => _PlantDetail();
}

class _PlantDetail extends State<PlantDetail> {
  Map arguments = {};
  Map buttonStatus = {
    'dashboard': Colors.white,
    'tasks': Colors.white,
    'plants': Colors.white,
  };

  Map navigationBarData = {};
  Map userData = {};
  late Plant plantDetail;
  late Color backgroundColor;
  File? picture;

  Future takePicture() async {
    final pic = await ImagePicker().pickImage(source: ImageSource.camera );
    if (pic == null) return;
    final tmpPic = File(pic.path);
    setState(() {
      picture = tmpPic;
    });
  }

  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context)?.settings.arguments as Map;
    buttonStatus = arguments["navigationBarData"];
    userData = arguments["userData"];
    plantDetail = arguments["plantDetail"];
    backgroundColor = plantDetail.status == "Saine" ? Colors.green : Colors.red;
    List data = [
      {
        "text": "Arrosage",
        "value": "${plantDetail.watering}/s",
        "color": Color(0xDD0F08C9),
      },
      {
        "text": "Lumière",
        "value": plantDetail.sunshine,
        "color": const Color(0xFFE1C014),
      },
      {
        "text": "Rempotage",
        "value": "${plantDetail.repot}/an",
        "color": const Color(0xFFA15810),
      },
      {
        "text": "Floraison",
        "value": plantDetail.bloom,
        "color": const Color(0xFF9710A1),
      },
    ];

    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Column(children: <Widget>[
            Expanded(
                flex: 7,
                child: Container(
                    decoration: BoxDecoration(color: backgroundColor))),
            Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20.0 / 2),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              plantDetail.name,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                DefaultTextStyle.of(context).style.fontSize! /
                                    1.5,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 20.0, top: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                plantDetail.room,
                                style: TextStyle(
                                  color: Colors.black,
                                  // fontWeight: FontWeight.bold,
                                  fontSize:
                                  DefaultTextStyle.of(context).style.fontSize! /
                                      2.3,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(content: Text('Processing Data')),
                        // );
                        takePicture();
                      },
                      child: const Text('Prendre une photo'),
                    ),
                    const SizedBox(width: 50),
                  ],
                )),
            Expanded(
                flex: 12,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: 4,
                  // physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return PlantDetailTile(data[index]);
                  },
                )),
            Expanded(
                flex: 2, child: NavBar.NavigationBar(buttonStatus, userData))
          ]),
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      )),
    );
  }
}
