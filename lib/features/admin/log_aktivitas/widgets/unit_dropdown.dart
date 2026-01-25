import 'package:flutter/material.dart';

const String roboto = 'Roboto';

class UnitDropdown extends StatefulWidget {
  final String alat;
  final String unit;
  const UnitDropdown({super.key, required this.alat, required this.unit});

  @override
  State<UnitDropdown> createState() => _UnitDropdownState();
}

class _UnitDropdownState extends State<UnitDropdown> {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => setState(() => open = !open),
              child: Container(
                width: constraints.maxWidth,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(217, 253, 240, 1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color.fromRGBO(205, 238, 226, 1),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Lihat Unit Alat',
                      style: TextStyle(
                        fontFamily: roboto,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Color.fromRGBO(72, 141, 117, 1),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      open
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: const Color.fromRGBO(72, 141, 117, 1),
                    ),
                  ],
                ),
              ),
            ),

            if (open)
              Container(
                width: double.infinity, // ⬅️ lebar sama
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(217, 253, 240, 1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color.fromRGBO(205, 238, 226, 1),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // nama alat
                    Text(
                      widget.alat,
                      style: const TextStyle(
                        fontFamily: roboto,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Color.fromRGBO(72, 141, 117, 1),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // unit
                    Text(
                      widget.unit,
                      style: const TextStyle(
                        fontFamily: roboto,
                        fontSize: 11,
                        color: Color.fromRGBO(75, 85, 99, 1),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
