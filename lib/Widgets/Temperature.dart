import 'package:flutter/material.dart';

class Temperature extends StatelessWidget {
  const Temperature({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(
            left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
        padding: const EdgeInsets.all(20.0 / 2),
        decoration: const BoxDecoration(
            color: Color(0xFFA16814),
            borderRadius: BorderRadius.all(Radius.circular(20))),
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
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(20.0 / 1.5),
                child: const FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      "42°",
                      style: TextStyle(
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
