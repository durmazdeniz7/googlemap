import 'package:assesment_map/logic/bloc/marker_bloc.dart';
import 'package:assesment_map/presentation/widget/map_button.dart';
import 'package:assesment_map/presentation/widget/search_bar.dart';
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
  Position? _currentPosition;
  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) {
      if (value == LocationPermission.denied) {
        Geolocator.requestPermission();
      }
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });

    return await Geolocator.getCurrentPosition();
  }

  void _getUserLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) async {
      setState(() {
        _currentPosition = position;

        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
    }).catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: 2,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue[900],
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'AnaSayfa'),
            BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Asistan'),
            BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: 'İstasyonlar'),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menü')
          ]),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MapButton(
            onTap: () async {
              await mapController.animateCamera(CameraUpdate.zoomIn());
            },
            icon: Icons.add,
          ),
          MapButton(
            onTap: () async {
              await mapController.animateCamera(CameraUpdate.zoomOut());
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
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  GoogleMap(
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
                    initialCameraPosition: CameraPosition(
                        target: LatLng(_currentPosition?.latitude ?? 39.91987, _currentPosition?.longitude ?? 32.85427), zoom: 14),
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                  ),
                  Positioned(
                      top: 80,
                      left: 20,
                      right: 20,
                      child: SearchBarWdiget(
                        onPressed: () {},
                      )),
                ],
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
    );

    if (result.points.isNotEmpty) {
      setState(() {
        polylineCoordinates.clear();
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      });
    } else {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('No route found'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              )
            ],
          );
        },
      );
    }
  }
}
