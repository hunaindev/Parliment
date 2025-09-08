import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';

class MapSearchBar extends StatefulWidget {
  final void Function(LatLng latLng) onResult;
  final double height;

  const MapSearchBar({super.key, required this.onResult, this.height = 60});

  @override
  State<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends State<MapSearchBar> {
  final TextEditingController _controller = TextEditingController();

  /// Searches for a location based on the text input in the search bar.
  ///
  /// This method performs a geocoding lookup for the entered address.
  /// If a location is found, it calls the [onResult] callback with the first matching location's coordinates.
  /// If no location is found or an error occurs, it displays a snackbar with an appropriate message.
  ///
  /// Throws an exception if geocoding fails or no location can be found.
  /// A timer used to debounce or delay an action, typically used to reduce unnecessary computations or API calls.
  ///
  Timer? _delay;

  Future<void> _searchLocation() async {
    try {
      final query = _controller.text;
      if (query.isEmpty) return;

      final locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final LatLng result = LatLng(
          locations.first.latitude,
          locations.first.longitude,
        );
        widget.onResult(result);
      } else {
        _showSnackbar("No location found");
      }
    } catch (e) {
      print(e);
      _showSnackbar("Error: $e");
    }
  }

  void delayedSearch(searchFunc) {
    _delay?.cancel();
    _delay = Timer(const Duration(milliseconds: 500), () {
      searchFunc();
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(8),
      child: TextField(
        controller: _controller,
// CORRECT
        onSubmitted: (_) => delayedSearch(_searchLocation),
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 33, 33, 33)), // Set input text font size
        decoration: InputDecoration(
          hintText: 'Search Location',
          prefixIcon: const Icon(Icons.search),
          hintStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14), // Set hint text font size
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(color: AppColors.primaryLightGreen, width: 1),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: (widget.height! - 24) / 2,
          ),
        ),
      ),
    );
  }
}
