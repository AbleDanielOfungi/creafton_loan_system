import 'package:flutter/material.dart';

class StatusHelper {
  static Color borrowerStatusColor(String status) {
    switch (status.toUpperCase()) {
      case "ACTIVE":
        return Colors.green;

      case "CLEARED":
        return Colors.blue;

      case "DEFAULTED":
        return Colors.red;

      case "SUSPENDED":
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }
}
