import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {
  static Future<void> generateLaporan({
    required String judul,
    required String periode,
    required String kategori,
    required String status,
    required List<List<String>> tableData,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              /// JUDUL
              pw.Text(
                judul.toUpperCase(),
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 8),

              /// INFO PERIODE
              pw.Text("Periode: $periode"),
              pw.Text("Kategori: $kategori | Status: $status"),

              pw.SizedBox(height: 12),
              pw.Divider(),
              pw.SizedBox(height: 12),

              /// TABEL DATA
              pw.TableHelper.fromTextArray(
                headers: tableData.first,
                data: tableData.sublist(1),
                border: pw.TableBorder.all(
                  width: 0.5,
                  color: PdfColors.grey,
                ),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
                cellStyle: const pw.TextStyle(fontSize: 10),
                cellAlignment: pw.Alignment.centerLeft,
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      name: judul.replaceAll(' ', '_'),
      onLayout: (format) async => pdf.save(),
    );
  }
}
