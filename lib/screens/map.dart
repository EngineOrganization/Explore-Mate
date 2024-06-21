import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';


class MapScreen extends StatefulWidget {

  @override
  _MapScreenState createState() => _MapScreenState();
}


class _MapScreenState extends State<MapScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YandexMap(),
    );
  }
}