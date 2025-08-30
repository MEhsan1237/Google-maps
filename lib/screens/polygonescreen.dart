import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolyGoneScreen extends StatefulWidget {
  const PolyGoneScreen({super.key});

  @override
  State<PolyGoneScreen> createState() => _PolyGoneScreenState();
}

class _PolyGoneScreenState extends State<PolyGoneScreen> {
  final Completer<GoogleMapController> _controller = Completer();


  final List<LatLng> _latLng = [
    LatLng(30.129427, 72.687323),
    LatLng(30.165651, 72.717575),
    LatLng(30.203181, 72.664668),


  ];
  final Set<Polygon> _polygons = {};
  final CameraPosition _keyCamera = CameraPosition(
    target: LatLng(30.129427, 72.687323),
    zoom: 14,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }


  load() {
    for (int i = 0; i < _latLng.length; i++) {
      _polygons.add(Polygon(polygonId: PolygonId(i.toString()),
          points: _latLng,
        geodesic: true,
        strokeColor: Colors.red,
        strokeWidth: 3,
        fillColor:  Colors.red.shade200
      )
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(initialCameraPosition: _keyCamera,
      mapType:  MapType.normal,
        onMapCreated:  (GoogleMapController controller){
          _controller.complete(controller);
        },
        polygons: Set<Polygon>.of(_polygons),
      ),
    );
  }
}
