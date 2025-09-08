// ignore_for_file: prefer_const_constructors

// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';

class SearchBar extends StatefulWidget {
  final List<Map<String, String>> allOffenders;
  final Function(List<Map<String, String>>) onSearchResult;

  const SearchBar({
    super.key,
    required this.allOffenders,
    required this.onSearchResult,
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  void _performSearch(String query) {
    final lowerQuery = query.toLowerCase();

    final filtered = query.isEmpty
        ? widget.allOffenders
        : widget.allOffenders.where((offender) {
            return offender['name']!.toLowerCase().contains(lowerQuery) ||
                offender['location']!.toLowerCase().contains(lowerQuery) ||
                offender['conviction']!.toLowerCase().contains(lowerQuery);
          }).toList();

    widget.onSearchResult(filtered);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.search, // show "Search" on keyboard
      onSubmitted: _performSearch, // called when search icon is tapped
      decoration: InputDecoration(
        hintText: 'Search Offenders',
        prefixIcon: const Icon(Icons.search, color: AppColors.darkBrown),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primaryLightGreen),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
