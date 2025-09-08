// lib/src/features/history_reports/presentations/widgets/report_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/widgets/custom_button.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:parliament_app/src/features/history_reports/domain/entities/notification_entity.dart';

// <<< STEP 1: CONVERT TO A STATEFUL WIDGET >>>
class ReportCard extends StatefulWidget {
  final String childName;
  final List<NotificationEntity> notifications;
  final VoidCallback onDownload;

  const ReportCard({
    super.key,
    required this.childName,
    required this.notifications,
    required this.onDownload,
  });

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  // <<< STEP 2: ADD STATE TO TRACK IF THE LIST IS EXPANDED >>>
  bool _isExpanded = false;

  String formatDate(DateTime date) {
    print(date);
    return DateFormat('MMM d, y – hh:mm a').format(date.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    // <<< STEP 3: CREATE A SUB-LIST OF NOTIFICATIONS TO DISPLAY >>>
    // If not expanded, take the first 3. If expanded, take all.
    // This assumes the list from the API is already sorted with the latest first.
    final displayedNotifications = _isExpanded
        ? widget.notifications
        : widget.notifications.take(3).toList();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black54, width: 1),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Child's Name (no changes here)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                const Icon(Icons.circle,
                    color: AppColors.primaryLightGreen, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: TextWidget(
                    text: widget.childName,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryLightGreen,
                  ),
                ),
              ],
            ),
          ),
          const DottedLine(
              dashLength: 4, dashGapLength: 4, dashRadius: 0, lineThickness: 1),

          // Use the 'displayedNotifications' list here
          ListView.builder(
            itemCount: displayedNotifications.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final notification = displayedNotifications[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.notifications_active_outlined,
                        color: Colors.orange, size: 18),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            notification.body,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black87),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatDate(notification.sentAt),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // <<< STEP 4: ADD THE "SHOW MORE / SHOW LESS" BUTTON >>>
          // This button only appears if there are more than 3 notifications in total.
          if (widget.notifications.length > 3)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Text(
                  _isExpanded
                      ? 'Show Less'
                      : 'Show ${widget.notifications.length - 3} More Notifications...',
                  style: const TextStyle(
                    color: AppColors.primaryLightGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 4), // Adjusted spacing
          const DottedLine(
              dashLength: 4, dashGapLength: 4, dashRadius: 0, lineThickness: 1),

          // The Download Button is always visible at the bottom
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomButton(
              text: "Download Report: ${widget.childName}",
              onPressed: widget.onDownload,
              textColor: Colors.white,
              // height: 50,
              borderRadius: 8,
              color: AppColors.primaryLightGreen,
            ),
          ),
        ],
      ),
    );
  }
}
