import 'package:custom_info_window/custom_info_window.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rotary_parking/bloc/map_bloc.dart';
import 'package:rotary_parking/consts.dart';
import 'package:rotary_parking/screens/reservation.dart';
import 'package:rotary_parking/utils/slotsnumber.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MapBloc()..add(InitializeMapEvent()),
      child: const _MapView(),
    );
  }
}

class _MapView extends StatefulWidget {
  const _MapView();

  @override
  State<_MapView> createState() => _MapViewState();
}

class _MapViewState extends State<_MapView> {
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  GoogleMapController? _mapController;
  LatLng? _lastPosition;

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Widget _buildParkingInfoWindow(BuildContext context, int index) {
    return Container(
      height: 165,
      width: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 239,
              height: 120,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/parking.jpg'),
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(11),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StreamBuilder(
                  stream: SlotsNumbers.getSlots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Slots unavailable');
                    }
                    if (!snapshot.hasData) {
                      return const Text('Loading...');
                    }
                    final slots = snapshot.data;
                    if (slots is! List || index >= slots.length) {
                      return const Text('Slots unavailable');
                    }
                    return Text(
                      'Free Slots: ${slots[index]['slots']}',
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    );
                  },
                ),
                MaterialButton(
                  height: 28,
                  minWidth: 43,
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ReservationPage(),
                      ),
                    );
                  },
                  child: const Text('Book'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<MapBloc, MapState>(
          // listenWhen: (previous, current) =>
          //     previous.message != current.message ||
          //     previous.selectedParkingIndex != current.selectedParkingIndex ||
          //     previous.currentPosition != current.currentPosition,
          listener: (context, state) {
            if (state.message != null) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(state.message!)));
              context.read<MapBloc>().add(ClearMapMessageEvent());
            }

            final selectedIndex = state.selectedParkingIndex;
            if (selectedIndex != null && _mapController != null) {
              _customInfoWindowController.addInfoWindow?.call(
                _buildParkingInfoWindow(context, selectedIndex),
                positions[selectedIndex],
              );
              context.read<MapBloc>().add(ClearSelectedParkingMarkerEvent());
            }

            if (state.isTracking &&
                state.currentPosition != null &&
                state.currentPosition != _lastPosition) {
              _mapController?.animateCamera(
                CameraUpdate.newLatLng(state.currentPosition!),
              );
            }
            _lastPosition = state.currentPosition;
          },
          builder: (context, state) {
            if (state.isInitial || state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(29.85123, 31.3421),
                    zoom: 12,
                  ),
                  markers: state.markers ?? {},
                  polylines: state.polylines ?? {},
                  myLocationEnabled: state.currentPosition != null,
                  myLocationButtonEnabled: state.currentPosition != null,
                  padding: const EdgeInsets.only(top: 20),
                  onMapCreated: (controller) {
                    _mapController = controller;
                    _customInfoWindowController.googleMapController =
                        controller;
                  },
                  onTap: (_) {
                    _customInfoWindowController.hideInfoWindow?.call();
                    context
                        .read<MapBloc>()
                        .add(ClearSelectedParkingMarkerEvent());
                  },
                  onCameraMove: (_) {
                    _customInfoWindowController.onCameraMove?.call();
                  },
                ),
                Container(
                  width: 51,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 235, 220, 220),
                      width: 1.5,
                    ),
                    color: const Color.fromARGB(255, 248, 246, 246),
                    borderRadius: const BorderRadius.all(Radius.circular(23)),
                  ),
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: IconButton(
                    tooltip: 'Account',
                    color: Colors.blueAccent,
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        FirebaseAuth.instance.currentUser == null
                            ? 'login'
                            : 'profile',
                      );
                    },
                    icon: const Icon(Icons.person),
                  ),
                ),
                CustomInfoWindow(
                  controller: _customInfoWindowController,
                  height: 165,
                  width: 230,
                  offset: 38,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
