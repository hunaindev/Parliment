import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class SaveAndOpenPdf {
  static Future<File> savePdf({
    required String name,
    required Document pdf,
  }) async {
    // Get the directory for saving the file
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/$name');

    // pdf.save() returns a Future<Uint8List>, so we await it
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  static Future<void> openPdf(file) async {
    final path = file.path;
    await OpenFile.open(path);
  }
}
