import 'package:flutter/material.dart';
import 'package:my_biosphere_app/Datamodels/PlantData.dart';

class PlantDetailTile extends StatelessWidget {
  Map detailData;

  PlantDetailTile(this.detailData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(
            left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
        padding: const EdgeInsets.all(20.0 / 2),
        decoration: BoxDecoration(
            color: detailData["color"],
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Column(
          children: [
             Expanded(
              flex: 1,
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      detailData["text"],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    )),
            ),
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(20.0 / 1.5),
                child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      detailData["value"],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    )),
              )
            )
          ],
        ));
  }
}
