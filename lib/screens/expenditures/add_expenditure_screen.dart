import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/expenditure.dart';
import '../../models/expenditure_category.dart';

import '../../providers/expenditure_provider.dart';
import '../../providers/expenditure_category_provider.dart';

import '../../core/theme/app_colors.dart';

class AddExpenditureScreen extends StatefulWidget {
  const AddExpenditureScreen({super.key});

  @override
  State<AddExpenditureScreen> createState() => _AddExpenditureScreenState();
}

class _AddExpenditureScreenState extends State<AddExpenditureScreen> {
  final formKey = GlobalKey<FormState>();

  final title = TextEditingController();

  final amount = TextEditingController();

  final reference = TextEditingController();

  final description = TextEditingController();

  String? paymentMethod;

  int? selectedCategory;

  DateTime expenseDate = DateTime.now();

  bool saving = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpenditureCategoryProvider>().loadCategories();
    });
  }

  @override
  void dispose() {
    title.dispose();

    amount.dispose();

    reference.dispose();

    description.dispose();

    super.dispose();
  }

  Future<void> addCategoryDialog() async {
    final controller = TextEditingController();

    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),

          title: const Text("Add Expense Category"),

          content: TextField(
            controller: controller,

            decoration: InputDecoration(
              labelText: "Category Name",

              prefixIcon: const Icon(Icons.category),

              filled: true,

              fillColor: Colors.grey.shade50,

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {
                if (controller.text.trim().isEmpty) return;

                final category = ExpenditureCategory(
                  name: controller.text.trim(),

                  createdAt: DateTime.now().toIso8601String(),
                );

                await context.read<ExpenditureCategoryProvider>().addCategory(
                  category,
                );

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },

              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select category")));

      return;
    }

    setState(() {
      saving = true;
    });

    final expenditure = Expenditure(
      categoryId: selectedCategory!,

      title: title.text.trim(),

      amount: double.parse(amount.text),

      paymentMethod: paymentMethod,

      referenceNumber: reference.text.trim(),

      description: description.text.trim(),

      expenseDate: expenseDate.toIso8601String().substring(0, 10),

      createdAt: DateTime.now().toIso8601String(),
    );

    await context.read<ExpenditureProvider>().add(expenditure);

    if (!mounted) return;

    Navigator.pop(context);
  }

  Widget input({
    required String label,

    required TextEditingController controller,

    required IconData icon,

    TextInputType type = TextInputType.text,

    int lines = 1,
  }) {
    return TextFormField(
      controller: controller,

      keyboardType: type,

      maxLines: lines,

      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$label is required";
        }

        return null;
      },

      decoration: InputDecoration(
        labelText: label,

        prefixIcon: Icon(icon),

        filled: true,

        fillColor: Colors.grey.shade50,

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),

          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget sectionCard({required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 250.0),
      child: Card(
        elevation: 3,
        color: AppColors.background,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                title,

                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              ...children,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,

        foregroundColor: Colors.white,

        title: const Text("Register Expenditure"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: formKey,

          child: Column(
            children: [
              sectionCard(
                title: "Expense Information",

                children: [
                  Consumer<ExpenditureCategoryProvider>(
                    builder: (context, provider, _) {
                      return DropdownButtonFormField<int>(
                        value: selectedCategory,

                        decoration: InputDecoration(
                          labelText: "Category",

                          prefixIcon: const Icon(Icons.category),

                          filled: true,

                          fillColor: Colors.grey.shade50,

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),

                        items: provider.categories
                            .map(
                              (category) => DropdownMenuItem(
                                value: category.id,

                                child: Text(category.name),
                              ),
                            )
                            .toList(),

                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      );
                    },
                  ),

                  Align(
                    alignment: Alignment.centerRight,

                    child: TextButton.icon(
                      onPressed: addCategoryDialog,

                      icon: const Icon(Icons.add),

                      label: const Text("New Category"),
                    ),
                  ),

                  const SizedBox(height: 15),

                  input(
                    label: "Expense Title",

                    controller: title,

                    icon: Icons.title,
                  ),

                  const SizedBox(height: 16),

                  input(
                    label: "Amount (UGX)",

                    controller: amount,

                    icon: Icons.money,

                    type: TextInputType.number,
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: paymentMethod,

                    decoration: InputDecoration(
                      labelText: "Payment Method",

                      prefixIcon: const Icon(Icons.payment),

                      filled: true,

                      fillColor: Colors.grey.shade50,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    items: ["Cash", "Mobile Money", "Bank"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),

                    onChanged: (value) {
                      setState(() {
                        paymentMethod = value;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  input(
                    label: "Reference Number",

                    controller: reference,

                    icon: Icons.receipt,
                  ),

                  const SizedBox(height: 16),

                  input(
                    label: "Description",

                    controller: description,

                    icon: Icons.description,

                    lines: 3,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              sectionCard(
                title: "Date Information",

                children: [
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),

                    tileColor: Colors.grey.shade50,

                    leading: const Icon(Icons.calendar_month),

                    title: Text(
                      "Expense Date",

                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Text(
                      expenseDate.toIso8601String().substring(0, 10),
                    ),

                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,

                        firstDate: DateTime(2020),

                        lastDate: DateTime(2100),

                        initialDate: expenseDate,
                      );

                      if (date != null) {
                        setState(() {
                          expenseDate = date;
                        });
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 250.0),
                child: SizedBox(
                  width: double.infinity,

                  height: 55,

                  child: ElevatedButton.icon(
                    onPressed: saving ? null : save,

                    icon: saving
                        ? const SizedBox(
                            width: 22,

                            height: 22,

                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save),

                    label: Text(
                      saving ? "Saving..." : "SAVE EXPENDITURE",

                      style: const TextStyle(
                        fontSize: 16,

                        fontWeight: FontWeight.bold,
                      ),
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
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
