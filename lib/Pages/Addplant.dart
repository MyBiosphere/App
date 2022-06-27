import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

import 'package:my_biosphere_app/Widgets/NavBar.dart' as NavBar;

class AddPlant extends StatefulWidget {
  const AddPlant({Key? key}) : super(key: key);

  @override
  _AddPlant createState() => _AddPlant();
}

class _AddPlant extends State<AddPlant> {
  Map arguments = {};
  Map buttonStatus = {
    'dashboard': Colors.white,
    'tasks': Colors.white,
    'plants': Colors.white,
  };

  Map navigationBarData = {};
  Map userData = {};
  Map plantDetail = {};

  final formKey = GlobalKey<FormState>();
  // required
  String name = '';
  String description = '';
  String room = 'Salon';
  List<String> roomList = [
    'Salon',
    'Chambre',
    'Cuisine',
    'Bureau',
    'Salle de bain',
    'Balcon',
    'Terrasse',
  ];
  String status = 'Saine';
  List<String> statusList = ['Saine', 'Malade', 'Assoifée', 'Trop humide'];
  String watering = '1';
  List<String> wateringList = ['1', '2', '3', '4', '5', '6', '7'];
  String sunshine = 'Directe';
  List<String> sunshineList = ['Directe', 'Indirecte', 'Ombragé'];
  String repot = '1';
  List<String> repotList = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
  ];
  String blooming = '';

  String user = '';

  late File picture;

  Future<String> createPlant(token) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://my-biosphere.herokuapp.com/plants/'));
    request.headers.addAll({
      "Authorization": token
    });

    // CAS 1
    http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'file', picture.path);
    request.files.add(multipartFile);

    // CAS 2
    request.files.add(http.MultipartFile(
        'name', picture.readAsBytes().asStream(), picture.lengthSync(),
        filename: "test"));

    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['room'] = room;
    request.fields['status'] = status;
    request.fields['watering'] = watering;
    request.fields['sunshine'] = sunshine;
    request.fields['repot'] = repot;
    request.fields['blooming_time'] = blooming;
    request.fields['user'] = user;

    // request.headers.addAll({HttpHeaders.contentLengthHeader, request.files.length});
    print(request.headers);
    final response = await request.send();

    if (response.statusCode == 201) {
      setState(() {
        Navigator.of(context).pushNamed('/plants', arguments: {
          "navigationBarData": buttonStatus,
          "userData": userData,
        });
      });
      return "Sucess";
    } else {
      throw Exception(
          'Plant creation failed : ' + response.statusCode.toString());
    }
  }

  Future<String> createPlantWithoutPic(token) async {
    final response =
        await http.post(Uri.parse('https://my-biosphere.herokuapp.com/plants/'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              "Authorization": token,
            },
            body: jsonEncode(<String, dynamic>{
              'name': name,
              'description': description,
              'room': room,
              'status': status,
              'watering': int.parse(watering),
              'sunshine': sunshine,
              'repot': int.parse(repot),
              'blooming_time': blooming,
              'user': user,
            }));

    if (response.statusCode == 201) {
      setState(() {
        // buttonStatus.forEach((key, value) {
        //   buttonStatus[key] = Colors.white;
        // });
        // buttonStatus['plants'] = const Color(0xFF25832B);
        Navigator.of(context).pushNamed('/plants', arguments: {
          "navigationBarData": buttonStatus,
          "userData": userData,
        });
      });
      return "Sucess";
    } else {
      throw Exception(
          'Plant creation failed : ' + response.statusCode.toString());
    }
  }

  Future takePicture() async {
    final pic = await ImagePicker().pickImage(source: ImageSource.camera);
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

    user = userData['userURL'];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Stack(
        children: [
          Column(children: <Widget>[
            Expanded(
                flex: 11,
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                                top: 30.0,
                                bottom: 15.0),
                            padding: const EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                                top: 30.0,
                                bottom: 15.0),
                            child: Text(
                              "Ajouter une plante",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: DefaultTextStyle.of(context)
                                        .style
                                        .fontSize! /
                                    1.5,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Form(
                          key: formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildName(),
                                buildDesc(),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      "Pièce : ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: DefaultTextStyle.of(context)
                                                .style
                                                .fontSize! /
                                            2.6,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                buildRoom(),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      "État : ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: DefaultTextStyle.of(context)
                                                .style
                                                .fontSize! /
                                            2.6,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                buildStatus(),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      "Nombre d'arrosage par semaine : ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: DefaultTextStyle.of(context)
                                                .style
                                                .fontSize! /
                                            2.6,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                buildWatering(),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      "Lumière : ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: DefaultTextStyle.of(context)
                                                .style
                                                .fontSize! /
                                            2.6,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                buildSunshine(),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      "Nombre de rempotage par an : ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: DefaultTextStyle.of(context)
                                                .style
                                                .fontSize! /
                                            2.6,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                buildRepot(),
                                buildBlooming(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text('Take photo')),
                                          );
                                          takePicture();
                                        },
                                        child: const Text('Photo'),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            createPlant(userData['token']);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content:
                                                      Text('Processing Data')),
                                            );
                                          }
                                        },
                                        child: const Text('Submit'),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                )),
            Expanded(
                flex: 1, child: NavBar.NavigationBar(buttonStatus, userData))
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

  Widget buildName() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Nom',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Entrer un nom de plante';
          } else {
            return null;
          }
        },
        onChanged: (String? value) {
          name = value!;
        },
        maxLength: 80,
      );

  Widget buildDesc() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Description',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Entrez une description simple de la plante';
          } else {
            return null;
          }
        },
        onChanged: (String? value) {
          description = value!;
        },
        maxLength: 200,
      );

  Widget buildRoom() => DropdownButtonFormField(
        value: room,
        hint: const Text(
          'choose one',
        ),
        isExpanded: true,
        onChanged: (String? value) {
          room = value!;
        },
        onSaved: (String? value) {
          room = value!;
        },
        validator: (String? value) {
          if (value!.isEmpty) {
            return "can't empty";
          } else {
            return null;
          }
        },
        items: roomList.map((String val) {
          return DropdownMenuItem<String>(
            value: val,
            child: Text(
              val,
            ),
          );
        }).toList(),
      );

  Widget buildStatus() => DropdownButtonFormField(
        value: status,
        hint: const Text(
          'choose one',
        ),
        isExpanded: true,
        onChanged: (String? value) {
          status = value!;
        },
        onSaved: (String? value) {
          status = value!;
        },
        validator: (String? value) {
          if (value!.isEmpty) {
            return "can't empty";
          } else {
            return null;
          }
        },
        items: statusList.map((String val) {
          return DropdownMenuItem<String>(
            value: val,
            child: Text(
              val,
            ),
          );
        }).toList(),
      );

  Widget buildWatering() => DropdownButtonFormField(
        value: watering,
        hint: const Text(
          'choose one',
        ),
        isExpanded: true,
        onChanged: (String? value) {
          watering = value!;
        },
        onSaved: (String? value) {
          watering = value!;
        },
        validator: (String? value) {
          if (value!.isEmpty) {
            return "can't empty";
          } else {
            return null;
          }
        },
        items: wateringList.map((String val) {
          return DropdownMenuItem<String>(
            value: val,
            child: Text(
              val,
            ),
          );
        }).toList(),
      );

  Widget buildSunshine() => DropdownButtonFormField(
        value: sunshine,
        hint: const Text(
          'choose one',
        ),
        isExpanded: true,
        onChanged: (String? value) {
          sunshine = value!;
        },
        onSaved: (String? value) {
          sunshine = value!;
        },
        validator: (String? value) {
          if (value!.isEmpty) {
            return "can't empty";
          } else {
            return null;
          }
        },
        items: sunshineList.map((String val) {
          return DropdownMenuItem<String>(
            value: val,
            child: Text(
              val,
            ),
          );
        }).toList(),
      );

  Widget buildRepot() => DropdownButtonFormField(
        value: repot,
        hint: const Text(
          'choose one',
        ),
        isExpanded: true,
        onChanged: (String? value) {
          repot = value!;
        },
        onSaved: (String? value) {
          repot = value!;
        },
        validator: (String? value) {
          if (value!.isEmpty) {
            return "can't empty";
          } else {
            return null;
          }
        },
        items: repotList.map((String val) {
          return DropdownMenuItem<String>(
            value: val,
            child: Text(
              val,
            ),
          );
        }).toList(),
      );

  Widget buildBlooming() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Période de floraison',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Entrer une période';
          } else {
            return null;
          }
        },
        onChanged: (String? value) {
          blooming = value!;
        },
        maxLength: 120,
      );
}
