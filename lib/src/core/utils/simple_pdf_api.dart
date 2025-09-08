// lib/utils/pdf_generator.dart

import 'dart:io';
// import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
// import 'package:parliament_app/src/features/history_reports/data/models/notification_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:parliament_app/src/features/history_reports/data/models/report_model.dart'; // Import model

class PdfGenerator {
  static Future<File?> generateReportPdf({
    required String childName,
    required List notifications,
  }) async {
    try {
      final pdf = pw.Document();

      // final regularFontData =
      //     await rootBundle.load("assets/fonts/NotoSans-Regular.ttf");
      // final boldFontData =
      //     await rootBundle.load("assets/fonts/NotoSans-Bold.ttf");

      // final fontRegular = pw.Font.ttf(regularFontData);
      // final fontBold = pw.Font.ttf(boldFontData);

      pdf.addPage(
        pw.MultiPage(
          // Use MultiPage to handle potentially long lists of notifications
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) => [
            _buildPdfHeader(childName
                // fontBold
                ),
            _buildPdfBody(notifications
                //  fontRegular, fontBold
                ),
          ],
        ),
      );

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/report-$childName.pdf');
      await file.writeAsBytes(await pdf.save());
      await OpenFile.open(file.path);

      return file;
    } catch (e) {
      print('❌ Error generating PDF: $e');
      return null;
    }
  }

  static pw.Widget _buildPdfHeader(
    String childName,
    // pw.Font fontBold
  ) {
    return pw.Header(
      level: 0,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('Notification Report for $childName',
              style: pw.TextStyle(fontSize: 20)),
          pw.Text(DateFormat('MMM d, yyyy').format(DateTime.now()),
              style: pw.TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  static pw.Widget _buildPdfBody(
    List notifications,
    //  pw.Font fontRegular, pw.Font fontBold
  ) {
    String formatDate(DateTime date) =>
        DateFormat('MMM d, y | hh:mm a').format(date.toLocal());

    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: notifications.map((notification) {
          return pw.Container(
              padding: const pw.EdgeInsets.all(10),
              margin: const pw.EdgeInsets.only(bottom: 10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey, width: 0.5),
                borderRadius: pw.BorderRadius.circular(5),
              ),
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(notification.title,
                        style: pw.TextStyle(
                            // font: fontBold,
                            fontSize: 14)),
                    pw.SizedBox(height: 5),
                    pw.Text(notification.body,
                        style: pw.TextStyle(
                            // font: fontRegular,
                            fontSize: 12)),
                    pw.SizedBox(height: 8),
                    pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(formatDate(notification.sentAt),
                          style: pw.TextStyle(
                              // font: fontRegular,
                              fontSize: 10,
                              color: PdfColors.grey600)),
                    )
                  ]));
        }).toList());
  }
}
