import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:logger/logger.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Logger logger = Logger();

  Future<void> _exportPDF() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ac nunc at tortor sodales congue. Nulla ornare convallis diam, at mattis justo posuere efficitur. Aliquam consectetur fringilla eros quis rutrum. Mauris tincidunt erat non porttitor scelerisque. Aliquam non mauris nec est luctus vulputate eget quis dolor. Phasellus sit amet ultricies ipsum, quis tincidunt mauris. Ut vestibulum est lorem, et vulputate eros fermentum sit amet. Sed quis tellus id erat rhoncus tempus quis in ex. Praesent eget sem quis turpis dictum euismod. Suspendisse scelerisque malesuada tortor eget dictum. Aenean elementum nec nisl sed congue. Aenean consequat purus ligula, a egestas lorem mattis sit amet.");
        },
      ),
    );

    Uint8List bytes = await pdf.save();
    print(bytes);
    Directory directory = await getApplicationSupportDirectory();
    File pdfFile = File("${directory.path}/reportePdf.pdf");
    await pdfFile.writeAsBytes(bytes, flush: true);

    OpenFile.open("${directory.path}/reportePdf.pdf");
  }

  Future<void> _createExcel() async {
    DateTime now = DateTime.now();
    String newNow = now
        .toString()
        .replaceAll(":", "_")
        .replaceAll(".", "_")
        .replaceAll(" ", "_");
    logger.e(now);
    final excel.Workbook workbook = excel.Workbook();

    final excel.Worksheet sheet = workbook.worksheets[0];

    sheet.getRangeByIndex(1, 1).setText("TITULO");
    sheet.getRangeByName("B1").setText("SUBTITULO");

    //GUARDAR DOCUMENTO
    final List<int> bytes = workbook.saveAsStream();
    // workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;

    final String filename = '$path/ARCHIVOEXCEL-$newNow.xlsx';
    logger.d(filename);

    final File file = File(filename);

    await file.writeAsBytes(bytes, flush: true);

    OpenFile.open(filename);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _createExcel();
                },
                child: Text("Generar excel"),
              ),
              ElevatedButton(
                onPressed: () {
                  _exportPDF();
                },
                child: Text("Generar PDF"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
