import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Marker> _marker = [];
  final List<Marker> _list = [
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(33.6996, 73.0362),
      infoWindow: InfoWindow(title: "my location"),
    ),
    Marker(
      markerId: MarkerId('2'),
      position: LatLng(33.6057, 73.1317),
      infoWindow: InfoWindow(title: "my user"),
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _marker.addAll(_list);
  }

  final Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _keyCamera = CameraPosition(
    target: LatLng(33.6057, 73.1317),
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _keyCamera,
        mapType: MapType.normal,
        myLocationEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(_marker),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          GoogleMapController controller = await _controller.future;
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(33.6996, 73.0362),
                zoom: 14

              ),

            ),
          );
        },
        child: Icon(Icons.location_disabled_outlined),
      ),
    );
  }
}
