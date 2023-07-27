import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_api/screens/6_custom_markers_infoWindows.dart';
import 'package:google_maps_api/screens/7_polygons.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const AddPolygons()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width * 0.75,
              image: const AssetImage('assets/images/maps.png'),
            ),
          )
        ],
      ),
    );
  }
}
