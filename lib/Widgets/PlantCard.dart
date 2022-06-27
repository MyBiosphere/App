import 'package:flutter/material.dart';
import 'package:my_biosphere_app/Datamodels/PlantData.dart';

class PlantCard extends StatelessWidget {
  Plant plantDetail;
  Color textColor = Colors.green;
  PlantCard(this.plantDetail, {Key? key});

  @override
  Widget build(BuildContext context) {
    textColor = plantDetail.status == "Saine" ? Colors.green : Colors.red;
    return Card(
      elevation: 4,
      child: Column(
        children: [
          ListTile(
            title: Text(
              plantDetail.name,
              style: TextStyle(
                  color: textColor
              ),
            ),
            subtitle: Text(plantDetail.desc, style: TextStyle(color: textColor),),
            trailing: const Icon(Icons.info),
          ),
        ],
      ),
    );
  }
}
