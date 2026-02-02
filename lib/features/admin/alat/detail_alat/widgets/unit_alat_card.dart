import 'package:flutter/material.dart';
import 'delete_confirm_dialog.dart';
import 'form_unit_dialog.dart';
import '../models/model.dart';
import 'status_badge.dart';

const String roboto = 'Roboto';

class UnitAlatCard extends StatelessWidget {
  final UnitAlatModel unit;
  final VoidCallback onRefresh;

  const UnitAlatCard({super.key, required this.unit, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Color.fromRGBO(205, 238, 226, 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Unit ${unit.kodeUnit}',
                  style: const TextStyle(
                    fontFamily: roboto,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Color.fromRGBO(49, 47, 52, 1),
                  ),
                ),
              ),
              StatusBadge(status: unit.status),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Kondisi: ${unit.kondisi}',
            style: const TextStyle(
              fontFamily: roboto,
              fontSize: 12,
              color: Color.fromRGBO(72, 141, 117, 1),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => FormUnitDialog(
                        isEdit: true,
                        unit: unit,
                        onRefresh: onRefresh,
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color.fromRGBO(72, 141, 117, 1),
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(
                    Icons.edit,
                    size: 16,
                    color: Color.fromRGBO(1, 85, 56, 1),
                  ),
                  label: const Text(
                    'Edit',
                    style: TextStyle(
                      color: Color.fromRGBO(1, 85, 56, 1),
                      fontFamily: roboto,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => DeleteConfirmDialog(
                        idUnit: unit.idUnit,
                        onDeleteSuccess: onRefresh,
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color.fromRGBO(255, 2, 2, 1),
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(
                    Icons.delete,
                    size: 16,
                    color: Color.fromRGBO(255, 2, 2, 1),
                  ),
                  label: const Text(
                    'Hapus',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 2, 2, 1),
                      fontFamily: roboto,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
