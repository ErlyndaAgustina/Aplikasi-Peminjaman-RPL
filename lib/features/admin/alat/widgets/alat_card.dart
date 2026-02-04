import 'package:flutter/material.dart';
import '../detail_alat/detail_alat_page.dart';
import '../models/models.dart';
import 'delete_alat_dialog.dart';
import 'form_alat_dialog.dart';

const String roboto = 'Roboto';

class AlatCard extends StatelessWidget {
  final AlatModel alat;
  final VoidCallback onRefresh;

  const AlatCard({super.key, required this.alat, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final String totalUnit = alat.jumlah.toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color.fromRGBO(205, 238, 226, 1)),
      ),
      child: Column( // Main wrapper
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. BOX GAMBAR (KIRI)
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: alat.imageUrl != null && alat.imageUrl!.isNotEmpty
                      ? Image.network(
                          alat.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported, color: Colors.grey),
                        )
                      : const Icon(Icons.image, color: Colors.grey, size: 30),
                ),
              ),
              const SizedBox(width: 15),

              // 2. INFO ALAT (TENGAH)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alat.nama,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: roboto,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: Color.fromRGBO(49, 47, 52, 1),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Kode: ${alat.kode}',
                      style: const TextStyle(
                        fontFamily: roboto,
                        fontSize: 13,
                        color: Color.fromRGBO(72, 141, 117, 1),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // 3. BADGE UNIT (KANAN ATAS)
              _buildUnitBadge(totalUnit),
            ],
          ),

          if (alat.deskripsi != null && alat.deskripsi!.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color.fromRGBO(205, 238, 226, 1)),
            ),
            child: Text(
              alat.deskripsi!,
              style: const TextStyle(
                fontFamily: roboto,
                fontSize: 12,
                color: Colors.black87,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
          
          const SizedBox(height: 16),
          
          // 4. BARIS BAWAH (KATEGORI & TOMBOL AKSI)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildKategoriBadge(alat.kategoriNama),
              Row(
                children: [
                  _iconBtn(
                    Icons.visibility,
                    const Color.fromRGBO(236, 254, 248, 1),
                    iconColor: const Color.fromRGBO(62, 159, 127, 1),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailAlatPage(id: alat.id, alat: alat),
                        ),
                      ).then((_) => onRefresh());
                    },
                  ),
                  const SizedBox(width: 8),
                  _iconBtn(
                    Icons.edit,
                    const Color.fromRGBO(236, 254, 248, 1),
                    iconColor: const Color.fromRGBO(62, 159, 127, 1),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => FormAlatDialog(
                          isEdit: true,
                          alat: alat,
                          onRefresh: onRefresh,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  _iconBtn(
                    Icons.delete,
                    const Color.fromRGBO(255, 119, 119, 0.22),
                    iconColor: const Color.fromRGBO(255, 2, 2, 1),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => DeleteAlatDialog(
                          id: alat.id,
                          nama: alat.nama,
                          onDeleteSuccess: onRefresh,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _iconBtn(IconData icon, Color bg, {Color iconColor = Colors.black, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 18, color: iconColor),
      ),
    );
  }

  Widget _buildUnitBadge(String unit) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(217, 253, 240, 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inventory_2_outlined, size: 14, color: Color.fromRGBO(1, 85, 56, 1)),
          const SizedBox(width: 4),
          Text(
            '$unit Unit',
            style: const TextStyle(
              fontSize: 12,
              fontFamily: roboto,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(1, 85, 56, 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKategoriBadge(String nama) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(217, 253, 240, 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        nama,
        style: const TextStyle(
          fontSize: 12,
          fontFamily: roboto,
          color: Color.fromRGBO(1, 85, 56, 1),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

