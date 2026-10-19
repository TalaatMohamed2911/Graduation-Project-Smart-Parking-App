part of 'map_bloc.dart';

enum MapStatus { initial, loading, loaded, error }

extension MapStateExtension on MapState {
  bool get isInitial => status == MapStatus.initial;
  bool get isLoading => status == MapStatus.loading;
  bool get isLoaded => status == MapStatus.loaded;
  bool get isError => status == MapStatus.error;
}

@immutable
class MapState {
  final MapStatus status;
  final LatLng? currentPosition;
  final Set<Marker>? markers;
  final Set<Polyline>? polylines;
  final List<LatLng>? polylineCoordinates;
  final bool isTracking;
  final int? selectedParkingIndex;
  final String? message;

  const MapState({
    this.status = MapStatus.initial,
    this.currentPosition,
    this.markers,
    this.polylines,
    this.polylineCoordinates,
    this.isTracking = false,
    this.selectedParkingIndex,
    this.message,
  });

  MapState copyWith({
    MapStatus? status,
    LatLng? currentPosition,
    Set<Marker>? markers,
    Set<Polyline>? polylines,
    List<LatLng>? polylineCoordinates,
    bool? isTracking,
    int? selectedParkingIndex,
    bool clearSelectedParkingIndex = false,
    String? message,
    bool clearMessage = false,
  }) {
    return MapState(
      status: status ?? this.status,
      currentPosition: currentPosition ?? this.currentPosition,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      polylineCoordinates: polylineCoordinates ?? this.polylineCoordinates,
      isTracking: isTracking ?? this.isTracking,
      selectedParkingIndex: clearSelectedParkingIndex
          ? null
          : selectedParkingIndex ?? this.selectedParkingIndex,
      message: clearMessage ? null : message ?? this.message,
    );
  }
}
