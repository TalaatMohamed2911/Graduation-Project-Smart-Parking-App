import 'package:google_maps_flutter/google_maps_flutter.dart';

List<String> images = [
  "assets/images/done.png",
  "assets/images/p_red.png",
  "assets/images/p_red.png",
  "assets/images/p_red.png",
  "assets/images/p_red.png",
];
final List<LatLng> positions = <LatLng>[
  const LatLng(29.8519, 31.3420), //كلية هندسة حلوان
  const LatLng(29.845734, 31.362051), //جامعة مايو
  const LatLng(29.871489, 31.319822), //جامعة حلوان
  const LatLng(29.782317, 31.323655), // مصنع الحديد والصلب حلوان
  const LatLng(29.840697, 31.314976), // تراخيص حلوان
];

const String googleMapsApiKey = 'AIzaSyCGShAceyIm1LHL2mLja0eKCKDjoZV2RzY';
