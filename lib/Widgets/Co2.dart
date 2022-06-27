import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:my_biosphere_app/Datamodels/Co2Data.dart';

class Co2 extends StatelessWidget {
  const Co2({
    Key? key,
    required this.co2Data,
  }) : super(key: key);

  final List<Co2Data> co2Data;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(
            left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
        padding: const EdgeInsets.all(20.0 / 2),
        decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Center(
            child: SfCircularChart(
                // title: ChartTitle(text: 'Sales by sales person'),
                legend: Legend(isVisible: false),
                annotations: <CircularChartAnnotation>[
              CircularChartAnnotation(
                  widget: Text(
                      co2Data[0].yData.toStringAsFixed(1) + '%\n'+ co2Data[0].xData,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ))),
            ],
                series: <DoughnutSeries<Co2Data, String>>[
              DoughnutSeries<Co2Data, String>(
                  explode: false,
                  explodeIndex: 0,
                  innerRadius: '75%',
                  dataSource: co2Data,
                  xValueMapper: (Co2Data data, _) => data.xData,
                  yValueMapper: (Co2Data data, _) => data.yData,
                  dataLabelMapper: (Co2Data data, _) => data.text,
                  pointColorMapper: (Co2Data data, _) => data.pointColor,
                  dataLabelSettings: const DataLabelSettings(isVisible: false)),
            ])));
  }
}
