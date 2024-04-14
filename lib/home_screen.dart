import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps/place.dart';
import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  // final List<Marker> _marker = [];
  late ClusterManager _manager;
  Set<Marker> markers = {};

  List<Place> items = [
    for (int i = 0; i < 10; i++)
      Place(
        name: 'store $i',
        latLng: LatLng(48.848200 + i * 0.001, 2.319124 + i * 0.001),
      ),
    for (int i = 0; i < 10; i++)
      Place(
        name: 'Restaurant $i',
        latLng: LatLng(48.858265 - i * 0.001, 2.350107 + i * 0.001),
      ),
    for (int i = 0; i < 10; i++)
      Place(
        name: 'Bar $i',
        latLng: LatLng(48.858265 + i * 0.01, 2.350107 - i * 0.01),
      ),
    for (int i = 0; i < 10; i++)
      Place(
        name: 'Hotel $i',
        latLng: LatLng(48.858265 - i * 0.1, 2.350107 - i * 0.01),
      ),
    for (int i = 0; i < 10; i++)
      Place(
        name: 'parlar $i',
        latLng: LatLng(66.160507 + i * 0.1, -153.369141 + i * 0.1),
      ),
    for (int i = 0; i < 10; i++)
      Place(
        name: 'home $i',
        latLng: LatLng(-36.848461 + i * 1, 169.763336 + i * 1),
      ),
  ];

  // final List<Marker> _list = const [
  //   Marker(
  //     markerId: MarkerId('1'),
  //     position: LatLng(37.42796133580664, -122.085749655962),
  //     infoWindow: InfoWindow(title: "my Position"),
  //   ),
  //   Marker(
  //     markerId: MarkerId('2'),
  //     position: LatLng(38.42796133580664, -121.085749655962),
  //     infoWindow: InfoWindow(title: "sector 2"),
  //   ),
  //   Marker(
  //     markerId: MarkerId('3'),
  //     position: LatLng(39.42796133580664, -120.085749655962),
  //     infoWindow: InfoWindow(title: "sector 3"),
  //   ),
  // ];

  final CameraPosition _parisCameraPosition =
      const CameraPosition(target: LatLng(48.856613, 2.352222), zoom: 12.0);
  @override
  void initState() {
    super.initState();
    _manager = _initClusterManager();
  }

  ClusterManager _initClusterManager() {
    return ClusterManager<Place>(items, _updateMarkers,
        markerBuilder: _markerBuilder);
  }

  void _updateMarkers(Set<Marker> markers) {
    setState(() {
      this.markers = markers;
    });
  }

  Future<Marker> Function(Cluster<Place>) get _markerBuilder =>
      (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          infoWindow: InfoWindow(
              title: cluster.isMultiple
                  ? 'Places : ${cluster.count.toString()}'
                  : cluster.items.single.dataName),
        );
      };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GoogleMap(
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            initialCameraPosition: _parisCameraPosition,
            markers: markers,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _manager.setMapId(controller.mapId);
            },
            onCameraMove: _manager.onCameraMove,
            onCameraIdle: _manager.updateMap),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(
              CameraUpdate.newLatLngZoom(_parisCameraPosition.target, 8.0),
            );
          },
          child: const Icon(Icons.zoom_out_map),
        ),
      ),
    );
  }
}
