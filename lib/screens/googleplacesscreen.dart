import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({super.key});

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  final CustomInfoWindowController _customInfoWindowController =
  CustomInfoWindowController();

  GooglePlace? googlePlace;
  List<AutocompletePrediction> predictions = [];
  final TextEditingController searchController = TextEditingController();

  final List<Marker> _markers = [];
  CameraPosition _initialPosition =
  const CameraPosition(target: LatLng(30.152409, 72.605276), zoom: 14);

  @override
  void initState() {
    super.initState();
    googlePlace = GooglePlace("AIzaSyDWGXgV5eYZE_r6v3KQVnPoQ2hlUa7gD6c"); // put your key here
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace!.autocomplete.get(
      value,
      language: "en",
      region: "pk", // use your country code ("us", "in", etc.)
    );

    // 👇 These will show in your debug console
    print("Autocomplete response status: ${result?.status}");
    print("Autocomplete predictions: ${result?.predictions}");

    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }


  Future<void> moveToPlace(String placeId, String description) async {
    var details = await googlePlace!.details.get(placeId);
    if (details != null &&
        details.result != null &&
        details.result!.geometry != null) {
      var loc = details.result!.geometry!.location!;
      LatLng pos = LatLng(loc.lat!, loc.lng!);

      setState(() {
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId(placeId),
            position: pos,
            onTap: () {
              _customInfoWindowController.addInfoWindow!(
                Container(
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.asset(
                          "assets/images/sun.one.png",
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(description,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                pos,
              );
            },
          ),
        );

        _initialPosition = CameraPosition(target: pos, zoom: 15);
      });

      _customInfoWindowController.googleMapController
          ?.animateCamera(CameraUpdate.newLatLng(pos));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onTap: (pos) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (pos) {
              _customInfoWindowController.onCameraMove!();
            },
            initialCameraPosition: _initialPosition,
            onMapCreated: (controller) {
              _customInfoWindowController.googleMapController = controller;
            },
            markers: Set<Marker>.of(_markers),
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 100,
            width: 200,
            offset: 50,
          ),

          // Search box
          Positioned(
            top: 40,
            left: 15,
            right: 15,
            child: Column(
              children: [
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(8),
                  child: TextFormField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: "Search location...",
                      border: InputBorder.none,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        autoCompleteSearch(value);
                      } else {
                        setState(() {
                          predictions = [];
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 5),

                // Suggestions list
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(predictions[index].description!),
                      onTap: () {
                        moveToPlace(predictions[index].placeId!,
                            predictions[index].description!);
                        setState(() {
                          predictions = [];
                          searchController.text =
                          predictions[index].description!;
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
