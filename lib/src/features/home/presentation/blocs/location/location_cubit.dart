// lib/src/features/home/cubit/child_location_cubit.dart
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parliament_app/src/core/config/local_storage.dart';
import 'package:parliament_app/src/core/services/parent_firestore_service.dart';

class ChildInfo {
  final String id;
  final String name;
  final String? image;
  final LatLng? location;
  final bool isOnline;

  ChildInfo({
    required this.id,
    required this.name,
    this.image,
    this.location,
    required this.isOnline,
  });

  factory ChildInfo.fromJson(Map<String, dynamic> json) {
    LatLng? parsedLocation;

    if (json['location'] != null &&
        json['location']['latitude'] != null &&
        json['location']['longitude'] != null) {
      parsedLocation = LatLng(
        json['location']['latitude'],
        json['location']['longitude'],
      );
    }

    return ChildInfo(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      location: parsedLocation,
      isOnline: json['isOnline'],
    );
  }
}

class ChildLocationCubit extends Cubit<List<ChildInfo>> {
  final ParentFirestoreService _firestoreService;
  Stream<List<ChildInfo>>? _stream;
  StreamSubscription? _subscription;

  ChildLocationCubit(this._firestoreService) : super([]);

  Future<void> listenToChildLocations() async {
    final user = await LocalStorage.getUser();
    final parentId = user?.userId ?? "";

    _stream = _firestoreService.listenToChildLocations(parentId);
    _subscription = _stream!.listen((children) {
      emit(children);
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
