import 'package:flutter/material.dart';

class SimpanButton extends StatelessWidget {
  final VoidCallback onPressed;
  
  const SimpanButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(62, 159, 127, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.save, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Text(
              'Simpan Pengembalian',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white
              ),
            ),
          ],
        ),
      ),
    );
  }
}