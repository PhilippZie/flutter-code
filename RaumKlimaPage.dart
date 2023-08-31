import 'package:flutter/material.dart';
import 'InfluxDB.dart';

class RaumKlimaPage extends StatelessWidget {
  const RaumKlimaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InfluxDB().getValues("temperature");
    InfluxDB().getValues("humidity");
    InfluxDB().getValues("temperature_hub");
    InfluxDB().getValues("humidity_hub");

    return ListView(
      //mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            SizedBox(width: 40),
            Text("Office", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold, shadows: [
              Shadow(
                color: Color(0xFF5A5A5A),
                offset: Offset(1, 1),
                blurRadius: 5,
              ),
            ])),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: const Color(0x512F2F2F).withOpacity(0.6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: const Offset(2, 2),
                      blurRadius: 5,
                    ),
                  ],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25),
                  )),
              margin: const EdgeInsets.all(10.0),
              width: 150.0,
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(Icons.thermostat, color: Colors.orangeAccent),
                  const SizedBox(width: 5),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Temperature',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${InfluxDB().getTemperatureOffice().toStringAsPrecision(3)}°C",
                          style: const TextStyle(
                            color: Color(0xFFBDBDBD),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: const Color(0x512F2F2F).withOpacity(0.6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: const Offset(2, 2),
                      blurRadius: 5,
                    ),
                  ],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25),
                  )),
              margin: const EdgeInsets.all(10.0),
              width: 150.0,
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(Icons.water_drop_outlined,
                      color: Colors.lightBlueAccent),
                  const SizedBox(width: 5),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Humidity',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${InfluxDB().getHumidityOffice().toStringAsPrecision(3)}%",
                          style: const TextStyle(
                            // bold, white text
                            color: Color(0xFFBDBDBD),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ])
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            SizedBox(width: 40),
            Text("Hub", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold, shadows: [
              Shadow(
                color: Color(0xFF5A5A5A),
                offset: Offset(1, 1),
                blurRadius: 5,
              ),
            ])),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: const Color(0x512F2F2F).withOpacity(0.6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: const Offset(2, 2),
                      blurRadius: 5,
                    ),
                  ],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25),
                  )),
              margin: const EdgeInsets.all(10.0),
              width: 150.0,
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(Icons.thermostat, color: Colors.orangeAccent),
                  const SizedBox(width: 5),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Temperature',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${InfluxDB().getTemperatureHub().toStringAsPrecision(3)}°C",
                          style: const TextStyle(
                            color: Color(0xFFBDBDBD),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: const Color(0x512F2F2F).withOpacity(0.6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: const Offset(2, 2),
                      blurRadius: 5,
                    ),
                  ],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25),
                  )),
              margin: const EdgeInsets.all(10.0),
              width: 150.0,
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(Icons.water_drop_outlined,
                      color: Colors.lightBlueAccent),
                  const SizedBox(width: 5),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Humidity',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${InfluxDB().getHumidityHub().toStringAsPrecision(3)}%",
                          style: const TextStyle(
                            // bold, white text
                            color: Color(0xFFBDBDBD),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ])
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
