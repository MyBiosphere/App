import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:my_biosphere_app/Datamodels/Co2RatioData.dart';

class Co2Ratio extends StatelessWidget {
  const Co2Ratio({
    Key? key,
    required this.co2RatioData,
  }) : super(key: key);

  final List<Co2RatioData> co2RatioData;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(
            left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
        padding: const EdgeInsets.all(20.0 / 2),
        decoration: const BoxDecoration(
            color: Color(0xFF9B2323),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: FittedBox(
            fit: BoxFit.fill,
            child:
              SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <ChartSeries>[
                    StackedBarSeries<Co2RatioData, String>(
                      dataSource: co2RatioData,
                      xValueMapper: (Co2RatioData co2RatioData, _) =>
                          co2RatioData.xData,
                      yValueMapper: (Co2RatioData co2RatioData, _) =>
                          co2RatioData.yData,
                      width: 0.2,
                    ),
                    StackedBarSeries<Co2RatioData, String>(
                      dataSource: co2RatioData,
                      xValueMapper: (Co2RatioData co2RatioData, _) =>
                          co2RatioData.xData,
                      yValueMapper: (Co2RatioData co2RatioData, _) =>
                          co2RatioData.co2,
                        width: 0.2
                    ),
                  ])
            ));
  }
}
