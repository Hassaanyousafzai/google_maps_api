import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddPolyline extends StatefulWidget {
  const AddPolyline({super.key});

  @override
  State<AddPolyline> createState() => _AddPolylineState();
}

class _AddPolylineState extends State<AddPolyline> {
  Set<Polyline> polyline = HashSet<Polyline>();
  List<Marker> markers = [];
  List<LatLng> points = const [
    LatLng(33.984674, 71.525979),
    LatLng(34.002465, 71.521643),
  ];

  final Completer<GoogleMapController> completer = Completer();

  CameraPosition initialPosition =
      const CameraPosition(target: LatLng(33.984674, 71.525979), zoom: 14);

  @override
  void initState() {
    super.initState();

    polyline.add(Polyline(
        polylineId: const PolylineId('1'),
        points: points,
        width: 3,
        color: Colors.orange));

    for (int i = 0; i < points.length; i++) {
      markers.add(Marker(
          markerId: MarkerId(i.toString()),
          position: points[i],
          infoWindow: const InfoWindow(
            title: 'XYZ Location',
            snippet: 'Lorem Lorem',
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        markers: Set.of(markers),
        initialCameraPosition: initialPosition,
        onMapCreated: (GoogleMapController controller) {
          completer.complete(controller);
        },
        polylines: polyline,
      ),
    );
  }
}
