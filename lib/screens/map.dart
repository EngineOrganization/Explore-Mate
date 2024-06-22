import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {

  @override
  _MapScreenState createState() => _MapScreenState();
}


class _MapScreenState extends State<MapScreen> {

  late YandexMapController controller;
  GlobalKey mapKey = GlobalKey();
  Future<bool> get locationPermissionNotGranted async => !(await Permission.location.request().isGranted);

  @override
  void initState() {
    super.initState();
    getPosition();
  }

  void getPosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
    print(position.latitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YandexMap(
        key: mapKey,
        onMapCreated: (YandexMapController yandexMapController) async {
          controller = yandexMapController;
          final mediaQuery = MediaQuery.of(context);
          final height = mapKey.currentContext!.size!.height * mediaQuery.devicePixelRatio;
          final width = mapKey.currentContext!.size!.width * mediaQuery.devicePixelRatio;
          await controller.toggleUserLayer(
              visible: true,
              autoZoomEnabled: true,
              anchor: UserLocationAnchor(
                  course: Offset(1 * width, 0.5 * height),
                  normal: Offset(0.5 * width, 0.5 * height)
              )
          );
        },
        onUserLocationAdded: (UserLocationView view) async {
          return view.copyWith(
            pin: view.pin.copyWith(
              icon: PlacemarkIcon.single(
                PlacemarkIconStyle(image: BitmapDescriptor.fromAssetImage('assets/user.png'))
              )
            ),
              accuracyCircle: view.accuracyCircle.copyWith(
                  fillColor: Colors.green.withOpacity(0.5)
              )
          );
        },
      )
    );
  }
}