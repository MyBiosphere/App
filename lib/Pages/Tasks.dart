import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_biosphere_app/Widgets/NavBar.dart' as NavBar;
import 'package:my_biosphere_app/Datamodels/TaskData.dart';

class Tasks extends StatefulWidget {
  final Map<String, dynamic>? args;
  const Tasks(this.args, {Key? key}) : super(key: key);

  @override
  _Tasks createState() => _Tasks();
}

Future<List<Task>> fetchTasks(token) async {
  final response = await http.get(
    Uri.parse('https://my-biosphere.herokuapp.com/tasks'),
    headers: {
      "Authorization": token,
    },
  );

  if (response.statusCode == 200) {
    List data = jsonDecode(utf8.decode(response.bodyBytes));
    return Task.userTaskList(data);
  }
  else {
    throw Exception('Plant list fetching failed : ' + response.statusCode.toString());
  }
}

Future<Map> sortTasksList(List userTaskList) async {
  Map sortedTasks = {
    "todo": [],
    "done": []
  };
  for( var i = 0 ; i < userTaskList.length; i++ ) {
    if(userTaskList[i].done){
      sortedTasks["done"].add(
          {
            "name":userTaskList[i].name,
            "desc":userTaskList[i].desc,
            "plant":userTaskList[i].plantName,
          }
      );
    }
    else {
      sortedTasks["todo"].add(
          {
            "name":userTaskList[i].name,
            "desc":userTaskList[i].desc,
            "plant":userTaskList[i].plantName,
          }
      );
    }
  }
  return sortedTasks;
}

class _Tasks extends State<Tasks> {
  late Map tasksList = {
    "todo": [],
    "done": []
  };
  bool isLoading = true;

  @override
  initState() {
    super.initState();
    getTasks(widget.args!["userData"]["token"]);
  }

  Future<void> getTasks(token) async {
    List rawTasksList = await fetchTasks(token);
    tasksList = await sortTasksList(rawTasksList);
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

  Map navigationBarData= {};
  Map userData= {};

  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context)?.settings.arguments as Map;
    buttonStatus = arguments["navigationBarData"];
    userData = arguments["userData"];


    return Scaffold(
        body: Column(children: <Widget>[
          Expanded(
            flex: 2,
              child: SafeArea(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 30.0, bottom: 15.0),
                    child: Text(
                      "Taches",
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
              child: ListView.builder(
                itemBuilder: (BuildContext, index){
                  return Card(
                    child: ListTile(
                        leading: const CircleAvatar(),
                        title: Text(tasksList["todo"][index]["name"]),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(tasksList["todo"][index]["plant"]),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(tasksList["todo"][index]["desc"]),
                            ),
                          ],
                        )
                    ),
                  );
                },
                itemCount: tasksList["todo"].length,
                shrinkWrap: true,
                padding: const EdgeInsets.all(5),
                scrollDirection: Axis.vertical,
              )
          ),
          Expanded(
            flex: 2,
            child: SafeArea(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 30.0, bottom: 15.0),
                  child: Text(
                    "Taches réalisées",
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
              flex: 3,
              child: ListView.builder(
                itemBuilder: (BuildContext, index){
                  return Card(
                    child: ListTile(
                        leading: const CircleAvatar(),
                        title: Text(tasksList["done"][index]["name"]),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(tasksList["done"][index]["plant"]),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(tasksList["done"][index]["desc"]),
                            ),
                          ],
                        )
                    ),
                  );
                },
                itemCount: tasksList["done"].length,
                shrinkWrap: true,
                padding: const EdgeInsets.all(5),
                scrollDirection: Axis.vertical,
              )
          ),
          Expanded(flex: 1, child: NavBar.NavigationBar(buttonStatus, userData))
        ]));
  }
}
