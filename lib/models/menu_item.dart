import 'package:flutter/material.dart';

class MenuItem {
  final String name;
  final String description;
  final double price;
  final String category;
  final IconData icon;

  const MenuItem({
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.icon,
  });
}

String formatPrice(double value) =>
    'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
