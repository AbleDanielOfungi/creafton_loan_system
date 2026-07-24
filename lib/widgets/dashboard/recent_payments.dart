import 'package:flutter/material.dart';

class RecentPayments extends StatelessWidget {
  const RecentPayments({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            "Recent Payments",

            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          _payment("John Doe", "UGX 50,000"),

          _payment("Sarah N", "UGX 100,000"),

          _payment("Peter", "UGX 25,000"),
        ],
      ),
    );
  }

  Widget _payment(String name, String amount) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.person)),

      title: Text(name),

      trailing: Text(
        amount,

        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
