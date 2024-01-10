import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:logger/logger.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Logger logger = Logger();

  Future<void> _createExcel() async {
    final excel.Workbook workbook = excel.Workbook();

    final excel.Worksheet sheet = workbook.worksheets[0];

    sheet.getRangeByIndex(1, 1).setText("HOLA MUNDO 1");
    sheet.getRangeByName("A2").setText("HOLA MUNDO 2");

    //GUARDAR DOCUMENTO
    final List<int> bytes = workbook.saveAsStream();
    // workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;

    final String filename = '$path/ARCHIVOEXCEL.xlsx';
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
            ],
          ),
        ),
      ),
    );
  }
}
