import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MapType _currentMapType = MapType.normal;

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

  void changeMapType() {
    setState(() {
      _currentMapType =
          _currentMapType == MapType.hybrid ? MapType.normal : MapType.hybrid;
    });
  }

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
            mapType: _currentMapType,
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
                onTap: changeMapType,
                child: Container(
                  height: 40,
                  width: 180,
                  decoration: _currentMapType == MapType.normal
                      ? BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        )
                      : BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                  child: const Center(
                    child: Text(
                      "Change Map Type",
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
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20),
              child: InkWell(
                onTap: () async {
                  GoogleMapController controller = await _controller.future;
                  controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      const CameraPosition(
                        target: LatLng(51.528607, -0.4312472),
                        zoom: 14,
                      ),
                    ),
                  );
                  setState(() {});
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: _currentMapType == MapType.normal
                      ? BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(30),
                        )
                      : BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                  child: const Center(child: Icon(Icons.my_location)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
