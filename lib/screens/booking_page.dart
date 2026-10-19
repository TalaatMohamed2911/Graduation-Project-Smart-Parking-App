import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:rotary_parking/bloc/parking_bloc.dart';

class BookingPage extends StatefulWidget {
  final String slotName;
  final String slotId;

  const BookingPage({
    super.key,
    required this.slotId,
    required this.slotName,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _vehicleNumberController.dispose();
    super.dispose();
  }

  Future<void> _showBookingConfirmation(
    BuildContext context,
    BookingConfirmation confirmation,
  ) async {
    context.read<ParkingBloc>().add(DismissBookingConfirmationEvent());
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text(
          'SLOT BOOKED',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.blue,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/animation/done.json', height: 130),
              const Text(
                'Your Slot Booked',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
              _confirmationRow(
                icon: Icons.person,
                label: 'Name',
                value: confirmation.name,
              ),
              _confirmationRow(
                icon: Icons.car_rental,
                label: 'Vehicle No',
                value: confirmation.vehicleNumber,
              ),
              _confirmationRow(
                icon: Icons.watch_later_outlined,
                label: 'Parking time',
                value: confirmation.duration.toString(),
              ),
              _confirmationRow(
                icon: Icons.local_parking,
                label: 'Parking Slot',
                value: 'A-${confirmation.slotId}',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.currency_pound,
                    size: 32,
                    color: Colors.blue,
                  ),
                  Text(
                    confirmation.amount.toString(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _confirmationRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 5),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParkingBloc, ParkingState>(
      listenWhen: (previous, current) =>
          previous.confirmation != current.confirmation ||
          previous.message != current.message,
      listener: (context, state) {
        if (state.message != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message!)));
          context.read<ParkingBloc>().add(ClearParkingMessageEvent());
        }
        final confirmation = state.confirmation;
        if (confirmation != null) {
          _showBookingConfirmation(context, confirmation);
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'BOOK SLOT',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/animation/running_car.json',
                        width: 250,
                        height: 150,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Book Now ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        width: 130,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            widget.slotName,
                            style: const TextStyle(
                              fontSize: 26,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 1, color: Colors.blue),
                  const SizedBox(height: 12),
                  const Row(children: [Text('Enter your name ')]),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 194, 193, 193),
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.lightBlue,
                      ),
                      labelText: 'Name',
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Row(children: [Text('Enter Vehical Number ')]),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _vehicleNumberController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 194, 193, 193),
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.car_rental,
                        color: Colors.blue,
                      ),
                      hintText: 'ex: 529  ب و م',
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [Text('Choose Slot Time (in Minuits)')],
                  ),
                  const SizedBox(height: 10),
                  Slider(
                    mouseCursor: MouseCursor.defer,
                    thumbColor: Colors.blue,
                    activeColor: Colors.blue,
                    inactiveColor: Colors.grey,
                    label: '${state.parkingTimeInMin} min',
                    value: state.parkingTimeInMin,
                    onChanged: (value) => context
                        .read<ParkingBloc>()
                        .add(UpdateParkingDurationEvent(value)),
                    divisions: 5,
                    min: 10,
                    max: 60,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 14, right: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('10'),
                        Text('20'),
                        Text('30'),
                        Text('40'),
                        Text('50'),
                        Text('60'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Amount to Be Pay'),
                          Row(
                            children: [
                              const Icon(
                                Icons.currency_pound,
                                size: 30,
                                color: Colors.blue,
                              ),
                              Text(
                                '${state.parkingAmount}',
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () => context.read<ParkingBloc>().add(
                              BookParkingSlotEvent(
                                slotId: widget.slotId,
                                name: _nameController.text,
                                vehicleNumber: _vehicleNumberController.text,
                              ),
                            ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'PAY NOW',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
