import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Widget> _timeZone = List();
  List<String> cities = ['Delhi', 'New York', 'Riyadh'];
  void _getTime() async {
    Response response = await get(
        'http://api.worldweatheronline.com/premium/v1/tz.ashx?key=08c098a78ebe41d89bf133723192703&q=Pune&format=json');
    print(json.decode(response.body));
    Map<String, dynamic> time = json.decode(response.body);
    print(time['data']['time_zone'][0]['localtime']);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Buddy',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Time Buddy'),
          actions: <Widget>[Icon(Icons.more_vert)],
        ),
        body: Container(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}
