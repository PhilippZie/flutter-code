import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'InfluxDB.dart';

class StromverbrauchPage extends StatefulWidget {
  const StromverbrauchPage({Key? key}) : super(key: key);

  @override
  State<StromverbrauchPage> createState() => _StromverbrauchPageState();
}

class _StromverbrauchPageState extends State<StromverbrauchPage> {
  late Future<Widget> lineChart;

  @override
  void initState() {
    super.initState();
    lineChart = buildLineChart();
    InfluxDB().getValues("Wirkenergie_T1");
  }

  final List<Color> gradientColors = [
    const Color(0xFFFFEA00),
    const Color(0xFFFFAE00),
  ];

  /*
   * This method builds the line chart, which displays the power consumption,
   * it awaits the execution of the http request to the InfluxDB
   */
  Future<Widget> buildLineChart() async {
    await InfluxDB().fetchPowerList();
    return LineChart(LineChartData(
        minX: 1,
        maxX: InfluxDB().getPowerList().length.toDouble(),
        minY: 0,
        maxY: InfluxDB().getPowerList().reduce(max).toDouble() + 5,
        titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 20,
                    getTitlesWidget: rightTitleWidget)),
            topTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 20,
                    getTitlesWidget: topTitleWidget)),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: leftTitleWidget)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: bottomTitleWidget,
            ))),
        gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: const Color(0x51080C1E),
                strokeWidth: 1,
              );
            },
            drawVerticalLine: false),
        borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0x51080C1E), width: 1)),
        lineBarsData: [
          LineChartBarData(
            spots: getSpots(),
            isCurved: false,
            gradient: LinearGradient(
              colors: gradientColors,
            ),
            barWidth: 2,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: gradientColors
                      .map((color) => color.withOpacity(0.15))
                      .toList(),
                )),
          )
        ]));
  }

  // bottom title displays the time
  Widget bottomTitleWidget(double value, TitleMeta meta) {
    return const SideTitleWidget(axisSide: AxisSide.bottom, child: Text(""));
  }

  // left title displays the power in W
  Widget leftTitleWidget(double value, TitleMeta meta) {
    const style = TextStyle(
        color: Color(0xFFBDBDBD), fontWeight: FontWeight.bold, fontSize: 12);
    Widget text;
    text = Text("${value.toInt()} W", style: style);
    return SideTitleWidget(axisSide: AxisSide.bottom, child: text);
  }

  // Top and right titles are not used
  Widget rightTitleWidget(double value, TitleMeta meta) {
    return const SideTitleWidget(axisSide: AxisSide.right, child: Text(""));
  }

  Widget topTitleWidget(double value, TitleMeta meta) {
    return const SideTitleWidget(axisSide: AxisSide.top, child: Text(""));
  }

  // returns a list of FlSpots, which are used to display the line chart
  List<FlSpot> getSpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < InfluxDB().getPowerList().length; i++) {
      spots.add(FlSpot(i.toDouble(), InfluxDB().getPowerList()[i].toDouble()));
    }
    return spots;
  }

  /*
  Final build method for the StromverbrauchPage, waits for the lineChart to be
  built and then returns the page. While waiting it displays a CircularProgressIndicator.
   */
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0x512F2F2F).withOpacity(0.6),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.bolt,
                    color: Color(0xFFFFD200),
                    size: 40,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Counter status',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "${InfluxDB().getEnergyKwh().toStringAsFixed(2)} kWh",
                        style: const TextStyle(
                          color: Color(0xFFBDBDBD),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 30,
            ),
            Text(
              "Consumption last 30 min: ",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.75),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0x51080C1E).withOpacity(0.75),
            borderRadius: BorderRadius.circular(20),
          ),
          width: MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.5,
          child: FutureBuilder<Widget>(
            future: lineChart,
            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!;
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        )
      ],
    );
  }
}
