import 'package:flutter/material.dart';
import 'package:my_biosphere_app/Pages/Dashboard.dart';
import 'package:my_biosphere_app/Pages/Tasks.dart';
import 'package:my_biosphere_app/Pages/Plants.dart';
import 'package:my_biosphere_app/Pages/loader.dart';
import 'package:my_biosphere_app/Pages/PlantDetail.dart';
import 'package:my_biosphere_app/Pages/Addplant.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    initialRoute: '/loader',
    routes: {
      "/loader": (context) => Loader(),
      "/dashboard": (context) => Dashboard(ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>),
      "/tasks": (context) => Tasks(ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>),
      "/plants": (context) => Plants(ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>),
      "/plantDetail": (context) => const PlantDetail(),
      "/addPlant": (context) => const AddPlant(),
    },
  ));
}
