// import 'package:flutter/material.dart';
// import 'package:creafton_financial_services/database/database_helper.dart';
// import 'package:creafton_financial_services/models/guarantor.dart';
// import 'package:creafton_financial_services/providers/guarantor_provider.dart';
// import 'package:provider/provider.dart';

// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// class AddGuarantorScreen extends StatefulWidget {
//   const AddGuarantorScreen({super.key});

//   @override
//   State<AddGuarantorScreen> createState() => _AddGuarantorScreenState();
// }

// class _AddGuarantorScreenState extends State<AddGuarantorScreen> {
//   final borrowerController = TextEditingController();

//   final nameController = TextEditingController();

//   final relationshipController = TextEditingController();

//   final phoneController = TextEditingController();

//   final nationalIdController = TextEditingController();

//   final addressController = TextEditingController();

//   int? selectedBorrowerId;

//   String? selectedBorrowerName;

//   List<Map<String, dynamic>> borrowers = [];

//   Future<void> searchBorrower(String value) async {
//     value = value.trim();

//     if (value.isEmpty) {
//       setState(() {
//         borrowers = [];
//       });

//       return;
//     }

//     final db = await DatabaseHelper.database;

//     final result = await db.rawQuery(
//       '''
//     SELECT
//       id,
//       full_name,
//       phone,
//       borrower_number

//     FROM borrowers

//     WHERE LOWER(TRIM(full_name))
//     LIKE ?

//     ORDER BY full_name ASC

//     LIMIT 20

//     ''',

//       ["${value.toLowerCase()}%"],
//     );

//     setState(() {
//       borrowers = result;
//     });
//   }

//   void selectBorrower(Map<String, dynamic> borrower) {
//     setState(() {
//       selectedBorrowerId = borrower['id'];

//       selectedBorrowerName = borrower['full_name'];

//       borrowerController.text = borrower['full_name'];

//       borrowers = [];
//     });
//   }

//   Future<void> save() async {
//     if (selectedBorrowerId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select borrower first")),
//       );

//       return;
//     }

//     final guarantor = Guarantor(
//       borrowerId: selectedBorrowerId!,

//       fullName: nameController.text.trim(),

//       relationship: relationshipController.text.trim(),

//       phone: phoneController.text.trim(),

//       nationalId: nationalIdController.text.trim(),

//       address: addressController.text.trim(),

//       createdAt: DateTime.now().toIso8601String(),
//     );

//     final success = await Provider.of<GuarantorProvider>(
//       context,
//       listen: false,
//     ).addGuarantor(guarantor);

//     if (success && mounted) {
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Add Guarantor")),

//       body: ListView(
//         padding: const EdgeInsets.all(16),

//         children: [
//           // BORROWER SEARCH
//           TextField(
//             controller: borrowerController,

//             decoration: const InputDecoration(
//               labelText: "Search Borrower Name",

//               prefixIcon: Icon(Icons.person_search),

//               border: OutlineInputBorder(),
//             ),

//             onChanged: searchBorrower,
//           ),

//           const SizedBox(height: 10),

//           if (borrowers.isNotEmpty)
//             Card(
//               child: Column(
//                 children: borrowers.map((borrower) {
//                   return ListTile(
//                     title: Text(borrower['full_name']),

//                     subtitle: Text(borrower['phone'] ?? ""),

//                     onTap: () {
//                       selectBorrower(borrower);
//                     },
//                   );
//                 }).toList(),
//               ),
//             ),

//           if (selectedBorrowerName != null)
//             ListTile(
//               leading: const Icon(Icons.check_circle, color: Colors.green),

//               title: Text(selectedBorrowerName!),

//               subtitle: Text("Borrower ID: $selectedBorrowerId"),
//             ),

//           const SizedBox(height: 20),

//           TextField(
//             controller: nameController,

//             decoration: const InputDecoration(
//               labelText: "Guarantor Full Name",

//               border: OutlineInputBorder(),
//             ),
//           ),

//           TextField(
//             controller: relationshipController,

//             decoration: const InputDecoration(
//               labelText: "Relationship",

//               border: OutlineInputBorder(),
//             ),
//           ),

//           TextField(
//             controller: phoneController,

//             decoration: const InputDecoration(
//               labelText: "Phone",

//               border: OutlineInputBorder(),
//             ),
//           ),

//           TextField(
//             controller: nationalIdController,

//             decoration: const InputDecoration(
//               labelText: "National ID",

//               border: OutlineInputBorder(),
//             ),
//           ),

//           TextField(
//             controller: addressController,

//             maxLines: 3,

//             decoration: const InputDecoration(
//               labelText: "Address",

//               border: OutlineInputBorder(),
//             ),
//           ),

//           const SizedBox(height: 25),

//           ElevatedButton(onPressed: save, child: const Text("Save Guarantor")),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../database/database_helper.dart';
import '../../models/guarantor.dart';
import '../../providers/guarantor_provider.dart';

class AddGuarantorScreen extends StatefulWidget {
  const AddGuarantorScreen({super.key});

  @override
  State<AddGuarantorScreen> createState() => _AddGuarantorScreenState();
}

class _AddGuarantorScreenState extends State<AddGuarantorScreen> {
  final borrowerController = TextEditingController();

  final nameController = TextEditingController();

  final relationshipController = TextEditingController();

  final phoneController = TextEditingController();

  final nationalIdController = TextEditingController();

  final addressController = TextEditingController();

  Timer? searchTimer;

  int? selectedBorrowerId;

  String? selectedBorrowerName;

  List<Map<String, dynamic>> borrowers = [];

  bool saving = false;

  @override
  void dispose() {
    searchTimer?.cancel();

    borrowerController.dispose();

    nameController.dispose();

    relationshipController.dispose();

    phoneController.dispose();

    nationalIdController.dispose();

    addressController.dispose();

    super.dispose();
  }

  Future<void> searchBorrower(String value) async {
    searchTimer?.cancel();

    searchTimer = Timer(const Duration(milliseconds: 400), () async {
      value = value.trim();

      if (value.isEmpty) {
        setState(() {
          borrowers = [];
        });

        return;
      }

      final db = await DatabaseHelper.database;

      final result = await db.rawQuery(
        '''

              SELECT

              id,

              full_name,

              phone,

              borrower_number


              FROM borrowers


              WHERE

              LOWER(TRIM(full_name))
              LIKE ?


              OR LOWER(TRIM(phone))
              LIKE ?


              OR LOWER(TRIM(borrower_number))
              LIKE ?


              ORDER BY full_name ASC


              LIMIT 20


              ''',

        [
          "%${value.toLowerCase()}%",

          "%${value.toLowerCase()}%",

          "%${value.toLowerCase()}%",
        ],
      );

      if (mounted) {
        setState(() {
          borrowers = result;
        });
      }
    });
  }

  void selectBorrower(Map<String, dynamic> borrower) {
    setState(() {
      selectedBorrowerId = borrower['id'];

      selectedBorrowerName = borrower['full_name'];

      borrowerController.text = borrower['full_name'];

      borrowers = [];
    });
  }

  Future<void> save() async {
    if (selectedBorrowerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select borrower first")),
      );

      return;
    }

    setState(() {
      saving = true;
    });

    final guarantor = Guarantor(
      borrowerId: selectedBorrowerId!,

      fullName: nameController.text.trim(),

      relationship: relationshipController.text.trim(),

      phone: phoneController.text.trim(),

      nationalId: nationalIdController.text.trim(),

      address: addressController.text.trim(),

      createdAt: DateTime.now().toIso8601String(),
    );

    final success = await context.read<GuarantorProvider>().addGuarantor(
      guarantor,
    );

    setState(() {
      saving = false;
    });

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  Widget inputField({
    required String label,

    required IconData icon,

    required TextEditingController controller,

    Function(String)? onChanged,

    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),

      child: TextField(
        controller: controller,

        maxLines: maxLines,

        onChanged: onChanged,

        decoration: InputDecoration(
          labelText: label,

          prefixIcon: Icon(icon),

          filled: true,

          fillColor: const Color(0xFFF8FAFC),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),

            borderSide: BorderSide(color: Colors.grey.shade300),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),

            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),

      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,

        foregroundColor: Colors.white,

        title: const Text("Add Guarantor"),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),

          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),

            padding: const EdgeInsets.all(35),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(24),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.06),

                  blurRadius: 30,

                  offset: const Offset(0, 10),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  "Guarantor Information",

                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 25),

                inputField(
                  label: "Search Borrower",

                  icon: Icons.person_search,

                  controller: borrowerController,

                  onChanged: searchBorrower,
                ),

                if (borrowers.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(14),

                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,

                          color: Colors.black.withOpacity(.1),
                        ),
                      ],
                    ),

                    child: Column(
                      children: borrowers.map((borrower) {
                        return ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),

                          title: Text(borrower['full_name']),

                          subtitle: Text(
                            "${borrower['phone'] ?? ''}\n"
                            "${borrower['borrower_number'] ?? ''}",
                          ),

                          onTap: () {
                            selectBorrower(borrower);
                          },
                        );
                      }).toList(),
                    ),
                  ),

                if (selectedBorrowerName != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),

                    padding: const EdgeInsets.all(15),

                    decoration: BoxDecoration(
                      color: Colors.green.shade50,

                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Text(
                            selectedBorrowerName!,

                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                inputField(
                  label: "Guarantor Full Name",

                  icon: Icons.person,

                  controller: nameController,
                ),

                inputField(
                  label: "Relationship",

                  icon: Icons.family_restroom,

                  controller: relationshipController,
                ),

                inputField(
                  label: "Phone Number",

                  icon: Icons.phone,

                  controller: phoneController,
                ),

                inputField(
                  label: "National ID",

                  icon: Icons.badge,

                  controller: nationalIdController,
                ),

                inputField(
                  label: "Address",

                  icon: Icons.home,

                  controller: addressController,

                  maxLines: 3,
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,

                  height: 55,

                  child: ElevatedButton.icon(
                    onPressed: saving ? null : save,

                    icon: saving
                        ? const SizedBox(
                            height: 20,

                            width: 20,

                            child: CircularProgressIndicator(
                              color: Colors.white,

                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.save),

                    label: Text(
                      saving ? "Saving..." : "SAVE GUARANTOR",

                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,

                      foregroundColor: Colors.white,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
