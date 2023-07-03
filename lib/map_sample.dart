// // import 'dart:async';
// // import 'dart:developer';

// // import 'package:flutter/material.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';

// // class MapSample extends StatefulWidget {
// //   const MapSample({super.key});

// //   @override
// //   State<MapSample> createState() => MapSampleState();
// // }

// // class MapSampleState extends State<MapSample> {
// //   final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

// //   Position? _currentPosition;

// //   _getCurrentLocation() async {
// //     LocationPermission permission;
// //     permission = await Geolocator.requestPermission();
// //     if (permission == LocationPermission.denied) {
// //       permission = await Geolocator.requestPermission();
// //       if (permission == LocationPermission.deniedForever) {
// //         return Future.error('Location Not Available');
// //       }
// //     }
// //     await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation).then((Position position) async {
// //       setState(() {
// //         _currentPosition = position;

// //         print('CURRENT POS: $_currentPosition');
// //       });
// //       final GoogleMapController controller = await _controller.future;
// //       await controller.animateCamera(CameraUpdate.newCameraPosition(
// //           CameraPosition(target: LatLng(_currentPosition?.latitude ?? 39.923130, _currentPosition?.longitude ?? 32.851070))));
// //       setState(() {});
// //     }).catchError((e) {
// //       log(e.toString());
// //       print(e);
// //     });
// //   }

// //   @override
// //   void initState() {
// //     super.initState();
// //     _getCurrentLocation();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       floatingActionButton: FloatingActionButton(onPressed: _goToTheLake),
// //       body: GoogleMap(
// //         mapType: MapType.normal,
// //         initialCameraPosition:
// //             CameraPosition(target: LatLng(_currentPosition?.latitude ?? 39.923130, _currentPosition?.longitude ?? 32.851070)),
// //         onMapCreated: (GoogleMapController controller) {
// //           _controller.complete(controller);
// //         },
// //       ),
// //     );
// //   }

// import 'dart:math';

// //   Future<void> _goToTheLake() async {
// //     final GoogleMapController controller = await _controller.future;
// //     await controller.animateCamera(
// //         CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude))));
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   GoogleMapController? mapController; //contrller for Google map
//   PolylinePoints polylinePoints = PolylinePoints();

//   String googleAPiKey = "AIzaSyCV-VQCqb2JQuUbFfw7k3VmfN7bD3hmdaE";

//   Set<Marker> markers = {}; //markers for google map
//   Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

//   LatLng startLocation = const LatLng(27.6683619, 85.3101895);
//   LatLng endLocation = const LatLng(27.6875436, 85.2751138);

//   double distance = 0.0;

//   @override
//   void initState() {
//     markers.add(Marker(
//       markerId: MarkerId(startLocation.toString()),
//       position: startLocation, //position of marker
//       infoWindow: const InfoWindow(
//         //popup info
//         title: 'Starting Point ',
//         snippet: 'Start Marker',
//       ),
//       icon: BitmapDescriptor.defaultMarker, //Icon for Marker
//     ));

//     markers.add(Marker(
//       //add distination location marker
//       markerId: MarkerId(endLocation.toString()),
//       position: endLocation, //position of marker
//       infoWindow: const InfoWindow(
//         //popup info
//         title: 'Destination Point ',
//         snippet: 'Destination Marker',
//       ),
//       icon: BitmapDescriptor.defaultMarker, //Icon for Marker
//     ));
// //fetch direction polylines from Google API

//     super.initState();
//   }

//   getDirections() async {
//     List<LatLng> polylineCoordinates = [];

//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       googleAPiKey,
//       PointLatLng(startLocation.latitude, startLocation.longitude),
//       PointLatLng(endLocation.latitude, endLocation.longitude),
//       travelMode: TravelMode.driving,
//     );

//     if (result.points.isNotEmpty) {
//       for (var point in result.points) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       }
//     } else {
//       print(result.errorMessage);
//     }

//     //polulineCoordinates is the List of longitute and latidtude.
//     double totalDistance = 0;
//     for (var i = 0; i < polylineCoordinates.length - 1; i++) {
//       totalDistance += calculateDistance(polylineCoordinates[i].latitude, polylineCoordinates[i].longitude,
//           polylineCoordinates[i + 1].latitude, polylineCoordinates[i + 1].longitude);
//     }
//     print(totalDistance);

//     setState(() {
//       distance = totalDistance;
//     });

//     //add to the list of poly line coordinates
//     addPolyLine(polylineCoordinates);
//   }

//   addPolyLine(List<LatLng> polylineCoordinates) {
//     PolylineId id = const PolylineId("poly");
//     Polyline polyline = Polyline(
//       polylineId: id,
//       color: Colors.deepPurpleAccent,
//       points: polylineCoordinates,
//       width: 8,
//     );
//     polylines[id] = polyline;
//     setState(() {});
//   }

//   double calculateDistance(lat1, lon1, lat2, lon2) {
//     var p = 0.017453292519943295;
//     var a = 0.5 - cos((lat2 - lat1) * p) / 2 + cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
//     return 12742 * asin(sqrt(a));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text("Calculate Distance in Google Map"),
//           backgroundColor: Colors.deepPurpleAccent,
//         ),
//         body: Stack(children: [
//           GoogleMap(
//             //Map widget from google_maps_flutter package
//             zoomGesturesEnabled: true, //enable Zoom in, out on map
//             initialCameraPosition: CameraPosition(
//               //innital position in map
//               target: startLocation, //initial position
//               zoom: 14.0, //initial zoom level
//             ),
//             markers: markers, //markers to show on map
//             polylines: Set<Polyline>.of(polylines.values), //polylines
//             mapType: MapType.normal, //map type
//             onMapCreated: (controller) {
//               //method called when map is created
//               setState(() {
//                 mapController = controller;
//               });
//             },
//           ),
//           Positioned(
//               bottom: 200,
//               left: 50,
//               child: Container(
//                   child: Card(
//                 child: Container(
//                     padding: const EdgeInsets.all(20),
//                     child: Text("Total Distance: ${distance.toStringAsFixed(2)} KM",
//                         style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
//               )))
//         ]));
//   }
// }



