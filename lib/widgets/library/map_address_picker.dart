import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:app/models/map/coordinates.dart';
import 'package:app/utils/assets.dart';

class MapAddressPicker extends StatefulWidget {
  final Coordinates coordinates;
  final Function(Coordinates) onMoveCamera;
  const MapAddressPicker({required this.coordinates, required this.onMoveCamera});

  @override
  State<MapAddressPicker> createState() => _MapAddressPickerState();
}

class _MapAddressPickerState extends State<MapAddressPicker> {
  var _coordinates = Coordinates(lat: 23.622857, lng: 90.499010);
  var _markers = <Marker>{};
  late GoogleMapController _mapController;
  BitmapDescriptor? _markerIcon;
  Timer? _debounceTimer;
  static const _markerId = MarkerId('selected_location');

  @override
  void initState() {
    super.initState();
    _coordinates = widget.coordinates;
    _loadMarkerIcon();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _updateMapLocation() {
    if (_coordinates.lat != widget.coordinates.lat || _coordinates.lng != widget.coordinates.lng) {
      setState(() => _coordinates = widget.coordinates);
      _updateCameraPosition();
      _updateMarkerPosition();
    }
  }

  @override
  void didUpdateWidget(covariant MapAddressPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateMapLocation();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: _markers,
      zoomControlsEnabled: false,
      onMapCreated: _initializeMapController,
      initialCameraPosition: CameraPosition(target: LatLng(_coordinates.lat!, _coordinates.lng!), zoom: 12),
      onCameraMove: _onCameraMove,
      onCameraIdle: _onCameraIdle,
      myLocationButtonEnabled: false,
    );
  }

  Future<void> _initializeMapController(GoogleMapController control) async {
    _mapController = control;
    if (_markerIcon != null) _updateMarkerPosition();
  }

  Future<void> _loadMarkerIcon() async {
    try {
      final markerBytes = await _getBytesFromAsset(Assets.png_image.map_pin, 40);
      _markerIcon = BitmapDescriptor.bytes(markerBytes);
      _updateMarkerPosition();
    } catch (e) {
      _markerIcon = BitmapDescriptor.defaultMarker;
      _updateMarkerPosition();
    }
  }

  void _onCameraMove(CameraPosition position) {
    _coordinates = Coordinates(lat: position.target.latitude, lng: position.target.longitude);

    // Remove the Future.delayed call that was causing issues
    // _updateMarkerPosition will be called in onCameraIdle instead

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () => widget.onMoveCamera(_coordinates));
  }

  void _onCameraIdle() {
    _debounceTimer?.cancel();

    // Update marker position only when camera stops moving
    _updateMarkerPosition();

    // Notify parent with final coordinates
    widget.onMoveCamera(_coordinates);
  }

  void _updateMarkerPosition() {
    if (_markerIcon == null) return;

    final position = LatLng(_coordinates.lat!, _coordinates.lng!);
    final marker = Marker(
      markerId: _markerId,
      position: position,
      icon: _markerIcon!,
      infoWindow: const InfoWindow(title: 'Selected Location'),
    );

    setState(() => _markers = {marker});
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    try {
      ByteData data = await rootBundle.load(path);
      ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
      ui.FrameInfo fi = await codec.getNextFrame();
      return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
    } catch (e) {
      return Uint8List(0);
    }
  }

  void _updateCameraPosition() {
    final position = LatLng(_coordinates.lat!, _coordinates.lng!);
    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: position, zoom: 12)));
  }
}
