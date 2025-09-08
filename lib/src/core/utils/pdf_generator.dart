import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;

Future<bool> generateAndDownloadPdf(String name, List<String> locations) async {
  try {
    if (Platform.isAndroid) {
      final storageStatus = await Permission.storage.request();
      if (!storageStatus.isGranted) return false;

      if (await Permission.manageExternalStorage.isDenied) {
        final manageStatus = await Permission.manageExternalStorage.request();
        if (!manageStatus.isGranted) return false;
      }
    }

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Report for $name', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 16),
              ...locations.map((loc) => pw.Text(loc)),
            ],
          );
        },
      ),
    );

    // Try Downloads folder
    Directory dir = Directory('/storage/emulated/0/Download');

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final file = File('${dir.path}/$name-report.pdf');
    await file.writeAsBytes(await pdf.save());

    print("✅ PDF saved at: ${file.path}");
    return true;
  } catch (e) {
    print('❌ Error generating PDF: $e');
    return false;
  }
}
