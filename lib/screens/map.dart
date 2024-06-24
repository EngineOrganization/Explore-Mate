import 'package:explore_mate/screens/create_organization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
        onMapLongTap: (point) {
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
        },
      )
    );
  }
}