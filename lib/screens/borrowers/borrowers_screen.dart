//borrowers_screen.dart
import 'package:creafton_financial_services/screens/borrowers/borrower.dart';
import 'package:creafton_financial_services/screens/borrowers/edit_borrower_screen.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/status_helper.dart';
import '../../providers/borrower_provider.dart';

import 'add_borrower_screen.dart';
import 'borrower_profile_screen.dart';

class BorrowersScreen extends StatefulWidget {
  const BorrowersScreen({super.key});

  @override
  State<BorrowersScreen> createState() => _BorrowersScreenState();
}

class _BorrowersScreenState extends State<BorrowersScreen> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BorrowerProvider>().loadBorrowers();
    });
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),

      color: Colors.grey.shade100,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          _header(),

          const SizedBox(height: 25),

          _summaryCards(),

          const SizedBox(height: 25),

          _search(),

          const SizedBox(height: 20),

          Expanded(child: _borrowerTable()),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Borrowers Management",

              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            Text(
              "Manage borrower profiles, loans and repayments",

              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),

        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,

            foregroundColor: Colors.white,

            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),

          icon: const Icon(Icons.person_add),

          label: const Text("New Borrower"),

          onPressed: () {
            Navigator.push(
              context,

              MaterialPageRoute(builder: (_) => const AddBorrowerScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _summaryCards() {
    return Consumer<BorrowerProvider>(
      builder: (context, provider, _) {
        return Row(
          children: [
            _summaryCard(
              "Total Borrowers",

              provider.borrowers.length.toString(),

              Icons.people,

              AppColors.primaryBlue,
            ),

            const SizedBox(width: 20),

            _summaryCard(
              "Active",

              provider.borrowers
                  .where((e) => e.status == "ACTIVE")
                  .length
                  .toString(),

              Icons.check_circle,

              Colors.green,
            ),

            const SizedBox(width: 20),

            _summaryCard(
              "Cleared",

              provider.borrowers
                  .where((e) => e.status == "CLEARED")
                  .length
                  .toString(),

              Icons.done_all,

              Colors.blue,
            ),
          ],
        );
      },
    );
  }

  //delete borrower dialog

  Future<void> _showDeleteDialog(Borrower borrower) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Row(
            children: [
              // Icon(
              //   Icons.warning_amber_rounded,
              //   color: Colors.red,
              // ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {
                  _showDeleteDialog(borrower);
                },
              ),
              const SizedBox(width: 10),
              const Text("Delete Borrower"),
            ],
          ),
          content: Text(
            "Delete ${borrower.fullName}?\n\n"
            "This action cannot be undone.",
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context, false),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Delete"),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    final provider = context.read<BorrowerProvider>();

    final success = await provider.deleteBorrower(borrower.id!);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Borrower deleted successfully"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(provider.error ?? "Unable to delete borrower."),
        ),
      );
    }
  }

  Widget _summaryCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(15),

          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10),
          ],
        ),

        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(.15),

              child: Icon(icon, color: color),
            ),

            const SizedBox(width: 15),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(title, style: TextStyle(color: Colors.grey.shade600)),

                Text(
                  value,

                  style: const TextStyle(
                    fontSize: 26,

                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _search() {
    return TextField(
      controller: searchController,

      decoration: InputDecoration(
        hintText: "Search borrower by name, phone or ID",

        prefixIcon: const Icon(Icons.search),

        filled: true,

        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _borrowerTable() {
    return Consumer<BorrowerProvider>(
      builder: (context, provider, _) {
        if (provider.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.borrowers.isEmpty) {
          return const Center(child: Text("No borrowers registered"));
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(15),
          ),

          child: DataTable2(
            columnSpacing: 25,

            headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),

            columns: const [
              DataColumn(label: Text("Borrower ID")),

              DataColumn(label: Text("Name")),

              DataColumn(label: Text("Phone")),

              DataColumn(label: Text("Status")),

              DataColumn(label: Text("Actions")),
            ],

            rows: provider.borrowers.map((borrower) {
              return DataRow(
                cells: [
                  DataCell(Text(borrower.borrowerNumber)),

                  DataCell(Text(borrower.fullName)),

                  DataCell(Text(borrower.phone)),

                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,

                        vertical: 5,
                      ),

                      decoration: BoxDecoration(
                        color: StatusHelper.borrowerStatusColor(
                          borrower.status,
                        ).withOpacity(.15),

                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Text(
                        borrower.status,

                        style: TextStyle(
                          color: StatusHelper.borrowerStatusColor(
                            borrower.status,
                          ),

                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          tooltip: "View Profile",

                          icon: const Icon(
                            Icons.visibility,

                            color: AppColors.primaryBlue,
                          ),

                          onPressed: () {
                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (_) =>
                                    BorrowerProfileScreen(borrower: borrower),
                              ),
                            );
                          },
                        ),

                        IconButton(
                          tooltip: "More Actions",

                          icon: const Icon(Icons.more_vert),

                          onPressed: () {
                            _showActions(context, borrower);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showActions(BuildContext context, borrower) {
    showModalBottomSheet(
      context: context,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),

      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            ListTile(
              leading: const Icon(Icons.account_circle),

              title: const Text("View Profile"),

              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) => BorrowerProfileScreen(borrower: borrower),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.money),

              title: const Text("Create Loan"),

              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.payment),

              title: const Text("Record Payment"),

              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.edit),

              title: const Text("Edit Borrower"),

              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) => BorrowerProfileScreen(borrower: borrower),
                  ),
                );
              },
            ),

            IconButton(
              icon: const Icon(
                Icons.edit_outlined,
                color: AppColors.primaryBlue,
              ),
              tooltip: "Edit Borrower",
              onPressed: () async {
                final updated = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditBorrowerScreen(borrower: borrower),
                  ),
                );

                if (updated == true && context.mounted) {
                  await context.read<BorrowerProvider>().loadBorrowers();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Borrower updated successfully"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            ),

            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                _showDeleteDialog(borrower);
              },
            ),
          ],
        );
      },
    );
  }
}
