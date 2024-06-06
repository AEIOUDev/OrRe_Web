import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orre_web/services/debug_services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:orre_web/model/location_model.dart';
import '../../services/geocording/geocording_library_service.dart'; // 추가

final nowLocationProvider =
    StateNotifierProvider<LocationStateNotifier, LocationInfo?>((ref) {
  return LocationStateNotifier(ref);
});

class LocationStateNotifier extends StateNotifier<LocationInfo?> {
  bool _isUpdating = false;

  LocationStateNotifier(Ref _ref) : super(null);

  Future<LocationInfo?> updateNowLocation() async {
    if (_isUpdating) {
      return state;
    }

    _isUpdating = true;
    printd("nowLocationProvider updateNowLocation");
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // 권한 거부되었을 때의 상태 반환
        printd("위치 권한 거부 : $permission");
        state = null;
        _isUpdating = false;
        return null;
      } else if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        printd("위치 권한 허용 : $permission");
      }
    }

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    printd(
        "nowLocationProvider : 현재 경도 : ${position.longitude}, 현재 위도 : ${position.latitude}");

    // 권한이 허용되었을 때 도로명 주소 변환 로직
    String? placemarks = await getAddressFromLatLngLibrary(
        position.latitude, position.longitude, 4, true);

    // 내 도로명 주소를 불러올 수 없을 때의 상태 반환
    if (placemarks == null) {
      printd("현재 위치의 주소를 찾을 수 없습니다.");
      state = LocationInfo(
        locationName: '현재 위치',
        address: '주소를 찾을 수 없습니다.',
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } else {
      printd("nowLocationProvider : $placemarks");
      state = LocationInfo(
          locationName: '현재 위치',
          address: placemarks,
          latitude: position.latitude,
          longitude: position.longitude);
    }

    _isUpdating = false;
    return state;
  }

  Stream<LocationInfo?> watchNowLocation() async* {
    if (!_isUpdating) {
      while (true) {
        yield await updateNowLocation();
        await Future.delayed(const Duration(seconds: 10));
      }
    }
  }
}
