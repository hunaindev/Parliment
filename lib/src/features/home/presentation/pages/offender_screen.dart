import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
// import 'package:parliament_app/src/core/services/location_service.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/location/location_cubit.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/offender/offender_bloc.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/offender/offender_event.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/offender/offender_state.dart';
import 'package:parliament_app/src/features/home/presentation/widgets/offender_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OffenderScreen extends StatefulWidget {
  const OffenderScreen({super.key});

  @override
  State<OffenderScreen> createState() => _OffenderScreenState();
}

class _OffenderScreenState extends State<OffenderScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  // Future<void> _fetchOffendersFromChildren() async {
  //   // Ensure the widget is still mounted before accessing context.
  //   if (!mounted) return;

  //   // A microtask delay ensures that the context is fully available.
  //   await Future.microtask(() {});

  //   final children = context.read<ChildLocationCubit>().state;
  //   final childrenWithLocation =
  //       children.where((child) => child.location != null).toList();

  //   if (childrenWithLocation.isNotEmpty) {
  //     for (final child in childrenWithLocation) {
  //       final lat = child.location!.latitude;
  //       final lng = child.location!.longitude;
  //       context.read<OffenderBloc>().add(FetchOffenders(lat: lat, lng: lng));
  //     }
  //   } else {
  //     // Fallback: no live location found
  //     context.read<OffenderBloc>().add(FetchOffenders(lat: 0.0, lng: 0.0));
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchOffendersFromChildren();

  //   _scrollController.addListener(() {
  //     // Check if we are near the bottom of the list
  //     if (_scrollController.position.pixels >=
  //         _scrollController.position.maxScrollExtent - 200) {
  //       final state = context.read<OffenderBloc>().state;
  //       // Only trigger "load more" if we are in the Loaded state and have more items.
  //       if (state is OffenderLoaded && state.hasMore) {
  //         context.read<OffenderBloc>().add(LoadMoreOffenders());
  //       }
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   _searchController.dispose();
  //   super.dispose();
  // }

  Future<void> _fetchOffendersFromChildren() async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final lastFetchMillis = prefs.getInt('lastFetchOffenders') ?? 0;
    final lastFetch = DateTime.fromMillisecondsSinceEpoch(lastFetchMillis);
    final now = DateTime.now();

    // Agar last fetch ek hafte ke andar hua hai to skip kar do
    // if (now.difference(lastFetch) < const Duration(days: 7)) {
    //   print("⏳ Skipping offender fetch, last fetched within a week");
    //   return;
    // }

    await Future.microtask(() {});

    final children = context.read<ChildLocationCubit>().state;
    final childrenWithLocation =
        children.where((child) => child.location != null).toList();

    if (childrenWithLocation.isNotEmpty) {
      for (final child in childrenWithLocation) {
        final lat = child.location!.latitude;
        final lng = child.location!.longitude;
        context.read<OffenderBloc>().add(FetchOffenders(lat: lat, lng: lng));
      }
    } else {
      // context.read<OffenderBloc>().add(FetchOffenders(lat: 0.0, lng: 0.0));
    }

    // Save last fetch time
    await prefs.setInt('lastFetchOffenders', now.millisecondsSinceEpoch);
  }

  @override
  void initState() {
    super.initState();

    // Week check ke sath offenders fetch
    _fetchOffendersFromChildren();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        final state = context.read<OffenderBloc>().state;
        if (state is OffenderLoaded && state.hasMore) {
          context.read<OffenderBloc>().add(LoadMoreOffenders());
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<OffenderBloc>().add(SearchOffenders(query));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Search Offenders',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                          color: AppColors.primaryLightGreen, width: 1),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // OffenderCard(offender: {
              //   'name': "offender.name",
              //   'age': 'Age:offender.age',
              //   'location': "offender.address",
              //   'conviction': "offender.courtRecord",
              //   'image': "offender.photoUrl",
              // }),
              // Expanded(
              //   child:
              BlocBuilder<OffenderBloc, OffenderState>(
                builder: (context, state) {
                  if (state is OffenderError) {
                    return Center(child: Text("❌ ${state.message}"));
                  }

                  if (state is OffenderLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is OffenderLoaded) {
                    if (state.offenders.isEmpty) {
                      return const Center(child: Text("No offenders found."));
                    }

                    return SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          ...state.offenders.map((offender) {
                            return OffenderCard(offender: {
                              'name': offender.name,
                              'age': 'Age: ${offender.age}',
                              'location': offender.address,
                              'conviction': offender.courtRecord,
                              'image': offender.photoUrl,
                            });
                          }).toList(),
                          if (state.hasMore)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                        ],
                      ),
                    );
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
              // ),
            ],
          );
        },
      ),
    );
  }
}
