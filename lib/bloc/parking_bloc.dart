import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'parking_event.dart';
part 'parking_state.dart';

class ParkingBloc extends Bloc<ParkingEvent, ParkingState> {
  final Map<String, Timer> _slotTimers = {};

  ParkingBloc() : super(const ParkingState()) {
    on<UpdateParkingDurationEvent>(_onUpdateParkingDuration);
    on<BookParkingSlotEvent>(_onBookParkingSlot);
    on<ParkingTimerTickedEvent>(_onParkingTimerTicked);
    on<DismissBookingConfirmationEvent>((event, emit) {
      emit(state.copyWith(clearConfirmation: true));
    });
    on<ClearParkingMessageEvent>((event, emit) {
      emit(state.copyWith(clearMessage: true));
    });
  }

  void _onUpdateParkingDuration(
    UpdateParkingDurationEvent event,
    Emitter<ParkingState> emit,
  ) {
    emit(
      state.copyWith(
        parkingTimeInMin: event.duration,
        parkingAmount: (event.duration * 1.5).round(),
      ),
    );
  }

  void _onBookParkingSlot(
    BookParkingSlotEvent event,
    Emitter<ParkingState> emit,
  ) {
    final slot = state.slots[event.slotId];
    if (slot == null) {
      emit(state.copyWith(message: 'Unknown parking slot.'));
      return;
    }
    if (slot.booked) {
      emit(state.copyWith(message: 'This parking slot is already booked.'));
      return;
    }

    final duration = state.parkingTimeInMin;
    final updatedSlots = Map<String, ParkingSlotState>.of(state.slots)
      ..[event.slotId] = ParkingSlotState(
        booked: true,
        isParked: true,
        parkingHours: duration.toInt().toString(),
        name: event.name,
        paymentDone: true,
      );

    emit(
      state.copyWith(
        slots: updatedSlots,
        confirmation: BookingConfirmation(
          slotId: event.slotId,
          name: event.name,
          vehicleNumber: event.vehicleNumber,
          duration: duration,
          amount: state.parkingAmount,
        ),
        clearMessage: true,
      ),
    );

    _slotTimers.remove(event.slotId)?.cancel();
    _slotTimers[event.slotId] = Timer.periodic(
      const Duration(seconds: 1),
      (_) => add(ParkingTimerTickedEvent(event.slotId)),
    );
  }

  void _onParkingTimerTicked(
    ParkingTimerTickedEvent event,
    Emitter<ParkingState> emit,
  ) {
    final slot = state.slots[event.slotId];
    if (slot == null || !slot.booked) {
      _slotTimers.remove(event.slotId)?.cancel();
      return;
    }

    final remaining = int.tryParse(slot.parkingHours) ?? 0;
    final updatedSlots = Map<String, ParkingSlotState>.of(state.slots);
    if (remaining <= 1) {
      updatedSlots[event.slotId] = const ParkingSlotState();
      _slotTimers.remove(event.slotId)?.cancel();
    } else {
      updatedSlots[event.slotId] = ParkingSlotState(
        booked: true,
        isParked: true,
        parkingHours: (remaining - 1).toString(),
        name: slot.name,
        paymentDone: slot.paymentDone,
      );
    }
    emit(state.copyWith(slots: updatedSlots));
  }

  @override
  Future<void> close() {
    for (final timer in _slotTimers.values) {
      timer.cancel();
    }
    _slotTimers.clear();
    return super.close();
  }
}
