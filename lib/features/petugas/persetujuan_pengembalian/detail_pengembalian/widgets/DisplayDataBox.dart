import 'package:flutter/material.dart';

const String roboto = 'Roboto';

class DisplayDataBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const DisplayDataBox({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: roboto,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color.fromRGBO(49, 47, 52, 1),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color.fromRGBO(205, 238, 226, 1),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value.isEmpty ? '-' : value,
                  style: const TextStyle(
                    fontFamily: roboto,
                    color: Color.fromRGBO(72, 141, 117, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (icon != null)
                Icon(
                  icon,
                  size: 18,
                  color: const Color.fromRGBO(62, 159, 127, 1),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
