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
    print(position.latitude);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: LatLng(51.509364, -0.128928),
        initialZoom: 9.2,
        onLongPress: (TapPosition position, LatLng lat) {
          showModalBottomSheet(
              context: context,
              builder: (context) => Container(
                height: height * 0.2,
                width: width * 0.6,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02, top: height * 0.02),
                      child: ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.home_work_outlined),
                            Text('Добавить организацию')
                          ],
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateOrganizationScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(20),
                            backgroundColor: Colors.white,
                            textStyle: GoogleFonts.roboto(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                            iconColor: Colors.black,
                            foregroundColor: Colors.black
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02, top: height * 0.02),
                      child: ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.comment),
                            Text('Оставить комментарий')
                          ],
                        ),
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(20),
                            backgroundColor: Colors.white,
                            textStyle: GoogleFonts.roboto(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                            iconColor: Colors.black,
                            foregroundColor: Colors.black
                        ),
                      ),
                    )
                  ],
                ),
              )
          );
        }
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.engine.explore_mate',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(30, 40),
              width: 80,
              height: 80,
              child: FlutterLogo(),
            ),
          ],
        ),
      ],
    );
  }
}
