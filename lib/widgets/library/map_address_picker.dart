import 'dart:async';
import 'dart:ui' as ui;

import 'package:app/extensions/string_ext.dart';
import 'package:app/models/map/coordinates.dart';
import 'package:app/utils/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapAddressPicker extends StatefulWidget {
  final Coordinates coordinates;
  final bool zoomEnabled;
  final Function(Coordinates) onMoveCamera;
  final double zoom;
  const MapAddressPicker({required this.coordinates, required this.onMoveCamera, this.zoomEnabled = false, this.zoom = 12});

  @override
  State<MapAddressPicker> createState() => _MapAddressPickerState();
}

class _MapAddressPickerState extends State<MapAddressPicker> {
  var _mapStyle = '';
  var _coordinates = Coordinates(lat: 23.622857, lng: 90.499010);
  var _markers = <Marker>{};
  GoogleMapController? _mapController;
  BitmapDescriptor? _markerIcon;
  Timer? _debounceTimer;
  static const _markerId = MarkerId('selected_location');
  var _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadMapStyles();
    _coordinates = widget.coordinates;
    _loadMarkerIcon();
    // setState(() {});
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _loadMapStyles() async => _mapStyle = await rootBundle.loadString('assets/json/uber_style.json');

  Future<void> _updateMapLocation() async {
    if (_coordinates.lat != widget.coordinates.lat || _coordinates.lng != widget.coordinates.lng) {
      _coordinates = widget.coordinates;
      // setState(() => );
      await Future.delayed(const Duration(milliseconds: 200));
      await _updateMarkerPosition();
      _updateCameraPosition();
    }
  }

  @override
  void didUpdateWidget(covariant MapAddressPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    final isNewCoordinates = oldWidget.coordinates.lat != widget.coordinates.lat || oldWidget.coordinates.lng != widget.coordinates.lng;
    if (isNewCoordinates) _updateMapLocation();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      style: _mapStyle,
      markers: _markers,
      onCameraMove: _onCameraMove,
      onCameraIdle: _onCameraIdle,
      // zoomControlsEnabled: widget.zoomEnabled,
      onMapCreated: _initializeMapController,
      initialCameraPosition: CameraPosition(target: LatLng(_coordinates.lat!, _coordinates.lng!), zoom: widget.zoom),
      myLocationButtonEnabled: false,
    );
  }

  Future<void> _initializeMapController(GoogleMapController control) async {
    _mapController = control;
    if (_markerIcon != null) {
      await _updateMarkerPosition();
    }
  }

  Future<void> _loadMarkerIcon() async {
    try {
      final markerBytes = await _getBytesFromAsset(Assets.png_image.map_pin, 40);
      _markerIcon = BitmapDescriptor.bytes(markerBytes);
    } catch (e) {
      _markerIcon = BitmapDescriptor.defaultMarker;
    }

    if (_mapController != null) await _updateMarkerPosition();
    await Future.delayed(const Duration(milliseconds: 700));
    _isInitialized = true;
    // setState(() => );
  }

  void _onCameraMove(CameraPosition position) {
    if (!_isInitialized) return;
    _coordinates = Coordinates(lat: position.target.latitude, lng: position.target.longitude);
    _debounceTimer?.cancel();
  }

  void _onCameraIdle() {
    if (!_isInitialized) return;
    _debounceTimer?.cancel();
    _updateMarkerPosition();
    widget.onMoveCamera(_coordinates);
  }

  Future<void> _updateMarkerPosition() async {
    // print('print: marker called -> ${_coordinates.lat}');
    if (_markerIcon == null || _mapController == null) return;
    final position = LatLng(_coordinates.lat!, _coordinates.lng!);
    final window = InfoWindow(title: 'selected_location'.recast);
    final marker = Marker(markerId: _markerId, position: position, icon: _markerIcon!, infoWindow: window);
    _markers = {marker};
    // setState(() => );
    _updateCameraPosition();
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
    if (_mapController == null) return;
    // print('print: Updating camera position to -> ${_coordinates.lat}, ${_coordinates.lng}');
    final position = LatLng(_coordinates.lat!, _coordinates.lng!);
    _mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: position, zoom: widget.zoom)));
  }
}
