import 'dart:ui';

class Co2RatioData {
  Co2RatioData(this.xData, this.yData, this.co2, this.pointColor, [this.text='']);
  final String xData;
  final num yData;
  final num co2;
  final Color pointColor;
  final String text;
}