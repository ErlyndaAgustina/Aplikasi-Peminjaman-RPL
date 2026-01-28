import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {
  static Future<void> generateLaporan({
    required String jenis,
    required String tglMulai,
    required String tglAkhir,
    required String kategori,
    required String status,
  }) async {
    final pdf = pw.Document();

    // Data dummy - Ganti bagian ini dengan hasil query database Anda berdasarkan filter
    final List<List<String>> dataLaporan = [
      ['No', 'Tanggal', 'Nama Peminjam', 'Alat', 'Status'],
      ['1', '2024-01-20', 'Budi Santoso', 'Laptop Dell', 'Dikembalikan'],
      ['2', '2024-01-21', 'Siti Aminah', 'Router Cisco', 'Dipinjam'],
    ];

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("LAPORAN ${jenis.toUpperCase()}",
                  style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text("Periode: $tglMulai - $tglAkhir"),
              pw.Text("Kategori: $kategori | Status: $status"),
              pw.Divider(),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headers: dataLaporan[0],
                data: dataLaporan.sublist(1),
                border: pw.TableBorder.all(),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
                cellAlignment: pw.Alignment.centerLeft,
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Laporan_${jenis}_$tglMulai.pdf',
    );
  }
}