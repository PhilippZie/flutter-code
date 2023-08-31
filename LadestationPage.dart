import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LadestationPage extends StatefulWidget {
  const LadestationPage({Key? key}) : super(key: key);

  @override
  State<LadestationPage> createState() => _LadestationPageState();
}

class _LadestationPageState extends State<LadestationPage> {
  double _currentSliderValue = 11.0;
  static int currentCapacity = 0;
  static double price = 0.0;
  static double minPower = 0.0;
  static Icon chargingModeIcon = const Icon(
    Icons.battery_charging_full,
    color: Color(0xFFFF7C1F),
    size: 40,
  );
  static String chargingModeString = 'direct';

  @override
  void initState() {
    super.initState();
    readCapacity();
    readMinPower();
    readChargingMode();
  }

  void readChargingMode() async {
    final prefs = await SharedPreferences.getInstance();
    final String? chargingMode = prefs.getString('chargingMode');
    if (chargingMode != null) {
      setState(() {
        switch (chargingMode) {
          case 'ChargingMode.solar':
            chargingModeIcon = const Icon(
              Icons.solar_power,
              color: Colors.yellow,
              size: 40,
            );
            chargingModeString = 'solar';
            break;
          case 'ChargingMode.priceopt':
            chargingModeIcon = const Icon(
              Icons.attach_money,
              color: Colors.green,
              size: 40,
            );
            chargingModeString = 'priceopt';
            break;
          case 'ChargingMode.schedule':
            chargingModeIcon = const Icon(
              Icons.schedule,
              color: Colors.blue,
              size: 40,
            );
            chargingModeString = 'schedule';
            break;
          case 'ChargingMode.direct':
            chargingModeIcon = const Icon(
              Icons.battery_charging_full,
              color: Color(0xFFFF7C1F),
              size: 40,
            );
            chargingModeString = 'direct';
            break;
        }
      });
    }
  }

  void readCapacity() async {
    final prefs = await SharedPreferences.getInstance();
    final int? capacity = prefs.getInt('capacity');
    if (capacity != null) {
      setState(() {
        currentCapacity = capacity;
      });
    }
  }

  void readMinPower() async {
    final prefs = await SharedPreferences.getInstance();
    final double? minimalPower = prefs.getDouble('minPower');
    if (minimalPower != null) {
      setState(() {
        minPower = minimalPower;
      });
    }
  }

  void fetchPrice() async {
    final response = await http.get(Uri.parse("http://placeholder.de/api"));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      price = result['data'][0]['t_price_has_incl_vat'];
    } else {
      throw Exception('Failed to load price');
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchPrice();
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
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
                    Icons.battery_5_bar,
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
                        'Battery capacity',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "$currentCapacity kWh",
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
        Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: 130,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.ev_station,
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
                        'Adjust charging power limit',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        '$_currentSliderValue kW',
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
              Slider(
                value: _currentSliderValue,
                onChanged: (double value) {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _currentSliderValue = value;
                  });
                },
                min: 8,
                max: 22,
                divisions: 28,
                label: _currentSliderValue.toString(),
                activeColor: const Color(0xFF00B7E3),
                inactiveColor: Colors.grey,
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
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
                children: const [
                  Text(
                    'Current charging power',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '10.4 kW',
                    style: TextStyle(
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
        const SizedBox(
          height: 20,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
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
                Icons.electric_car,
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
                    'Minimal charging power',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '$minPower kWh',
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
        const SizedBox(
          height: 20,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
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
              chargingModeIcon,
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Current charging mode',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    chargingModeString,
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
    );
  }
}
