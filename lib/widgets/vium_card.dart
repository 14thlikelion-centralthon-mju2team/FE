import 'package:flutter/material.dart';

class ViumCard extends StatelessWidget {
  final Widget child;
  const ViumCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDEE1E0)),
      ),
      child: child,
    );
  }
}