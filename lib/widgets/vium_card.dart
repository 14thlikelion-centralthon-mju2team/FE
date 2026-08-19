import "package:flutter/material.dart";
import "../theme/ensom_colors.dart";

class ViumCard extends StatelessWidget {
  final Widget child;
  const ViumCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EnsomColors.surface1,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EnsomColors.hairline),
      ),
      child: child,
    );
  }
}
