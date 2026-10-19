part of 'parking_bloc.dart';

@immutable
class ParkingSlotState {
  final bool booked;
  final bool isParked;
  final String parkingHours;
  final String name;
  final bool paymentDone;

  const ParkingSlotState({
    this.booked = false,
    this.isParked = false,
    this.parkingHours = '',
    this.name = '',
    this.paymentDone = false,
  });
}

@immutable
class BookingConfirmation {
  final String slotId;
  final String name;
  final String vehicleNumber;
  final double duration;
  final int amount;

  const BookingConfirmation({
    required this.slotId,
    required this.name,
    required this.vehicleNumber,
    required this.duration,
    required this.amount,
  });
}

@immutable
class ParkingState {
  final Map<String, ParkingSlotState> slots;
  final double parkingTimeInMin;
  final int parkingAmount;
  final BookingConfirmation? confirmation;
  final String? message;

  const ParkingState({
    this.slots = const {
      '1': ParkingSlotState(),
      '2': ParkingSlotState(),
      '3': ParkingSlotState(),
      '4': ParkingSlotState(),
    },
    this.parkingTimeInMin = 10,
    this.parkingAmount = 5,
    this.confirmation,
    this.message,
  });

  ParkingState copyWith({
    Map<String, ParkingSlotState>? slots,
    double? parkingTimeInMin,
    int? parkingAmount,
    BookingConfirmation? confirmation,
    bool clearConfirmation = false,
    String? message,
    bool clearMessage = false,
  }) {
    return ParkingState(
      slots: slots ?? this.slots,
      parkingTimeInMin: parkingTimeInMin ?? this.parkingTimeInMin,
      parkingAmount: parkingAmount ?? this.parkingAmount,
      confirmation:
          clearConfirmation ? null : confirmation ?? this.confirmation,
      message: clearMessage ? null : message ?? this.message,
    );
  }
}
