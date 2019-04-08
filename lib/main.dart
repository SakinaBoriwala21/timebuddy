import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();
  List<String> cities = List();
  List<int> _currentHour = List();
  List<int> _currentMinute = List();

  void _getTime(String city) async {
    Response response = await get(
        'http://api.worldweatheronline.com/premium/v1/tz.ashx?key=08c098a78ebe41d89bf133723192703&q=$city&format=json');
    Map<String, dynamic> responseBody = Map();
    responseBody = json.decode(response.body)['data'];
    if (!responseBody.containsKey('error')) {
      DateTime time = DateTime.parse(
          json.decode(response.body)['data']['time_zone'][0]['localtime']);
      int hour = time.hour;
      int minute = time.minute;
      setState(() {
        _currentHour.add(hour);
        _currentMinute.add(minute);
        cities.add(city);
      });
    }
  }

  dynamic createAlertDialog() {
    final context = navigatorKey.currentState.overlay.context;

    TextEditingController customController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Enter the City'),
              content: TextField(controller: customController),
              actions: [
                MaterialButton(
                    elevation: 5.0,
                    child: Text('Go'),
                    onPressed: () {
                      Navigator.of(context)
                          .pop(customController.text.toString());
                    })
              ]);
        });
  }

  List<Widget> _eachCell(int count, int index) {
    List<Widget> cells = List();
    for (int i = 0; i < count; i++) {
      int hour = _currentHour[i] + index;
      String minute = _currentMinute[i].toString();
      cells.add(Padding(
          padding: EdgeInsets.only(top: 75.0, bottom: 15),
          child: Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.white,
              child: Text(
                  hour <= 23
                      ? hour.toString() + ':' + minute
                      : (hour - 23).toString() + ':' + minute,
                  style: TextStyle(color: Colors.black, fontSize: 20)))));
    }
    return cells;
  }

  List<Widget> _cityInfo() {
    List<Widget> _eachCity = List();
    for (int i = 0; i < cities.length; i++) {
      _eachCity.add(Padding(
          padding: EdgeInsets.only(bottom: 90.0, left: 20),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(cities[i],
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue)),
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    cities.removeAt(i);
                  });
                })
          ])));
    }
    return _eachCity;
  }

  Widget _timeZoneUsingListView() {
    return Column(children: <Widget>[
      Expanded(
          child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 24,
        itemBuilder: (BuildContext context, int index) {
          return Column(children: _eachCell(cities.length, index));
        }
      ))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Time Buddy',
      theme: ThemeData(
          iconTheme: IconThemeData(color: Colors.blue),
          dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)))),
      home: Scaffold(
        appBar: AppBar(title: Text('Time Buddy')),
        body: Stack(children: <Widget>[
          _timeZoneUsingListView(),
          Column(children: _cityInfo()),
          Padding(
              padding: EdgeInsets.only(top: 75, left: 190),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                        color: Colors.blue,
                        width: 3,
                        style: BorderStyle.solid)),
                height: cities.length * 120.toDouble(),
                width: cities.length == 0 ? 0 : 80.0,
                padding: EdgeInsetsDirectional.only(top: 400.0),
              ))
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (cities.length <= 3) {
              createAlertDialog().then((city) {
                _getTime(city);
              });
            }
          },
          child: Icon(Icons.add, color: Colors.blue),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
