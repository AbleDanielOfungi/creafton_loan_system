import 'package:creafton_financial_services/screens/borrowers/borrower.dart';
import 'package:flutter/material.dart';

import '../../providers/borrower_provider.dart';

import 'package:provider/provider.dart';

class AddBorrowerScreen extends StatefulWidget {
  const AddBorrowerScreen({super.key});

  @override
  State<AddBorrowerScreen> createState() => _AddBorrowerScreenState();
}

class _AddBorrowerScreenState extends State<AddBorrowerScreen> {
  final name = TextEditingController();

  final phone = TextEditingController();

  final nationalId = TextEditingController();

  final district = TextEditingController();

  final occupation = TextEditingController();

  void save() async {
    final borrower = Borrower(
      borrowerNumber: "CR${DateTime.now().millisecondsSinceEpoch}",

      fullName: name.text,

      phone: phone.text,

      nationalId: nationalId.text,

      district: district.text,

      occupation: occupation.text,

      createdAt: DateTime.now().toIso8601String(),
    );

    await context.read<BorrowerProvider>().addBorrower(borrower);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Borrower")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),

        child: Column(
          children: [
            TextField(
              controller: name,

              decoration: const InputDecoration(labelText: "Full Name"),
            ),

            TextField(
              controller: phone,

              decoration: const InputDecoration(labelText: "Phone Number"),
            ),

            TextField(
              controller: nationalId,

              decoration: const InputDecoration(labelText: "National ID"),
            ),

            TextField(
              controller: district,

              decoration: const InputDecoration(labelText: "District"),
            ),

            TextField(
              controller: occupation,

              decoration: const InputDecoration(labelText: "Occupation"),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: save,

                child: const Text("SAVE BORROWER"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
