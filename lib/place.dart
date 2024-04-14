import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart';

class Place with ClusterItem {
  final String name;
  final LatLng latLng;

  Place({
    required this.name,
    required this.latLng,
  });

  @override
  LatLng get location => latLng;
  String get dataName => name;
}
