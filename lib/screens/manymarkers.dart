import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ManyMarkers extends StatefulWidget {
  const ManyMarkers({super.key});

  @override
  State<ManyMarkers> createState() => _ManyMarkersState();
}

class _ManyMarkersState extends State<ManyMarkers> {
  final Completer<GoogleMapController> _controller = Completer();
  final List<Marker> _marker = [];
  final List<LatLng> _latlng = [
    LatLng(30.163505, 72.717733),
    LatLng(30.156833, 72.667206),
    LatLng(30.161128, 72.670636),
    LatLng(30.159097, 72.681699),
    LatLng(30.157115, 72.693227),
  ];
  final CameraPosition _keyPosition = CameraPosition(
    target: LatLng(30.163505, 72.717733),
    zoom: 14,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }

  load(){
    for(int i = 0 ; i < _latlng.length ;  i++){
      _marker.add(
        Marker(markerId: MarkerId('1'),
        position: _latlng[i],
        infoWindow: InfoWindow(title: "my location is here"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GoogleMap(initialCameraPosition: _keyPosition,
    onMapCreated: (GoogleMapController controller ){
      _controller.complete(controller);
    },
    markers:Set<Marker>.of(_marker) ,
    ),

    );
  }
}
