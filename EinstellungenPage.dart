import 'package:companion_app_mockup/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EinstellungenPage extends StatefulWidget {
  const EinstellungenPage({Key? key}) : super(key: key);

  @override
  State<EinstellungenPage> createState() => _EinstellungenPageState();
}

class _EinstellungenPageState extends State<EinstellungenPage> {
  static bool checkboxValue = false;
  static int capacityValue = 0;
  static double minPower = 0.0;

  @override
  void initState() {
    super.initState();
    readCapacityValue();
    readMinPower();
    readCheckboxValue();
  }

  void saveCapacityValue(int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('capacity', value);
  }

  void readCapacityValue() async {
    final prefs = await SharedPreferences.getInstance();
    final int? capacity = prefs.getInt('capacity');
    if (capacity != null) {
      setState(() {
        capacityValue = capacity;
      });
    }
  }

  void saveMinPower(double value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('minPower', value);
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

  void readCheckboxValue() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? checkbox = prefs.getBool('checkbox');
    if (checkbox != null) {
      setState(() {
        checkboxValue = checkbox;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 1.0,
          height: MediaQuery.of(context).size.height * 0.1,
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SizedBox(
              width: 10,
            ),
            const MyCheckboxWidget(),
            Wrap(
              direction: Axis.horizontal,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: const Text(
                    'Share anonymized data',
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
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
        Divider(
          color: const Color(0xFF707070).withOpacity(0.5),
          thickness: 2,
          indent: 20,
          endIndent: 20,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            SizedBox(
              width: 10,
            ),
            Text(
              'Electric vehicle:',
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
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextField(
            keyboardType: TextInputType.number,
            controller: TextEditingController(text: capacityValue.toString()),
            onSubmitted: (value) {
              saveCapacityValue(int.parse(value));

              MyHomePage.manager.publish('app/capacity', value.toString());
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
              labelText: 'Battery capacity (kWh)',
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
            keyboardType: TextInputType.number,
            controller: TextEditingController(text: minPower.toString()),
            onSubmitted: (value) {
              saveMinPower(double.parse(value));
              MyHomePage.manager.publish('app/minPower', value.toString());
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
              labelText: 'Minimal charging power (kW)',
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
        Divider(
          color: const Color(0xFF707070).withOpacity(0.5),
          thickness: 2,
          indent: 20,
          endIndent: 20,
        ),
      ],
    );
  }
}

class MyCheckboxWidget extends StatefulWidget {
  const MyCheckboxWidget({super.key});

  @override
  _MyCheckboxWidgetState createState() => _MyCheckboxWidgetState();
}

class _MyCheckboxWidgetState extends State<MyCheckboxWidget> {
  bool isChecked = false;
  final String checkboxKey = 'checkboxkey';

  @override
  void initState() {
    super.initState();
    loadCheckboxValue();
  }

  void loadCheckboxValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isChecked = prefs.getBool(checkboxKey) ?? false;
    });
  }

  void saveCheckboxValue(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(checkboxKey, value);
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.2,
      child: Checkbox(
        checkColor: Colors.white,
        value: isChecked,
        onChanged: (value) {
          saveCheckboxValue(value!);
          setState(() {
            isChecked = value;
          });
        },
      ),
    );
  }
}
