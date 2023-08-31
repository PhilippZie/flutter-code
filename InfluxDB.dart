import 'dart:convert';

import 'package:http/http.dart' as http;

class InfluxDB {
  String database = 'sensor_data';
  late int timestampInNanoseconds;
  late String time;
  late String time2;
  static double temperatureOffice = 0.0;
  static double humidityOffice = 0.0;
  static double temperatureHub = 0.0;
  static double humidityHub = 0.0;
  static double energyT1 = 0.0;
  static int power = 0;
  static List<int> powerList = [];
  static List<String> timestampList = [];
  static List<double> prices24Hours = [];
  static double priceNow = 0.0;

  double getTemperatureOffice() {
    return temperatureOffice;
  }

  double getHumidityOffice() {
    return humidityOffice;
  }

  double getTemperatureHub() {
    return temperatureHub;
  }

  double getHumidityHub() {
    return humidityHub;
  }

  double getEnergyKwh() {
    return energyT1 / 1000;
  }

  int getPower() {
    return power;
  }

  List<int> getPowerList() {
    return powerList;
  }

  List<double> getPriceList() {
    return prices24Hours;
  }

  double getPrice() {
    return priceNow;
  }

  /*
   * Method for getting a specific value from the database,
   * needs to be passed as a parameter
   */
  void getValues(String measurement) async {
    timestampInNanoseconds =
        (DateTime.now().microsecondsSinceEpoch - 300010000) * 1000;
    time = timestampInNanoseconds.toString();
    final queryParameters = {
      'db': database,
      'q': 'SELECT value FROM $measurement WHERE time >= $time LIMIT 1',
    };
    final uri = Uri.http('database:port', '/query', queryParameters);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      var dataValue =
          (data['results'][0]['series'][0]['values'][0][1]).toDouble();
      switch (measurement) {
        case "temperature":
          temperatureOffice = dataValue;
          break;
        case "humidity":
          humidityOffice = dataValue;
          break;
        case "temperature_hub":
          temperatureHub = dataValue;
          break;
        case "humidity_hub":
          humidityHub = dataValue;
          break;
        case "Wirkenergie_T1":
          energyT1 = dataValue;
          break;
        case "Wirkleistung":
          power = dataValue.toInt();
          break;
        default:
          throw Exception('Failed to fetch data from InfluxDB');
      }
    }
  }

  /*
   * Method for getting a list of the power values of the last 30 minutes
   */
  Future<void> fetchPowerList() async {
    powerList.clear();
    timestampList.clear();
    timestampInNanoseconds =
        (DateTime.now().microsecondsSinceEpoch - 1800000100) * 1000;
    time = timestampInNanoseconds.toString();
    final queryParameters = {
      'db': database,
      'q': 'SELECT * FROM Wirkleistung WHERE time >= $time',
    };
    final uri = Uri.http('database:port', '/query', queryParameters);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      for (int i = 0;
          i < data['results'][0]['series'][0]['values'].length;
          i++) {
        powerList
            .add((data['results'][0]['series'][0]['values'][i][1]).toInt());
        timestampList
            .add((data['results'][0]['series'][0]['values'][i][0]).toString());
      }
    } else {
      throw Exception('Failed to fetch data from InfluxDB');
    }
  }

  Future<void> requestPrices() async {
    prices24Hours.clear();

    final response = await http.get(Uri.parse("http://placeholder/api"));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      for (int i = 0; i < 24; i++) {
        prices24Hours.add(result['data'][i]['e_price_epex_excl_vat']);
      }
    } else {
      throw Exception('Failed to load price');
    }
  }

  Future<void> requestPriceNow() async {
    final response = await http.get(Uri.parse("http://placeholder/api"));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      priceNow = result['data'][DateTime.now().hour]['e_price_epex_excl_vat'];
    } else {
      throw Exception('Failed to load price');
    }
  }
}
