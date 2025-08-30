import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolyLineScreen extends StatefulWidget {
  const PolyLineScreen({super.key});

  @override
  State<PolyLineScreen> createState() => _PolyLineScreenState();
}

class _PolyLineScreenState extends State<PolyLineScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final List<Marker> _marker = [];

  final List<LatLng> _latLng = [
    LatLng(30.129427, 72.687323),
    LatLng(30.165651, 72.717575),
    LatLng(30.203181, 72.664668),
    LatLng(30.145309, 72.687483),
    LatLng(30.160496, 72.719418),
    LatLng(30.145999, 72.750954),
    LatLng(30.201215, 72.721015),

  ];
  final Set<Polyline> _polyLine = {};
  final CameraPosition _keyCamera = CameraPosition(
    target: LatLng(30.129427, 72.687323),
    zoom: 14,
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(int i = 0;i <_latLng.length; i++ ){
       _marker.add(Marker(markerId: MarkerId(i.toString()),
         position: _latLng[i],
         infoWindow: InfoWindow(title: "hello this is my location")
       ),

       );
       setState(() {

       });

       _polyLine.add(Polyline(polylineId: PolylineId(i.toString()),
         points: _latLng,
         color: Colors.orangeAccent,


       )
       );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(initialCameraPosition: _keyCamera,
      mapType:  MapType.normal,
        onMapCreated:  (GoogleMapController controller ){
        _controller.complete(controller);
        },
        polylines:  Set<Polyline>.of(_polyLine),
        markers: Set<Marker>.of(_marker),
      ),
    );
  }
}
