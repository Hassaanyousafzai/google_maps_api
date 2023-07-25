import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FindCoordinates extends StatefulWidget {
  const FindCoordinates({super.key});

  @override
  State<FindCoordinates> createState() => _FindCoordinatesState();
}

class _FindCoordinatesState extends State<FindCoordinates> {
  TextEditingController coController = TextEditingController();

  final List<Marker> _marker = [];

  final List<Marker> _markerList = [
    const Marker(
      markerId: MarkerId('1'),
      position: LatLng(33.9994409, 71.5179113),
      infoWindow: InfoWindow(title: 'Peshawar Cantt'),
    ),
    const Marker(
      markerId: MarkerId('2'),
      position: LatLng(34.028872, 71.533497),
      infoWindow: InfoWindow(title: 'Warsak Road'),
    ),
    const Marker(
      markerId: MarkerId('3'),
      position: LatLng(51.528607, -0.4312472),
      infoWindow: InfoWindow(title: 'London'),
    ),
  ];

  @override
  void initState() {
    super.initState();

    _marker.addAll(_markerList);
  }

  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.9994409, 71.5179113),
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: Set.of(_marker),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: InkWell(
                onTap: () async {
                  var text = coController.text.trim();
                  List<String> parts = text.split(",");
                  double? coordinateOne = double.tryParse(parts[0]);
                  double? coordinateTwo = double.tryParse(parts[1]);
                  if (coordinateOne != null && coordinateTwo != null) {
                    GoogleMapController controller = await _controller.future;
                    controller.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(coordinateOne, coordinateTwo),
                          zoom: 16,
                        ),
                      ),
                    );
                  } else {
                    // Invalid coordinates entered
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Invalid Coordinates'),
                        content: const Text(
                            'Please enter valid latitude and longitude.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                  setState(() {});
                },
                child: Container(
                  height: 45,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Text(
                      "Search Coordinates",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: coController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Enter Coordinates',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
