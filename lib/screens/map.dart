import 'package:explore_mate/screens/create_organization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {

  @override
  _MapScreenState createState() => _MapScreenState();
}


class _MapScreenState extends State<MapScreen> {

  List<Marker> markers = [];

  late final MapController mapController;
  Future<bool> get locationPermissionNotGranted async => !(await Permission.location.request().isGranted);

  @override
  void initState() {
    super.initState();
    getPosition();
    mapController = MapController();
  }

  void getPosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
    setState(() {
      markers.add(Marker(point: LatLng(position.latitude, position.longitude), child: Icon(Icons.person_pin)));
      mapController.move(LatLng(position.latitude, position.longitude), 14);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return FlutterMap(
      mapController: mapController,
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.engine.explore_mate',
        ),
        MarkerLayer(markers: markers)
      ],
    );
  }
}
