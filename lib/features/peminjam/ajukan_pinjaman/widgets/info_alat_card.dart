import 'package:flutter/material.dart';
import '../models/model.dart';
import '../../daftar_alat/models/model.dart';

class InfoAlatCard extends StatelessWidget {
  final Function(AlatModel) onRemove;

  const InfoAlatCard({super.key, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromRGBO(205, 238, 226, 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: keranjangAlat.map((alat) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(alat.nama, style: const TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w800, fontSize: 16, color: Color.fromRGBO(49, 47, 52, 1))),
                    Text('Kode: ${alat.kode}', style: const TextStyle(fontFamily: 'Roboto', fontSize: 12, color: Color.fromRGBO(72, 141, 117, 1))),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 20),
                  onPressed: () => onRemove(alat),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}