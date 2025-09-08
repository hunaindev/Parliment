import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
import 'package:parliament_app/src/features/home/data/model/notification_model.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/dashboard/dashboard_bloc.dart';
import 'package:parliament_app/src/features/home/presentation/blocs/dashboard/dashboard_state.dart';

class RecentAlerts extends StatelessWidget {
  const RecentAlerts({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSize = screenWidth * 0.05;

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        final dashboardBloc = context.read<DashboardBloc>();
        final allNotifications = dashboardBloc.notfication;

        if (allNotifications.isEmpty) {
          return const SizedBox(
            height: 100,
            child: Center(child: Text("No alerts available")),
          );
        }
        // Sort notifications by sentAt descending and take latest 3
        final List<NotifyModel> notifications = List.from(allNotifications)
          ..sort((a, b) =>
              DateTime.parse(b.sentAt).compareTo(DateTime.parse(a.sentAt)));

        final latestThree = notifications.take(3).toList();

        return Container(
          height: screenHeight * 0.13,
          width: screenWidth,
          child: PageView.builder(
            controller: PageController(viewportFraction: 1),
            itemCount: latestThree.length,
            itemBuilder: (context, index) {
              final NotifyModel item = latestThree[index];

              final String name = item.sender.name;
              final String title = item.title;
              final String sentAt = item.sentAt;

              return Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: name,
                      fontSize: fontSize,
                      color: AppColors.darkGray,
                      fontWeight: FontWeight.bold,
                    ),
                    Row(
                      children: [
                        TextWidget(
                          text: title,
                          fontSize: 12,
                          color: AppColors.darkBrown,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(width: 8),
                        TextWidget(
                          text: _formatTime(sentAt),
                          fontSize: 12,
                          color: AppColors.darkGray,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _formatTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString)
          .toLocal(); // optional: to convert to local time
      int hour = dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12;
      if (hour == 0) hour = 12; // handle midnight and noon
      return '${hour.toString().padLeft(2, '0')}:$minute $period'; // e.g., 02:24 PM
    } catch (e) {
      return "";
    }
  }
}
