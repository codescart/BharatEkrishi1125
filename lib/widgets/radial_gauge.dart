import 'package:bharatekrishi/widgets/GaugeContent/gauge_content.dart';
import 'package:flutter/material.dart';

class SpeedMeter extends StatelessWidget {
  final dynamic currentvalue;
  const SpeedMeter({Key? key, this.currentvalue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return PrettyGauge(
        gaugeSize: height * 0.07,
        segments: [
          GaugeSegment('Low', 30, Colors.green),
          GaugeSegment('Medium', 20, Colors.orangeAccent),
          GaugeSegment('High', 50, Colors.red),
        ],
        currentValue: currentvalue,
        showMarkers: false
    );
  }
}

class FuelMeter extends StatelessWidget {
  final dynamic currentvalue;
  const FuelMeter({Key? key, this.currentvalue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return PrettyGauge(
        gaugeSize: height * 0.07,
        segments: [
          GaugeSegment('Low', 20, Colors.red),
          GaugeSegment('Medium', 60, Colors.orangeAccent),
          GaugeSegment('High', 20, Colors.green),
        ],
        currentValue:currentvalue,
        showMarkers: false
    );
  }
}
