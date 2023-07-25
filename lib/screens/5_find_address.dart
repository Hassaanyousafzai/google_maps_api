import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class FindAddress extends StatefulWidget {
  const FindAddress({super.key});

  @override
  State<FindAddress> createState() => _FindAddressState();
}

class _FindAddressState extends State<FindAddress> {
  TextEditingController searchController = TextEditingController();
  final Completer<GoogleMapController> completer = Completer();
  double latitude = 0, longitude = 0, l1 = 0, l2 = 0;
  var uuid = const Uuid();
  String sessionToken = "12345";
  final List<Marker> _markers = [];
  List<dynamic> places = [];

  CameraPosition initialPosition =
      const CameraPosition(target: LatLng(33.9994409, 71.5179113), zoom: 14);

  onChange() {
    // ignore: unnecessary_null_comparison
    if (sessionToken == null) {
      setState(() {
        sessionToken = uuid.v4();
      });
    }

    getSuggestion(searchController.text);
  }

  getSuggestion(String input) async {
    String myAPI = 'AIzaSyBz9Q8MF47nOwo_p9jWZJjx4JXD9o569M0';
    String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseUrl?input=$input&key=$myAPI&sessiontoken=$sessionToken';

    final response = await http.get(Uri.parse(request));

    print(response.body.toString());
    if (response.statusCode == 200) {
      setState(() {
        places = jsonDecode(response.body)['predictions'];
      });
    } else {
      throw Exception("Couldn't load this data");
    }
  }

  List<Marker> markersList = [
    const Marker(
      markerId: MarkerId('1'),
      position: LatLng(33.9994409, 71.5179113),
      infoWindow: InfoWindow(title: 'ABC Location'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _markers.addAll(markersList);
    searchController.addListener(() {
      onChange();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              markers: Set.of(_markers),
              initialCameraPosition: initialPosition,
              onMapCreated: (GoogleMapController controller) {
                completer.complete(controller);
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
                  child: TextFormField(
                    controller: searchController,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Search Address',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(color: Colors.blue),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: places.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue[50],
                              // border: Border.all(),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                    blurRadius: 10,
                                    color: Colors.grey,
                                    spreadRadius: 1)
                              ]),
                          child: ListTile(
                            onTap: () async {
                              List<Location> locations =
                                  await locationFromAddress(
                                      places[index]['description']);

                              l1 = locations.last.latitude;
                              l2 = locations.last.longitude;

                              CameraPosition cPosition = CameraPosition(
                                  target: LatLng(l1, l2), zoom: 15);

                              GoogleMapController controller =
                                  await completer.future;
                              controller.animateCamera(
                                  CameraUpdate.newCameraPosition(cPosition));

                              markersList.add(
                                const Marker(
                                    markerId: MarkerId('3'),
                                    infoWindow:
                                        InfoWindow(title: 'Searched Location')),
                              );

                              setState(() {
                                places.clear();
                                searchController.clear();
                              });
                            },
                            title: Text(
                              places[index]['description'],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
