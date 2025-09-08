// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/dashboard/dashboard_bloc.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/dashboard/dashboard_state.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredNotifications = [];

  @override
  void initState() {
    super.initState();
    // Wait for the dashboard state to be loaded before filtering
    Future.microtask(() {
      final notifications = context.read<DashboardBloc>().notfication;
      setState(() {
        _filteredNotifications = notifications;
      });
    });
  }

  void _onSearchChanged(String query) {
    final notifications = context.read<DashboardBloc>().notfication;

    setState(() {
      _filteredNotifications = notifications
          .where((notification) =>
              notification.title.toLowerCase().contains(query.toLowerCase()) ||
              notification.body.toLowerCase().contains(query.toLowerCase()) ||
              notification.sender.name
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        final dashboardBloc = context.read<DashboardBloc>();
        final notifications = dashboardBloc.notfication;

        if (notifications.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: TextWidget(
                text: 'Notifications',
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              backgroundColor: Colors.white,
            ),
            body: const SizedBox(
              height: 100,
              child: Center(child: Text("No alerts available")),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: TextWidget(
              text: 'Notifications',
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            backgroundColor: Colors.white,
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Search bar here
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: 'Search Notifications',
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

                // Expanded for ListView
                Expanded(
                  child: _filteredNotifications.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 32),
                            child: Text(
                              "No alerts found.",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredNotifications.length,
                          itemBuilder: (context, index) {
                            final notify = _filteredNotifications[index];
                            return Card(
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: notify.title,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.darkGray,
                                    ),
                                    const SizedBox(height: 8),
                                    TextWidget(
                                      text: notify.body,
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextWidget(
                                          text: "From: ${notify.sender.name}",
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                        TextWidget(
                                          text: _formatTime(notify.sentAt),
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTime(String time) {
    try {
      final dateTime = DateTime.parse(time);
      return DateFormat('MMM d, y – hh:mm a').format(dateTime.toLocal());
    } catch (e) {
      return time;
    }
  }
}
