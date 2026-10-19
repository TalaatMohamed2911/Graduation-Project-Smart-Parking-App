import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rotary_parking/consts.dart';
import 'package:rotary_parking/utils/custommarker.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  StreamSubscription<Position>? _positionSubscription;

  MapBloc() : super(MapState()) {
    on<InitializeMapEvent>(_onInitializeMap);
    on<SelectParkingMarkerEvent>(_onSelectParkingMarker);
    on<ClearSelectedParkingMarkerEvent>((event, emit) {
      emit(state.copyWith(clearSelectedParkingIndex: true));
    });
    on<ClearMapMessageEvent>((event, emit) {
      emit(state.copyWith(clearMessage: true));
    });
    on<StartLocationStreamEvent>(_onStartLocationStream);
    on<StopLocationStreamEvent>(_onStopLocationStream);
    on<UpdateLocationEvent>(_onUpdateLocation);
    on<FetchRouteEvent>(_onFetchRoute);
    on<LocationStreamFailedEvent>(_onLocationStreamFailed);
  }

  Future<void> _onInitializeMap(
    InitializeMapEvent event,
    Emitter<MapState> emit,
  ) async {
    emit(state.copyWith(status: MapStatus.loading, clearMessage: true));
    try {
      final markers = <Marker>{};
      for (var index = 0; index < positions.length; index++) {
        final markerBytes =
            await CustomMarker().getImagesFromMarkers(images[index], 36);
        markers.add(
          Marker(
            markerId: MarkerId(index.toString()),
            position: positions[index],
            icon: BitmapDescriptor.bytes(markerBytes),
            onTap: () => add(SelectParkingMarkerEvent(index)),
          ),
        );
      }

      LatLng? currentPosition;
      String? locationMessage;
      try {
        currentPosition = await _determinePosition();
      } on Exception catch (error) {
        locationMessage = error.toString();
      }

      final initialCoordinates = currentPosition == null
          ? const <LatLng>[]
          : <LatLng>[currentPosition];
      emit(
        state.copyWith(
          status: MapStatus.loaded,
          currentPosition: currentPosition,
          markers: markers,
          polylines: const {},
          polylineCoordinates: initialCoordinates,
          isTracking: false,
          message: locationMessage,
        ),
      );
    } catch (error) {
      emit(state.copyWith(status: MapStatus.error, message: error.toString()));
    }
  }

  Future<LatLng> _determinePosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Location services are disabled.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied.');
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied. Enable them in settings.',
      );
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
    return LatLng(position.latitude, position.longitude);
  }

  void _onSelectParkingMarker(
    SelectParkingMarkerEvent event,
    Emitter<MapState> emit,
  ) {
    emit(state.copyWith(
      selectedParkingIndex: event.index,
      clearMessage: true,
    ));
  }

  Future<void> _onStartLocationStream(
    StartLocationStreamEvent event,
    Emitter<MapState> emit,
  ) async {
    if (state.isLoaded && !state.isTracking) {
      final currentState = state.copyWith(status: MapStatus.loaded);
      emit(currentState.copyWith(isTracking: true));
      await _positionSubscription?.cancel();

      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // meters
      );

      _positionSubscription =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen(
        (position) => add(
          UpdateLocationEvent(
            LatLng(position.latitude, position.longitude),
          ),
        ),
        onError: (Object error) =>
            add(LocationStreamFailedEvent(error.toString())),
      );
    }
  }

  void _onLocationStreamFailed(
    LocationStreamFailedEvent event,
    Emitter<MapState> emit,
  ) {
    _positionSubscription?.cancel();
    _positionSubscription = null;
    emit(state.copyWith(isTracking: false, message: event.message));
  }

  void _onStopLocationStream(
    StopLocationStreamEvent event,
    Emitter<MapState> emit,
  ) {
    _positionSubscription?.cancel();
    _positionSubscription = null;

    if (state.isLoaded) {
      final currentState = state.copyWith(status: MapStatus.loaded);
      emit(currentState.copyWith(isTracking: false));
    }
  }

  void _onUpdateLocation(UpdateLocationEvent event, Emitter<MapState> emit) {
    if (state.isLoaded) {
      // Append new coordinate to the existing route history
      final updatedCoordinates = List<LatLng>.from(
        state.polylineCoordinates ?? const <LatLng>[],
      )..add(event.position);

      Set<Polyline> updatedPolylines = {
        Polyline(
          polylineId: const PolylineId('tracking_path'),
          points: updatedCoordinates,
          color: Colors.blue,
          width: 5,
        ),
      };

      // Set<Marker> updatedMarkers = {
      //   Marker(
      //     markerId: const MarkerId('current_location'),
      //     position: event.position,
      //   ),
      // };

      emit(
        state.copyWith(
          status: MapStatus.loaded,
          currentPosition: event.position,
          polylines: updatedPolylines,
          polylineCoordinates: updatedCoordinates,
          clearMessage: true,
        ),
      );
    }
  }

  Future<void> _onFetchRoute(
    FetchRouteEvent event,
    Emitter<MapState> emit,
  ) async {
    try {
      final polylinePoints = PolylinePoints(
        apiKey: googleMapsApiKey,
      );

      final response = await polylinePoints.getRouteBetweenCoordinatesV2(
        request: RoutesApiRequest(
          origin: PointLatLng(event.source.latitude, event.source.longitude),
          destination: PointLatLng(
            event.destination.latitude,
            event.destination.longitude,
          ),
          travelMode: TravelMode.driving,
          routingPreference: RoutingPreference.trafficAware,
        ),
      );
      final routePoints = response.routes.isEmpty
          ? <PointLatLng>[]
          : response.routes.first.polylinePoints ?? <PointLatLng>[];

      if (routePoints.isNotEmpty) {
        final decodedPoints = routePoints
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        final polylines = <Polyline>{
          ...?state.polylines,
          Polyline(
            polylineId: const PolylineId('road_route'),
            points: decodedPoints,
            color: Colors.blueAccent,
            width: 5,
          ),
        };

        final markers = <Marker>{
          ...?state.markers,
          Marker(
            markerId: const MarkerId('source_marker'),
            position: event.source,
            infoWindow: const InfoWindow(title: 'Source'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
          ),
          Marker(
            markerId: const MarkerId('destination_marker'),
            position: event.destination,
            infoWindow: const InfoWindow(title: 'Destination'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
        };

        emit(
          state.copyWith(
            status: MapStatus.loaded,
            markers: markers,
            polylines: polylines,
            polylineCoordinates: decodedPoints,
            clearMessage: true,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: MapStatus.loaded,
            message: response.errorMessage ?? 'Unable to fetch route.',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(status: MapStatus.loaded, message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    return super.close();
  }
}
