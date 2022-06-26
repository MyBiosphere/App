import 'package:flutter/material.dart';

class NavigationBar extends StatefulWidget {
  final Map navigationBarData;
  final Map userData;

  const NavigationBar(this.navigationBarData, this.userData);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  Map buttonStatus = {};

  @override
  Widget build(BuildContext context) {
    buttonStatus = widget.navigationBarData;

    return Container(
        decoration: const BoxDecoration(
          color: Color(0xFF463333),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
                onPressed: () {
                  setState(() {
                    buttonStatus.forEach((key, value) {
                      buttonStatus[key] = Colors.white;
                    });
                    buttonStatus['dashboard'] = const Color(0xFF25832B);
                    Navigator.of(context).pushNamed('/dashboard', arguments: {
                      "navigationBarData": buttonStatus,
                      "userData": widget.userData,
                    });
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.dashboard,
                      color: buttonStatus['dashboard'],
                    ),
                    Text(
                      "Accueil",
                      style: TextStyle(
                        color: buttonStatus['dashboard'],
                      ),
                    ),
                  ],
                )),
            TextButton(
                onPressed: () {
                  setState(() {
                    buttonStatus.forEach((key, value) {
                      buttonStatus[key] = Colors.white;
                    });
                    buttonStatus['tasks'] = const Color(0xFF25832B);
                  });
                  Navigator.of(context).pushNamed('/tasks', arguments: {
                    "navigationBarData": buttonStatus,
                    "userData": widget.userData,
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.task_alt,
                      color: buttonStatus['tasks'],
                    ),
                    Text(
                      "Taches",
                      style: TextStyle(
                        color: buttonStatus['tasks'],
                      ),
                    ),
                  ],
                )),
            TextButton(
                onPressed: () {
                  setState(() {
                    buttonStatus.forEach((key, value) {
                      buttonStatus[key] = Colors.white;
                    });
                    buttonStatus['plants'] = const Color(0xFF25832B);
                  });
                  Navigator.of(context).pushNamed('/plants', arguments: {
                    "navigationBarData": buttonStatus,
                    "userData": widget.userData,
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.eco,
                      color: buttonStatus['plants'],
                    ),
                    Text(
                      "Plantes",
                      style: TextStyle(
                        color: buttonStatus['plants'],
                      ),
                    ),
                  ],
                )),
          ],
        ));
  }
}
