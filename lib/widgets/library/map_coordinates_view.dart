import 'dart:async';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/map/coordinates.dart';
import 'package:app/services/image_service.dart';
import 'package:app/utils/assets.dart';

// const _startIcon = 'assets/png_icons/map_pin_1.png';
// const _endIcon = 'assets/png_icons/pin_destination.png';

class MapCoordinatesView extends StatefulWidget {
  final bool showMarker;
  final Coordinates coordinates;
  const MapCoordinatesView({required this.coordinates, this.showMarker = false});

  @override
  State<MapCoordinatesView> createState() => _MapCoordinatesViewState();
}

class _MapCoordinatesViewState extends State<MapCoordinatesView> {
  List<Marker> _markers = [];
  Coordinates _coordinates = Coordinates();
  // CameraPosition _cameraPosition = CAMERA_POSITION;
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    _updateGoogleMap();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MapCoordinatesView oldWidget) {
    _updateGoogleMap();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller = Completer();
    // _cameraPosition = CAMERA_POSITION;
    _markers.clear();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController mapController) => _controller.complete(mapController);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      onCameraMove: (position) {
        // Only update coordinates, don't add marker on camera move
        var coordinates = Coordinates(lat: position.target.latitude, lng: position.target.longitude);
        setState(() => _coordinates = coordinates);
      },
      onCameraIdle: () async {
        // Only add marker when camera stops moving (user interaction ends)
        var latLog = LatLng(_coordinates.lat!, _coordinates.lng!);
        await _addMarker(latLog);
      },
      initialCameraPosition: CameraPosition(target: LatLng(_coordinates.lat!, _coordinates.lng!), zoom: 12),
      markers: Set.of(_markers),
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
    );
  }

  void _updateGoogleMap() {
    _coordinates = widget.coordinates;
    if (_coordinates.lat == null || _coordinates.lng == null) return;
    _setCoordinates();
  }

  Future<void> _addMarker(LatLng position) async {
    var markerIcon = await sl<ImageService>().getBytesFromAsset(path: Assets.png_image.map_pin, size: const Size(35, 40));
    _markers.clear();
    var id = const MarkerId('selected_location');
    var info = InfoWindow(title: 'pinned_location'.recast);
    _markers.add(Marker(markerId: id, position: position, icon: BitmapDescriptor.bytes(markerIcon), infoWindow: info));
    setState(() {});
  }

  Future<void> _setCoordinates() async {
    if (_coordinates.lat == null || _coordinates.lng == null) return;
    var latLng = LatLng(_coordinates.lat!, _coordinates.lng!);
    var position = CameraPosition(target: latLng, zoom: ZOOM);
    final GoogleMapController mapController = await _controller.future;
    await mapController.animateCamera(CameraUpdate.newCameraPosition(position));
  }
}
