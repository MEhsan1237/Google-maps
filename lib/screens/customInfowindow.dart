import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomInfoWindowFile extends StatefulWidget {
  const CustomInfoWindowFile({super.key, });

  @override
  State<CustomInfoWindowFile> createState() => _CustomInfoWindowFileState();
}

class _CustomInfoWindowFileState extends State<CustomInfoWindowFile> {
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  final List<Marker> _markers = [];
  final List<LatLng> _latLng2 = [
    LatLng(30.152409, 72.605276),
    LatLng(30.190212, 72.635486),
    LatLng(30.171962, 72.586774),
  ];
  final CameraPosition _keyPosition2 = CameraPosition(
    target: LatLng(30.152409, 72.605276),
    zoom: 14,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (int i = 0; i < _latLng2.length; i++) {
      _markers.add(Marker(markerId: MarkerId(i.toString()),
        position: _latLng2[i],
        onTap: (){
        _customInfoWindowController.addInfoWindow!(
          Column(children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              width: 400,
              height: 100,
              child: Column(
                children: [
                  Image(image: AssetImage("assets/images/sun.one.png"),
                  width: double.infinity,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 3,),
                  Text("Hello this is the sun picture")

                ],
              ),
            )
          ],),
          _latLng2[i],
        );
        }

      ),

      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[ GoogleMap(
          onTap: (positioned){
            _customInfoWindowController.hideInfoWindow!();
          },
          onCameraMove: (positioned){
            _customInfoWindowController.onCameraMove!();
          },
          initialCameraPosition: _keyPosition2,

          onMapCreated: (GoogleMapController controller) {
            _customInfoWindowController.googleMapController = controller;
          },
          markers: Set<Marker>.of(_markers) ,
        ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 100,
            width: 200,
            offset: 50,
          ),
        ]
        ),

      );
  }
}
