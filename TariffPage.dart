import 'dart:math';

import 'package:companion_app_mockup/InfluxDB.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TariffPage extends StatefulWidget {
  const TariffPage({Key? key}) : super(key: key);

  @override
  State<TariffPage> createState() => _TariffPageState();
}

class _TariffPageState extends State<TariffPage> {
  late Future<Widget> lineChart;
  late Future<Text> priceTag;

  @override
  void initState() {
    lineChart = buildLineChart();
    priceTag = buildPriceTag();
    super.initState();
  }

  final List<Color> gradientColors = [
    const Color(0xFF0FD100),
    const Color(0xFF519E01),
    const Color(0xFF0FD100),
    const Color(0xFF519E01),
    const Color(0xFF0FD100),
  ];

  Future<Widget> buildLineChart() async {
    await InfluxDB().requestPrices();
    List<double> pricelist = InfluxDB().getPriceList();
    return LineChart(LineChartData(
        minX: 0,
        maxX: pricelist.length.toDouble() - 1,
        minY: pricelist.reduce(min).toDouble() - 1.0,
        maxY: pricelist.reduce(max).toDouble() + 1.0,
        backgroundColor: Colors.transparent,
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                return LineTooltipItem(
                  '${flSpot.y.toStringAsFixed(2)} ct / kWh \n${flSpot.x.toInt()}:00 h',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
            tooltipBgColor: const Color(
              0xFF2C2C2C,
            ).withOpacity(0.8),
          ),
          handleBuiltInTouches: true,
        ),
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
              interval: 6,
              getTitlesWidget: bottomTitleWidget,
            ))),
        gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.transparent,
                strokeWidth: 1,
              );
            },
            drawVerticalLine: false),
        borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.transparent, width: 1)),
        lineBarsData: [
          LineChartBarData(
            spots: getSpots(),
            isCurved: true,
            gradient: LinearGradient(
              colors: gradientColors,
            ),
            barWidth: 3,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: gradientColors
                      .map((color) => color.withOpacity(0.35))
                      .toList(),
                )),
          )
        ]));
  }

  Future<Text> buildPriceTag() async {
    await InfluxDB().requestPriceNow();
    double price = InfluxDB().getPrice();
    return Text(
      "${price.toStringAsFixed(2)} ct /  kWh",
      style: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
    );
  }

  Widget bottomTitleWidget(double value, TitleMeta meta) {
    const style = TextStyle(
        color: Color(0xFFBDBDBD), fontWeight: FontWeight.bold, fontSize: 12);
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text("00:00", style: style);
        break;
      case 6:
        text = const Text("06:00", style: style);
        break;
      case 12:
        text = const Text("12:00", style: style);
        break;
      case 18:
        text = const Text("18:00", style: style);
        break;
      case 23:
        text = const Text("23:00", style: style);
        break;
      default:
        text = const Text("");
    }
    return SideTitleWidget(axisSide: AxisSide.bottom, child: text);
  }

  // left title displays the power in W
  Widget leftTitleWidget(double value, TitleMeta meta) {
    const style = TextStyle(
        color: Color(0xFFBDBDBD), fontWeight: FontWeight.bold, fontSize: 12);
    Widget text;
    text = Text("${value.toInt()} €", style: style);
    return SideTitleWidget(axisSide: AxisSide.bottom, child: text);
  }

  // Top and right titles are not used
  Widget rightTitleWidget(double value, TitleMeta meta) {
    return const SideTitleWidget(axisSide: AxisSide.right, child: Text(""));
  }

  Widget topTitleWidget(double value, TitleMeta meta) {
    return const SideTitleWidget(axisSide: AxisSide.top, child: Text(""));
  }

  List<FlSpot> getSpots() {
    List<FlSpot> spots = [];
    List<double> priceData = InfluxDB().getPriceList();
    for (int i = 0; i < 24; i++) {
      spots.add(FlSpot(i.toDouble(), priceData[i]));
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    List<double> priceData = InfluxDB().getPriceList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.75,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0x512F2F2F).withOpacity(0.75),
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
                Icons.attach_money,
                color: Color(0xFF00B212),
                size: 40,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Current market price',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  FutureBuilder<Widget>(
                    future: priceTag,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!;
                      } else {
                        return const Text(
                          'Loading...',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          const SizedBox(
            width: 30,
          ),
          Text(
            'Price development for today:',
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
        ]),
        const SizedBox(
          height: 5,
        ),
        Container(
            decoration: BoxDecoration(
              color: const Color(0x51080C1E).withOpacity(0.75),
              borderRadius: BorderRadius.circular(20),
            ),
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.3,
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
            )),
      ],
    );
  }
}
