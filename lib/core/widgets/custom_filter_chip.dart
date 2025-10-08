import 'package:flutter/material.dart';

class CustomFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool)? onSelected;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? textColor;
  final double? borderRadius;

  const CustomFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    this.onSelected,
    this.backgroundColor,
    this.selectedColor,
    this.textColor,
    this.borderRadius = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : textColor ?? Colors.grey[400],
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: backgroundColor ?? const Color(0xFF1A1A1A),
      selectedColor: selectedColor ?? const Color(0xFF00B876),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius!),
        side: BorderSide(
          color: isSelected
              ? selectedColor ?? const Color(0xFF00B876)
              : const Color(0xFF333333),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      showCheckmark: false,
    );
  }
}
