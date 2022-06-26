import 'package:flutter/material.dart';
import 'package:my_biosphere_app/Datamodels/PlantData.dart';

class PlantCard extends StatelessWidget {
  Plant plantDetail;

  PlantCard(this.plantDetail, {Key? key});


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        children: [
          ListTile(
            title: Text(
              plantDetail.name,
              style: const TextStyle(color: Colors.green),
            ),
            subtitle: Text(plantDetail.desc, style: const TextStyle(color: Colors.green),),
            trailing: const Icon(Icons.info),
          ),
        ],
      ),
    );
  }
}
