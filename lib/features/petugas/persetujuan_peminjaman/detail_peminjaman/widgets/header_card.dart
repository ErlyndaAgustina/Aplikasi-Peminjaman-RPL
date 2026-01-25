import 'package:flutter/material.dart';
import '../models/model.dart';

const String roboto = 'Roboto';

class HeaderCard extends StatelessWidget {
  final DetailPeminjamanModel data;

  const HeaderCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color.fromRGBO(205, 238, 226, 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.nama,
                  style: const TextStyle(
                    fontFamily: roboto,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Color.fromRGBO(49, 47, 52, 1),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.kode,
                  style: const TextStyle(
                    fontFamily: roboto,
                    fontSize: 12,
                    color: Color.fromRGBO(72, 141, 117, 1),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: data.status.bgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              data.status.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: data.status.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
