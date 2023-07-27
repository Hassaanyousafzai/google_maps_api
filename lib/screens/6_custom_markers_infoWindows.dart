import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';

class CustomMarkersInfoWindows extends StatefulWidget {
  const CustomMarkersInfoWindows({super.key});

  @override
  State<CustomMarkersInfoWindows> createState() =>
      _CustomMarkersInfoWindowsState();
}

class _CustomMarkersInfoWindowsState extends State<CustomMarkersInfoWindows> {
  CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();
  final Completer<GoogleMapController> completer = Completer();
  final List<Marker> _markers = [];
  List images = [
    'assets/images/car.png',
    'assets/images/house.png',
    'assets/images/maps.png',
    'assets/images/motorbike.png',
    'assets/images/suv.png',
  ];

  List<LatLng> coordinates = const [
    LatLng(33.980093, 71.426601),
    LatLng(33.9872642, 71.4446312),
    LatLng(33.988481, 71.449434),
    LatLng(33.9872023, 71.4644126),
    LatLng(33.9783993, 71.433878)
  ];

  CameraPosition initialPosition =
      const CameraPosition(target: LatLng(33.9874065, 71.4464337), zoom: 14);

  loadData() async {
    for (int i = 0; i < images.length; i++) {
      final Uint8List markerIcon = await getMarkerFromBytes(images[i], 100);

      _markers.add(Marker(
        markerId: MarkerId(i.toString()),
        position: coordinates[i],
        icon: BitmapDescriptor.fromBytes(markerIcon),
        onTap: () {
          customInfoWindowController.addInfoWindow!(
            Container(
              height: 300,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(),
              ),
              child: i % 2 != 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            width: 300,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: const DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: NetworkImage(
                                    'https://images.pexels.com/photos/3989821/pexels-photo-3989821.jpeg?auto=compress&cs=tinysrgb&w=800'),
                                filterQuality: FilterQuality.high,
                              ),
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'ABC Location',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Lorem Lorem Lorem Lorem',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            width: 300,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: const DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: NetworkImage(
                                    'https://images.pexels.com/photos/210474/pexels-photo-210474.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
                                filterQuality: FilterQuality.high,
                              ),
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'XYZ University',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Lorem Lorem Lorem Lorem',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
            ),
            coordinates[i],
          );
        },
      ));
    }

    setState(() {});
  }

  Future<Uint8List> getMarkerFromBytes(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();

    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            markers: Set.of(_markers),
            initialCameraPosition: initialPosition,
            onTap: (position) {
              customInfoWindowController.hideInfoWindow!();
            },
            onMapCreated: (GoogleMapController controller) {
              customInfoWindowController.googleMapController = controller;
            },
          ),
          CustomInfoWindow(
            controller: customInfoWindowController,
            height: 200,
            width: 300,
            offset: 40,
          )
        ],
      ),
    );
  }
}
