import 'package:flutter/material.dart';

// MODELOS
class AllocationItem {
  final String name;
  final double percent;
  final Color color;

  AllocationItem(this.name, this.percent, this.color);
}

class LineDataItem {
  final String label;
  final double value;

  LineDataItem(this.label, this.value);
}

class HoldingItem {
  final String label;
  final double value;
  final Color color;
  final String iconPath;
  HoldingItem({
    required this.label,
    required this.value,
    required this.color,
    required this.iconPath,
  });
}
