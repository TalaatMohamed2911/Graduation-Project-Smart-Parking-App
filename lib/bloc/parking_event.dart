part of 'parking_bloc.dart';

@immutable
sealed class ParkingEvent {}

class UpdateParkingDurationEvent extends ParkingEvent {
  final double duration;

  UpdateParkingDurationEvent(this.duration);
}

class BookParkingSlotEvent extends ParkingEvent {
  final String slotId;
  final String name;
  final String vehicleNumber;

  BookParkingSlotEvent({
    required this.slotId,
    required this.name,
    required this.vehicleNumber,
  });
}

class ParkingTimerTickedEvent extends ParkingEvent {
  final String slotId;

  ParkingTimerTickedEvent(this.slotId);
}

class DismissBookingConfirmationEvent extends ParkingEvent {}

class ClearParkingMessageEvent extends ParkingEvent {}
