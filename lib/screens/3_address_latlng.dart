import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_api/components/row_component.dart';

import '2_latlng_address.dart';

class AddressLatLng extends StatefulWidget {
  const AddressLatLng({super.key});

  @override
  State<AddressLatLng> createState() => _AddressLatLngState();
}

class _AddressLatLngState extends State<AddressLatLng> {
  TextEditingController addressController = TextEditingController();
  String? latitude, longitude;
  bool flag = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Address - Coordinates"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 84, 201, 207),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            flag == true
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.12,
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                  ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: addressController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter Address',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
            flag == true
                ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.height * 0.8,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(220, 237, 200, 1),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 5,
                          )
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          RowComponent(
                              text: "Latitude: ", value: latitude.toString()),
                          RowComponent(
                              text: "Longitude: ", value: longitude.toString()),
                        ],
                      ),
                    ),
                  )
                : Container(),
            const SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () async {
                List<Location> locations =
                    await locationFromAddress(addressController.text);

                latitude = locations.last.latitude.toString();
                longitude = locations.last.longitude.toString();

                setState(() {
                  flag = true;
                });
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 84, 201, 207),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                    child: Text(
                  "Convert to Coordinates",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LatLngAddress()));
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 84, 207, 88),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Text(
                    "Convert Coordinates to Address",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
