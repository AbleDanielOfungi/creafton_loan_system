import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class CollectionChart extends StatelessWidget {
  CollectionChart({super.key});

  final data = [
    _chart("Mon", 500000),

    _chart("Tue", 800000),

    _chart("Wed", 650000),

    _chart("Thu", 1200000),

    _chart("Fri", 900000),

    _chart("Sat", 1500000),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            "Collection Trend",

            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          Expanded(
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),

              series: [
                LineSeries<_ChartData, String>(
                  dataSource: data,

                  xValueMapper: (d, _) => d.day,

                  yValueMapper: (d, _) => d.amount,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static _ChartData _chart(String day, double amount) {
    return _ChartData(day, amount);
  }
}

class _ChartData {
  final String day;

  final double amount;

  _ChartData(this.day, this.amount);
}
