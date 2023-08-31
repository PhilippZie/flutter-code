import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class ResigentPage extends StatefulWidget {
  const ResigentPage({Key? key}) : super(key: key);

  @override
  State<ResigentPage> createState() => _ResigentPageState();
}

class _ResigentPageState extends State<ResigentPage> {
  static int socValue = 50;
  static int energyValue = 0;

  @override
  void initState() {
    super.initState();
    readSOCValue();
    readEnergyValue();
  }

  void saveSOCValue(int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('soc', value);
  }

  void readSOCValue() async {
    final prefs = await SharedPreferences.getInstance();
    final int? soc = prefs.getInt('soc');
    if (soc != null) {
      setState(() {
        socValue = soc;
      });
    }
  }

  void saveEnergyValue(int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('energy', value);
  }

  void readEnergyValue() async {
    final prefs = await SharedPreferences.getInstance();
    final int? energy = prefs.getInt('energy');
    if (energy != null) {
      setState(() {
        energyValue = energy;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Select charging mode:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
                // drop shadow
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(1, 1),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.28,
                decoration: BoxDecoration(
                  color: const Color(0x512F2F2F).withOpacity(0.75),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(child: RadioGroup())),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: TextEditingController(text: socValue.toString()),
                keyboardType: TextInputType.number,
                onSubmitted: (value) {
                  saveSOCValue(int.parse(value));
                  MyHomePage.manager.publish('app/soc', value.toString());
                },
                style: const TextStyle(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(1, 1),
                      blurRadius: 3,
                    ),
                  ],
                  fontSize: 20,
                ),
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(
                      color: Color(0xFFE1E1E1),
                      width: 3.0,
                    ),
                  ),
                  labelText: 'Battery state of charge (%)',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    // drop shadow
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(1, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: TextEditingController(text: energyValue.toString()),
                keyboardType: TextInputType.number,
                onSubmitted: (value) {
                  MyHomePage.manager.publish('app/energy', value.toString());
                  saveEnergyValue(int.parse(value));
                },
                style: const TextStyle(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(1, 1),
                      blurRadius: 3,
                    ),
                  ],
                  fontSize: 20,
                ),
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(
                      color: Color(0xFFE1E1E1),
                      width: 3.0,
                    ),
                  ),
                  labelText: 'Amount of energy to charge (kWh)',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    // drop shadow
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(1, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Select time for next departure:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                // drop shadow
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(1, 1),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const DatePickerExample(),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const []),
            const SizedBox(
              height: 150,
            ),
          ],
        ),
      ),
    );
  }
}

enum ChargingMode { priceopt, direct, solar, schedule }

class RadioGroup extends StatefulWidget {
  const RadioGroup({Key? key}) : super(key: key);

  @override
  State<RadioGroup> createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {
  static ChargingMode? _chargingMode = ChargingMode.direct;

  @override
  void initState() {
    super.initState();
    loadChargingMode();
  }

  void loadChargingMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? chargingMode = prefs.getString('chargingMode');
    if (chargingMode != null) {
      setState(() {
        _chargingMode =
            ChargingMode.values.firstWhere((e) => e.toString() == chargingMode);
      });
    }
  }

  void saveChargingMode(ChargingMode? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('chargingMode', value.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ListTile(
          title: const Text('Price Optimized',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                // drop shadow
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(1, 1),
                    blurRadius: 3,
                  ),
                ],
              )),
          leading: Radio<ChargingMode>(
            value: ChargingMode.priceopt,
            groupValue: _chargingMode,
            fillColor: MaterialStateProperty.all(Colors.white),
            onChanged: (value) {
              setState(() {
                saveChargingMode(value);
                _chargingMode = value;
                MyHomePage.manager
                    .publish('app/chargingMode', value.toString());
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Direct',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                // drop shadow
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(1, 1),
                    blurRadius: 3,
                  ),
                ],
              )),
          leading: Radio<ChargingMode>(
            value: ChargingMode.direct,
            groupValue: _chargingMode,
            fillColor: MaterialStateProperty.all(Colors.white),
            onChanged: (value) {
              setState(() {
                _chargingMode = value;
                saveChargingMode(value);
                MyHomePage.manager
                    .publish('app/chargingMode', value.toString());
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Solar',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                // drop shadow
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(1, 1),
                    blurRadius: 3,
                  ),
                ],
              )),
          leading: Radio<ChargingMode>(
            value: ChargingMode.solar,
            groupValue: _chargingMode,
            fillColor: MaterialStateProperty.all(Colors.white),
            onChanged: (value) {
              setState(() {
                _chargingMode = value;
                saveChargingMode(value);
                MyHomePage.manager
                    .publish('app/chargingMode', value.toString());
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Schedule',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                // drop shadow
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(1, 1),
                    blurRadius: 3,
                  ),
                ],
              )),
          leading: Radio<ChargingMode>(
            value: ChargingMode.schedule,
            groupValue: _chargingMode,
            fillColor: MaterialStateProperty.all(Colors.white),
            onChanged: (value) {
              setState(() {
                _chargingMode = value;
                saveChargingMode(value);
                MyHomePage.manager
                    .publish('app/chargingMode', value.toString());
              });
            },
          ),
        ),
      ],
    );
  }
}

class DatePickerExample extends StatefulWidget {
  const DatePickerExample({super.key});

  @override
  State<DatePickerExample> createState() => _DatePickerExampleState();
}

class _DatePickerExampleState extends State<DatePickerExample> {
  DateTime dateTime = DateTime.now();

  // This function displays a CupertinoModalPopup with a reasonable fixed height
  // which hosts CupertinoDatePicker.
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _DatePickerItem(
            children: <Widget>[
              CupertinoButton(
                // Display a CupertinoDatePicker in dateTime picker mode.
                onPressed: () => _showDialog(
                  CupertinoDatePicker(
                    initialDateTime: dateTime,
                    minimumDate: dateTime,
                    minuteInterval: 1,
                    use24hFormat: true,
                    onDateTimeChanged: (DateTime newDateTime) {
                      HapticFeedback.lightImpact();
                      MyHomePage.manager
                          .publish('app/schedule', newDateTime.toString());
                      setState(() => dateTime = newDateTime);
                    },
                  ),
                ),

                child: Text(
                  DateFormat('yyyy-MM-dd  HH:mm').format(dateTime),
                  style: const TextStyle(
                    fontSize: 32.0,
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(1, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// This class simply decorates a row of widgets.
class _DatePickerItem extends StatelessWidget {
  const _DatePickerItem({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0x512F2F2F).withOpacity(0.75),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}
