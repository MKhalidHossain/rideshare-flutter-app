import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreenTest extends StatefulWidget {
  @override
  State<MapScreenTest> createState() => _MapScreenTestState();
}

class _MapScreenTestState extends State<MapScreenTest> {
  GoogleMapController? _controller;
  LocationData? currentLocation;
  Location location = Location();

  final LatLng destinationLatLng = LatLng(39.806, -105.1);
  final LatLng sourceLatLng = LatLng(39.73, -105.14);

  Set<Polyline> polylines = {};
  Set<Marker> markers = {};
  BitmapDescriptor? carYellowIcon;
  BitmapDescriptor? carRedIcon;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadIcons();
    await _getCurrentLocation();
    _setMarkers();
    _setPolylines();
  }

  Future<void> _loadIcons() async {
    carYellowIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)), 'assets/images/car_yellow.png');
    carRedIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)), 'assets/images/car_red.png');
  }

  Future<void> _getCurrentLocation() async {
    currentLocation = await location.getLocation();
    setState(() {});
  }

  void _setMarkers() {
    markers.addAll([
      Marker(
        markerId: MarkerId("source"),
        position: sourceLatLng,
        infoWindow: InfoWindow(title: "My Location"),
      ),
      Marker(
        markerId: MarkerId("destination"),
        position: destinationLatLng,
        infoWindow: InfoWindow(title: "Destination"),
      ),
      Marker(
        markerId: MarkerId("car1"),
        position: LatLng(39.74, -105.12),
        icon: carYellowIcon!,
      ),
      Marker(
        markerId: MarkerId("car2"),
        position: LatLng(39.75, -105.11),
        icon: carRedIcon!,
      ),
    ]);
  }

  void _setPolylines() {
    polylines.add(Polyline(
      polylineId: PolylineId("route"),
      color: Colors.black,
      width: 4,
      points: [sourceLatLng, LatLng(39.745, -105.13), destinationLatLng],
    ));
  }

  void _centerMap() {
    _controller?.animateCamera(CameraUpdate.newLatLngZoom(sourceLatLng, 13));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _controller = controller;
              _centerMap();
            },
            markers: markers,
            polylines: polylines,
            initialCameraPosition: CameraPosition(
              target: sourceLatLng,
              zoom: 13,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          Positioned(
            top: 40,
            left: 10,
            right: 10,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(6),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            right: MediaQuery.of(context).size.width / 2 - 28,
            child: GestureDetector(
              onTap: _centerMap,
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
                ),
                child: Icon(Icons.my_location, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
