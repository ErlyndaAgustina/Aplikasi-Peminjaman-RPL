import 'package:flutter/material.dart';
import 'models/model.dart';
import 'widgets/header_card.dart';
import 'widgets/info_peminjaman_card.dart';
import 'widgets/unit_peminjaman_card.dart';
import 'widgets/action_buttons.dart';

const String roboto = 'Roboto';

class DetailPeminjamanPage extends StatelessWidget {
  const DetailPeminjamanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = dummyDetailPeminjaman;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(234, 247, 242, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Color.fromRGBO(216, 199, 246, 1),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(217, 253, 240, 0.49),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color.fromRGBO(62, 159, 127, 1),
                    ),
                  ),
                ),

                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Detail Persetujuan',
                        style: TextStyle(
                          fontFamily: roboto,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(49, 47, 52, 1),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'RPLKIT • SMK Brantas Karangkates',
                        style: TextStyle(
                          fontFamily: roboto,
                          fontSize: 12,
                          color: Color.fromRGBO(72, 141, 117, 1),
                        ),
                      ),
                    ],
                  ),
                ),
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color.fromRGBO(217, 253, 240, 0.49),
                  child: Icon(
                    Icons.person,
                    color: Color.fromRGBO(62, 159, 127, 1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderCard(data: data),
              const SizedBox(height: 12),

              InfoPeminjamanCard(data: data),
              const SizedBox(height: 24),

              /// JUDUL LIST
              Row(
                children: [
                  const Text(
                    'Daftar Unit yang Dipinjam',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: roboto,
                      color: Color.fromRGBO(49, 47, 52, 1),
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(62, 159, 127, 1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${data.units.length} unit',
                      style: const TextStyle(
                        fontFamily: roboto,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              /// LIST UNIT
              ...data.units.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: UnitPeminjamanCard(unit: e),
                ),
              ),

              const SizedBox(height: 25),

              /// 🔥 ACTION BUTTON (HANYA MENUNGGU)
              if (data.status == StatusPeminjaman.menunggu) ...[
                ActionButtons(onApprove: () {}, onReject: () {}),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
