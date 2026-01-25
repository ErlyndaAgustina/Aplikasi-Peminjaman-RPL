import 'package:flutter/material.dart';
import 'CustomDropdownField.dart';
import 'custom_input_field.dart';

String? jenisLaporan;
String? kategoriAlat;
String? status;

class FilterCard extends StatefulWidget {
  const FilterCard({super.key});

  @override
  State<FilterCard> createState() => _FilterCardState();
}

class _FilterCardState extends State<FilterCard> {
  String jenisLaporan = "semua";
  String kategoriAlat = "semua";
  String status = "semua";

  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  Future<void> _pickDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      controller.text =
          "${picked.day.toString().padLeft(2, '0')}/"
          "${picked.month.toString().padLeft(2, '0')}/"
          "${picked.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromRGBO(205, 238, 226, 1)),
      ),
      child: Column(
        children: [
          CustomDropdownField<String>(
            label: "Jenis Laporan",
            hintText: "Pilih jenis laporan",
            value: jenisLaporan,
            items: const [
              DropdownMenuItem(value: "semua", child: Text("Semua")),
              DropdownMenuItem(
                value: "peminjaman",
                child: Text("Laporan Peminjaman"),
              ),
              DropdownMenuItem(
                value: "pengembalian",
                child: Text("Laporan Pengembalian"),
              ),
              DropdownMenuItem(
                value: "alat",
                child: Text("Laporan Daftar Alat"),
              ),
            ],
            onChanged: (value) {
              setState(() => jenisLaporan = value!);
            },
          ),

          /// TANGGAL MULAI
          CustomInputField(
            label: "Tanggal Mulai",
            hintText: "Pilih tanggal",
            controller: startDateController,
            readOnly: true,
            onTap: () => _pickDate(context, startDateController),
            suffixIcon: const Icon(
              Icons.calendar_month,
              color: Color.fromRGBO(72, 141, 117, 1),
              size: 20,
            ),
          ),

          /// TANGGAL AKHIR
          CustomInputField(
            label: "Tanggal Akhir",
            hintText: "Pilih tanggal",
            controller: endDateController,
            readOnly: true,
            onTap: () => _pickDate(context, endDateController),
            suffixIcon: const Icon(
              Icons.calendar_month,
              color: Color.fromRGBO(72, 141, 117, 1),
              size: 20,
            ),
          ),

          CustomDropdownField<String>(
            label: "Kategori Alat",
            value: kategoriAlat,
            hintText: "Pilih kategori alat",
            items: const [
              DropdownMenuItem(value: "semua", child: Text("Semua")),
              DropdownMenuItem(
                value: "komputasi",
                child: Text("Perangkat Komputasi"),
              ),
              DropdownMenuItem(
                value: "jaringan",
                child: Text("Perangkat Jaringan"),
              ),
              DropdownMenuItem(
                value: "mobile",
                child: Text("Perangkat Mobile & IoT"),
              ),
            ],
            onChanged: (value) {
              setState(() => kategoriAlat = value!);
            },
          ),

          CustomDropdownField<String>(
            label: "Status",
            hintText: "Pilih status laporan",
            value: status,
            items: const [
              DropdownMenuItem(value: "semua", child: Text("Semua")),
              DropdownMenuItem(value: "dipinjam", child: Text("Dipinjam")),
              DropdownMenuItem(
                value: "dikembalikan",
                child: Text("Dikembalikan"),
              ),
              DropdownMenuItem(value: "terlambat", child: Text("Terlambat")),
            ],
            onChanged: (value) {
              setState(() => status = value!);
            },
          ),
        ],
      ),
    );
  }
}
