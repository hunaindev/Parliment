// lib/src/features/history_reports/presentations/history_and_reports.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
// import 'package:parliament_app/src/core/utils/pdf_generator.dart';
import 'package:parliament_app/src/core/utils/simple_pdf_api.dart';
import 'package:parliament_app/src/core/widgets/main_scaffold.dart';
// import 'package:parliament_app/src/features/history_reports/data/models/notification_model.dart';
// import 'package:parliament_app/src/features/history_reports/data/models/report_model.dart';
import 'package:parliament_app/src/features/history_reports/domain/entities/notification_entity.dart';
import 'package:parliament_app/src/features/history_reports/presentations/bloc/notification_bloc.dart';
import 'package:parliament_app/src/features/history_reports/presentations/bloc/notification_event.dart';
// import 'package:parliament_app/src/features/history_reports/presentations/bloc/report_bloc.dart';
// import 'package:parliament_app/src/features/history_reports/presentations/bloc/report_state.dart';
import 'package:parliament_app/src/features/history_reports/presentations/widgets/report_card.dart'; // Use the new ReportCard

class HistoryAndReports extends StatefulWidget {
  const HistoryAndReports({super.key});

  @override
  State<HistoryAndReports> createState() => _HistoryAndReportsState();
}

class _HistoryAndReportsState extends State<HistoryAndReports> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Updated download function to accept the new data structure
  Future<void> _downloadReport(
      String childName, List<NotificationEntity> notifications) async {
    // Show a loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Generating PDF for $childName...')),
    );

    // The PDF generator now handles everything, including saving and opening.
    final pdfFile = await PdfGenerator.generateReportPdf(
      childName: childName,
      notifications: notifications,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (pdfFile != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ PDF generated successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Failed to generate PDF.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(
                  child: CircularProgressIndicator(
                color: AppColors.primaryLightGreen,
              ));
            } else if (state is NotificationError) {
              return Center(child: Text('❌ ${state.message}'));
            } else if (state is NotificationLoaded) {
              if (state.notifications.isEmpty) {
                return const Center(child: Text('No reports found'));
              }

              // --- GROUPING LOGIC ---
              // <<< KEY CHANGE: The map must hold NotificationEntity, not NotificationModel.
              final groupedByChild = <String, List<NotificationEntity>>{};

              // This loop now works because `state.notifications` is a List<NotificationEntity>
              // and we are adding to a list of the same type.
              for (final notification in state.notifications) {
                final childId = notification.sender.id;
                if (!groupedByChild.containsKey(childId)) {
                  groupedByChild[childId] = [];
                }
                groupedByChild[childId]!.add(notification);
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: groupedByChild.entries.map((entry) {
                    final childNotifications = entry.value;
                    final childName = childNotifications.first.sender.name;
                    return ReportCard(
                      childName: childName,
                      notifications: childNotifications,
                      onDownload: () =>
                          _downloadReport(childName, childNotifications),
                    );
                  }).toList(),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
