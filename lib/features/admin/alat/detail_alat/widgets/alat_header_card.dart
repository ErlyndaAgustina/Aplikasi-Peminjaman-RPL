import 'package:flutter/material.dart';
import '../../models/models.dart';

const String roboto = 'Roboto';

class AlatHeaderCard extends StatelessWidget {
  final AlatModel? alat;
  final int count;

  const AlatHeaderCard({super.key, this.alat, this.count = 0});

  @override
  Widget build(BuildContext context) {
    // Handling state loading
    if (alat == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final String namaAlat = alat!.nama;
    final String kodeAlat = alat!.kode;
    final String kategori = alat!.kategoriNama;
    final String totalUnit = count.toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color.fromRGBO(205, 238, 226, 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. BOX GAMBAR (KIRI) - Persis AlatCard
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: alat!.imageUrl != null && alat!.imageUrl!.isNotEmpty
                      ? Image.network(
                          alat!.imageUrl!,
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
                      namaAlat,
                      style: const TextStyle(
                        fontFamily: roboto,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: Color.fromRGBO(49, 47, 52, 1),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Kode: $kodeAlat',
                      style: const TextStyle(
                        fontFamily: roboto,
                        fontSize: 14,
                        color: Color.fromRGBO(72, 141, 117, 1),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              // 3. BADGE UNIT (KANAN)
              _buildUnitBadge(totalUnit),
            ],
          ),

          // 4. DESKRIPSI (DI BAWAH IMAGE & INFO)
          if (alat!.deskripsi != null && alat!.deskripsi!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(248, 251, 249, 1), // Sedikit kontras
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color.fromRGBO(205, 238, 226, 1)),
              ),
              child: Text(
                alat!.deskripsi!,
                style: const TextStyle(
                  fontFamily: roboto,
                  fontSize: 13,
                  color: Colors.black87,
                  fontStyle: FontStyle.italic,
                  height: 1.4, // Agar lebih enak dibaca
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),

          // 5. KATEGORI BADGE
          Row(
            children: [
              _buildKategoriBadge(kategori),
            ],
          ),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS (Sesuai AlatCard) ---

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