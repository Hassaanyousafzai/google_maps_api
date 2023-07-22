import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:google_maps_api/components/row_component.dart';
import 'package:google_maps_api/screens/3_address_latlng.dart';

class LatLngAddress extends StatefulWidget {
  const LatLngAddress({super.key});

  @override
  State<LatLngAddress> createState() => _LatLngAddressState();
}

class _LatLngAddressState extends State<LatLngAddress> {
  TextEditingController coController = TextEditingController();
  String? addressLine, countryName, subLocality, locality;
  bool flag = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coordinates - Address"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 75, 193, 79),
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
                controller: coController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'Enter Coordinates',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.green,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.green,
                      ),
                    )),
              ),
            ),
            flag == true
                ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.30,
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
                            text: 'Address:',
                            value: addressLine.toString(),
                          ),
                          RowComponent(
                            text: 'Country Name:',
                            value: countryName.toString(),
                          ),
                          RowComponent(
                            text: 'Province:',
                            value: locality.toString(),
                          ),
                          RowComponent(
                            text: 'Sub Locality:',
                            value: subLocality.toString(),
                          ),
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
                var text = coController.text.trim();
                List<String> parts = text.split(",");
                double? coordinateOne = double.tryParse(parts[0]);
                double? coordinateTwo = double.tryParse(parts[1]);
                if (coordinateOne != null && coordinateTwo != null) {
                  final coordinates = Coordinates(coordinateOne, coordinateTwo);

                  var address = await Geocoder.local
                      .findAddressesFromCoordinates(coordinates);

                  var first = address.first;

                  addressLine = first.addressLine;

                  countryName = first.countryName;

                  locality = first.adminArea;

                  subLocality = first.subLocality;
                }

                setState(() {
                  flag = true;
                });
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 84, 207, 88),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                    child: Text(
                  "Convert to Address",
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
                        builder: (context) => const AddressLatLng()));
              },
              child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 84, 201, 207),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      "Convert Address to Coordinates",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
