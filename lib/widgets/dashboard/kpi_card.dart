import 'package:flutter/material.dart';

class KPICard extends StatelessWidget {
  final String title;

  final String value;

  final IconData icon;

  final Color color;

  const KPICard({
    super.key,

    required this.title,

    required this.value,

    required this.icon,

    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            blurRadius: 10,

            color: Colors.black12,

            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: color.withOpacity(.15),

              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(icon, color: color, size: 30),
          ),

          const SizedBox(width: 15),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(title, style: const TextStyle(color: Colors.grey)),

              const SizedBox(height: 5),

              Text(
                value,

                style: const TextStyle(
                  fontSize: 20,

                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
