import 'package:flutter/material.dart';

const String roboto = 'Roboto';

class ActionButtons extends StatelessWidget {
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const ActionButtons({
    super.key,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton.icon(
            onPressed: onApprove,
            icon: const Icon(Icons.check_circle, color: Colors.white),
            label: const Text(
              'Setujui Peminjaman',
              style: TextStyle(
                fontFamily: roboto,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(62, 159, 127, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 38,
          child: OutlinedButton(
            onPressed: onReject,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color.fromRGBO(255, 2, 2, 1)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Tolak Peminjaman',
              style: TextStyle(
                fontFamily: roboto,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(255, 2, 2, 1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
