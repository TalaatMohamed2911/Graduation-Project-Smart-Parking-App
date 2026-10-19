part of 'map_bloc.dart';

@immutable
sealed class MapEvent {}

class InitializeMapEvent extends MapEvent {}

class SelectParkingMarkerEvent extends MapEvent {
  final int index;

  SelectParkingMarkerEvent(this.index);
}

class ClearSelectedParkingMarkerEvent extends MapEvent {}

class ClearMapMessageEvent extends MapEvent {}

class StartLocationStreamEvent extends MapEvent {}

class StopLocationStreamEvent extends MapEvent {}

class UpdateLocationEvent extends MapEvent {
  final LatLng position;

  UpdateLocationEvent(this.position);
}

class FetchRouteEvent extends MapEvent {
  final LatLng source;
  final LatLng destination;

  FetchRouteEvent(this.source, this.destination);
}

class LocationStreamFailedEvent extends MapEvent {
  final String message;

  LocationStreamFailedEvent(this.message);
}
