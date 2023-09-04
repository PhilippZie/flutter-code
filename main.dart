import 'package:companion_app_mockup/MqttManager.dart';
import 'package:companion_app_mockup/ResigentPage.dart';
import 'package:companion_app_mockup/TariffPage.dart';
import 'package:flutter/material.dart';

import 'EinstellungenPage.dart';
import 'HomePage.dart';
import 'LadestationPage.dart';
import 'RaumKlimaPage.dart';
import 'StromverbrauchPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Home',
      theme: ThemeData(
        primaryColor: const Color(0xE9E9E9E9),
        //background is dark grey
        backgroundColor: const Color(0xFF32344A),
        fontFamily: 'Roboto',
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  static MqttManager manager = MqttManager();
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MyHomePage.manager.connect();
    Widget page;
    String appBarText;
    switch (selectedIndex) {
      case 0:
        page = const HomePage();
        appBarText = 'Home';
        break;
      case 1:
        page = const LadestationPage();
        appBarText = 'Vehicle';
        break;
      case 2:
        page = const RaumKlimaPage();
        appBarText = 'Room climate';
        break;
      case 3:
        page = const StromverbrauchPage();
        appBarText = 'Power consumption';
        break;
      case 4:
        page = const ResigentPage();
        appBarText = 'Resigent';
        break;
      case 5:
        page = const TariffPage();
        appBarText = 'Tariff';
        break;
      case 6:
        page = const EinstellungenPage();
        appBarText = 'Settings';
        break;
      default:
        page = const HomePage();
        appBarText = 'Home';
    }
    // This method is rerun every time setState is called
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0756AF),
          title: Text(appBarText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              )),
        ),
        drawer: Drawer(
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0x9929B4FF),
              image: DecorationImage(
                image: AssetImage('assets/pic.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Text(
              'company',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 10.0,
                    offset: Offset(5.0, 5.0),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            onTap: () {
              setState(() {
                selectedIndex = 0;
              });
              //to do: navigate to new page
              Navigator.pop(context);
            },
            leading: const Icon(Icons.home),
            title: const Text('Home'),
          ),
          ListTile(
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  selectedIndex = 1;
                });
              },
              leading: const Icon(Icons.electric_car),
              title: const Text('Vehicle')),
          ListTile(
            onTap: () {
              //to do: navigate to new page
              Navigator.pop(context);
              setState(() {
                selectedIndex = 2;
              });
            },
            leading: const Icon(Icons.thermostat),
            title: const Text('Room climate'),
          ),
          ListTile(
            onTap: () {
              //to do: navigate to new page
              Navigator.pop(context);
              setState(() {
                selectedIndex = 3;
              });
            },
            leading: const Icon(Icons.bolt),
            title: const Text('Power consumption'),
          ),
          ListTile(
            onTap: () {
              //to do: navigate to new page
              Navigator.pop(context);
              setState(() {
                selectedIndex = 4;
              });
            },
            leading: const Icon(Icons.electric_meter),
            title: const Text('Resigent'),
          ),
          ListTile(
            onTap: () {
              //to do: navigate to new page
              Navigator.pop(context);
              setState(() {
                selectedIndex = 5;
              });
            },
            leading: const Icon(Icons.attach_money),
            title: const Text('Tariff info'),
          ),
          ListTile(
            onTap: () {
              //to do: navigate to new page
              Navigator.pop(context);
              setState(() {
                selectedIndex = 6;
              });
            },
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
          ),
        ])),
        body: Center(
            child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/beach.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: page,
        )));
  }
}
