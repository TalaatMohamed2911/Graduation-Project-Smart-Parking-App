import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotary_parking/bloc/parking_bloc.dart';
import 'package:rotary_parking/components/parking_slot_info_window.dart';

class ReservationPage extends StatelessWidget {
  const ReservationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "SMART CAR PARKING",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ParkingBloc, ParkingState>(
        builder: (context, state) => Padding(
          padding: const EdgeInsets.all(5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  "Parking Slots",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 40),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Please select any slot",
                          style: TextStyle(
                              color: Color.fromARGB(255, 35, 122, 38)),
                        ),
                        Icon(Icons.keyboard_arrow_down)
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ParkingSlot(
                        isBooked: state.slots['1']!.booked,
                        isParked: state.slots['1']!.isParked,
                        slotName: "Slot no.1",
                        slotId: "1",
                        time: state.slots['1']!.parkingHours,
                      ),
                    ),
                    const SizedBox(
                      width: 60,
                      height: 60,
                      child: VerticalDivider(
                        color: Colors.blue,
                        thickness: 1,
                      ),
                    ),
                    Expanded(
                      child: ParkingSlot(
                        isBooked: state.slots['2']!.booked,
                        isParked: state.slots['2']!.isParked,
                        slotName: "Slot no.2",
                        slotId: "2",
                        time: state.slots['2']!.parkingHours,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ParkingSlot(
                        isBooked: state.slots['3']!.booked,
                        isParked: state.slots['3']!.isParked,
                        slotName: "Slot no.3",
                        slotId: "3",
                        time: state.slots['3']!.parkingHours,
                      ),
                    ),
                    const SizedBox(
                      width: 60,
                      height: 60,
                      child: VerticalDivider(
                        color: Colors.blue,
                        thickness: 1,
                      ),
                    ),
                    Expanded(
                      child: ParkingSlot(
                        isBooked: state.slots['4']!.booked,
                        isParked: state.slots['4']!.isParked,
                        slotName: "Slot no.4",
                        slotId: "4",
                        time: state.slots['4']!.parkingHours,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
