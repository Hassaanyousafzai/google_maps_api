import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddPolygons extends StatefulWidget {
  const AddPolygons({super.key});

  @override
  State<AddPolygons> createState() => _AddPolygonsState();
}

class _AddPolygonsState extends State<AddPolygons> {
  Set<Polygon> polygons = HashSet<Polygon>();
  List<LatLng> points = const [
    LatLng(33.984674, 71.525979),
    LatLng(34.002465, 71.521643),
    LatLng(34.014276, 71.553960),
    LatLng(34.004173, 71.554990),
    LatLng(33.984674, 71.525979)
  ];

  final Completer<GoogleMapController> completer = Completer();

  CameraPosition initialPosition =
      const CameraPosition(target: LatLng(33.984674, 71.525979), zoom: 14);

  @override
  void initState() {
    super.initState();

    polygons.add(Polygon(
      polygonId: const PolygonId('1'),
      points: points,
      geodesic: true,
      fillColor: Colors.red.withOpacity(0.2),
      strokeWidth: 3,
      strokeColor: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: initialPosition,
        onMapCreated: (GoogleMapController controller) {
          completer.complete(controller);
        },
        polygons: polygons,
      ),
    );
  }
}
