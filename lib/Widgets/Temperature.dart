import 'package:flutter/material.dart';

class Temperature extends StatelessWidget {
  String temperature;
  Color statusColor;
  Temperature(this.temperature, this.statusColor,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(
            left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
        padding: const EdgeInsets.all(20.0 / 2),
        decoration: BoxDecoration(
            color: statusColor,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Column(
          children: [
            const Expanded(
              flex: 1,
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      "Température",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    )),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(20.0 / 1.5),
                child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      temperature + "°c",
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
