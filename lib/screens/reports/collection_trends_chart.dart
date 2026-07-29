// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../providers/reports_provider.dart';

// class CollectionsTrendChart extends StatefulWidget {
//   const CollectionsTrendChart({super.key});

//   @override
//   State<CollectionsTrendChart> createState() =>
//       _CollectionsTrendChartState();
// }

// class _CollectionsTrendChartState
//     extends State<CollectionsTrendChart> {

//   int selectedPeriod = 0;

//   @override
//   Widget build(BuildContext context) {

//     return Card(

//       elevation: 2,

//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(18),
//       ),

//       child: Padding(

//         padding: const EdgeInsets.all(20),

//         child: Consumer<ReportsProvider>(
//           builder: (context, provider, child) {

//             List<double> values = [];

//             List<String> labels = [];

//             switch (selectedPeriod) {

//               case 0:

//                 values = provider.dailyCollectionTrend;

//                 labels = provider.dailyLabels;

//                 break;

//               case 1:

//                 values = provider.weeklyCollectionTrend;

//                 labels = provider.weeklyLabels;

//                 break;

//               case 2:

//                 values = provider.monthlyCollectionTrend;

//                 labels = provider.monthlyLabels;

//                 break;

//               case 3:

//                 values = provider.yearlyCollectionTrend;

//                 labels = provider.yearlyLabels;

//                 break;
//             }

//             return Column(

//               crossAxisAlignment:
//                   CrossAxisAlignment.start,

//               children: [

//                 Row(

//                   children: [

//                     const Icon(
//                       Icons.show_chart,
//                       color: Colors.green,
//                     ),

//                     const SizedBox(width: 10),

//                     const Text(
//                       "Collections Trend",
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),

//                     const Spacer(),

//                     DropdownButton<int>(

//                       value: selectedPeriod,

//                       items: const [

//                         DropdownMenuItem(
//                           value: 0,
//                           child: Text("Daily"),
//                         ),

//                         DropdownMenuItem(
//                           value: 1,
//                           child: Text("Weekly"),
//                         ),

//                         DropdownMenuItem(
//                           value: 2,
//                           child: Text("Monthly"),
//                         ),

//                         DropdownMenuItem(
//                           value: 3,
//                           child: Text("Yearly"),
//                         ),
//                       ],

//                       onChanged: (value) {

//                         setState(() {

//                           selectedPeriod = value!;

//                         });

//                       },
//                     )
//                   ],
//                 ),

//                 const SizedBox(height: 25),

//                 SizedBox(

//                   height: 350,

//                   child: LineChart(

//                     LineChartData(

//                       gridData: FlGridData(show: true),

//                       borderData: FlBorderData(show: false),

//                       minY: 0,

//                       lineTouchData:
//                           LineTouchData(enabled: true),

//                       titlesData: FlTitlesData(

//                         topTitles: AxisTitles(
//                           sideTitles:
//                               SideTitles(showTitles: false),
//                         ),

//                         rightTitles: AxisTitles(
//                           sideTitles:
//                               SideTitles(showTitles: false),
//                         ),

//                         leftTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: true,
//                             reservedSize: 60,
//                           ),
//                         ),

//                         bottomTitles: AxisTitles(

//                           sideTitles: SideTitles(

//                             showTitles: true,

//                             reservedSize: 35,

//                             interval: 1,

//                             getTitlesWidget:
//                                 (value, meta) {

//                               if (value.toInt() >=
//                                   labels.length) {
//                                 return const SizedBox();
//                               }

//                               return Padding(

//                                 padding:
//                                     const EdgeInsets.only(
//                                         top: 8),

//                                 child: Text(

//                                   labels[value.toInt()],

//                                   style: const TextStyle(
//                                       fontSize: 11),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),

//                       lineBarsData: [

//                         LineChartBarData(

//                           isCurved: true,

//                           color: Colors.green,

//                           barWidth: 4,

//                           dotData: FlDotData(
//                             show: true,
//                           ),

//                           belowBarData:
//                               BarAreaData(show: true),

//                           spots: List.generate(

//                             values.length,

//                             (index) => FlSpot(
//                               index.toDouble(),
//                               values[index],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 15),

//                 Row(

//                   mainAxisAlignment:
//                       MainAxisAlignment.spaceEvenly,

//                   children: [

//                     _summary(
//                       "Highest",
//                       values.isEmpty
//                           ? 0
//                           : values.reduce(
//                               (a, b) => a > b ? a : b),
//                     ),

//                     _summary(
//                       "Lowest",
//                       values.isEmpty
//                           ? 0
//                           : values.reduce(
//                               (a, b) => a < b ? a : b),
//                     ),

//                     _summary(
//                       "Average",
//                       values.isEmpty
//                           ? 0
//                           : values.reduce((a, b) => a + b) /
//                               values.length,
//                     ),
//                   ],
//                 )
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _summary(
//       String title,
//       double amount,
//       ) {

//     return Column(

//       children: [

//         Text(
//           title,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),

//         const SizedBox(height: 5),

//         Text(
//           "UGX ${amount.toStringAsFixed(0)}",
//           style: const TextStyle(
//             fontSize: 16,
//             color: Colors.green,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }
// }