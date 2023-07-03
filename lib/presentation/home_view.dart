// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class HomeView extends StatefulWidget {
//   const HomeView({super.key});

//   @override
//   State<HomeView> createState() => _HomeViewState();
// }

// class _HomeViewState extends State<HomeView> {
//   final CameraPosition _initialLocation = const CameraPosition(target: LatLng(0.0, 0.0));
//   final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
//   GoogleMapController? mapController;
//   Position? _currentPosition;
//   // Method for retrieving the current location

//   void _getCurrentLocation() async {
//     await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) async {
//       setState(() {
//         _currentPosition = position;

//         print('CURRENT POS: $_currentPosition');

//         // For moving the camera to current location
//         mapController?.animateCamera(
//           CameraUpdate.newCameraPosition(
//             CameraPosition(
//               target: LatLng(position.latitude, position.longitude),
//               zoom: 18.0,
//             ),
//           ),
//         );
//       });
//     }).catchError((e) {
//       print(e);
//     });
//   }

//   @override
//   void initState() {
//     _getCurrentLocation();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final GoogleMapController controller = await _controller.future;
//           await controller.animateCamera(CameraUpdate.newCameraPosition(const CameraPosition(
//               target: LatLng(
//                 38.657841,
//                 32.921398,
//               ),
//               zoom: 18)));
//         },
//       ),
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text('Gürİş'),
//       ),
//       body: GoogleMap(
//         initialCameraPosition: _initialLocation,
//         myLocationEnabled: true,
//         myLocationButtonEnabled: false,
//         mapType: MapType.normal,
//         zoomGesturesEnabled: true,
//         zoomControlsEnabled: false,
//         onMapCreated: (GoogleMapController controller) {
//           mapController = controller;
//         },
//       ),
//     );
//   }
// }

import 'package:assesment_map/logic/bloc/marker_bloc.dart';
import 'package:assesment_map/presentation/widget/map_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late GoogleMapController mapController;
  LatLng userLocation = const LatLng(0.0, 0.0);

  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  @override
  void initState() {
    super.initState();
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) {}).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MapButton(
            onTap: () async {
              await mapController.animateCamera(CameraUpdate.zoomIn());
            },
            icon: Icons.add,
          ),
          const SizedBox(height: 10),
          MapButton(
            onTap: () async {
              // await mapController.animateCamera(CameraUpdate.zoomOut());
              _showRoute(const LatLng(39.929182170636686, 32.702683272193916), const LatLng(41.015137, 28.979530));
            },
            icon: Icons.remove,
          ),
          const SizedBox(height: 10),
          MapButton(
            onTap: _getLocation,
            icon: Icons.my_location,
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => MarkerBloc()..add(GetMarkers()),
        child: BlocBuilder<MarkerBloc, MarkerState>(
          builder: (context, state) {
            if (state is MarkerLoaded) {
              Set<Marker> markers = const <Marker>{}.toSet();

              for (var element in state.markers) {
                markers.add(Marker(
                    infoWindow: InfoWindow(title: element.description),
                    icon: BitmapDescriptor.fromBytes(state.bytes),
                    markerId: MarkerId(element.id.toString()),
                    position: LatLng(double.parse(element.lat!), double.parse(element.long!))));
              }
              return GoogleMap(
                polylines: {
                  Polyline(
                    polylineId: const PolylineId('route'),
                    color: Colors.red,
                    width: 3,
                    points: polylineCoordinates,
                  ),
                },
                markers: markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                initialCameraPosition: const CameraPosition(target: LatLng(39.91987, 32.85427), zoom: 14),
                onMapCreated: (controller) {
                  mapController = controller;
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  void _getLocation() async {
    final location = await getUserCurrentLocation();

    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(location.latitude, location.longitude),
      zoom: 14,
    );
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {});
  }

  void _showRoute(LatLng origin, LatLng destination) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyCV-VQCqb2JQuUbFfw7k3VmfN7bD3hmdaE',
      PointLatLng(origin.latitude, origin.longitude),
      PointLatLng(destination.latitude, destination.longitude),

      // destination.longitude,
    );

    if (result.points.isNotEmpty) {
      setState(() {
        polylineCoordinates.clear();
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      });
    }
  }
}
