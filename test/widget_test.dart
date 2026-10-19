import 'package:flutter_test/flutter_test.dart';
import 'package:rotary_parking/bloc/parking_bloc.dart';

void main() {
  test('duration updates price and booking marks its slot occupied', () async {
    final bloc = ParkingBloc();
    addTearDown(bloc.close);

    final durationUpdate = bloc.stream.firstWhere(
      (state) => state.parkingTimeInMin == 20,
    );
    bloc.add(UpdateParkingDurationEvent(20));
    final updatedState = await durationUpdate;

    expect(updatedState.parkingAmount, 30);

    final bookingUpdate = bloc.stream.firstWhere(
      (state) => state.slots['2']!.booked,
    );
    bloc.add(
      BookParkingSlotEvent(
        slotId: '2',
        name: 'Test Driver',
        vehicleNumber: 'TEST-123',
      ),
    );
    final bookedState = await bookingUpdate;

    expect(bookedState.slots['2']!.isParked, isTrue);
    expect(bookedState.slots['2']!.parkingHours, '20');
    expect(bookedState.confirmation?.name, 'Test Driver');
    expect(bookedState.confirmation?.vehicleNumber, 'TEST-123');
    expect(bookedState.confirmation?.amount, 30);
  });
}
