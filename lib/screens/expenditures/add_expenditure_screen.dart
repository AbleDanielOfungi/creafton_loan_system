import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/expenditure.dart';
import '../../models/expenditure_category.dart';

import '../../providers/expenditure_provider.dart';
import '../../providers/expenditure_category_provider.dart';

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
          title: const Text("Add Expense Category"),

          content: TextField(
            controller: controller,

            decoration: const InputDecoration(labelText: "Category Name"),
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

  Widget field({
    required String label,

    required TextEditingController controller,

    IconData? icon,

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

        prefixIcon: icon == null ? null : Icon(icon),

        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Expenditure")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: formKey,

          child: Column(
            children: [
              Consumer<ExpenditureCategoryProvider>(
                builder: (context, provider, _) {
                  return Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: selectedCategory,

                          decoration: const InputDecoration(
                            labelText: "Category",

                            border: OutlineInputBorder(),
                          ),

                          items: provider.categories
                              .map(
                                (category) => DropdownMenuItem<int>(
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
                        ),
                      ),

                      IconButton(
                        tooltip: "Add Category",

                        icon: const Icon(Icons.add_circle),

                        onPressed: addCategoryDialog,
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),

              field(
                label: "Expense Title",

                controller: title,

                icon: Icons.title,
              ),

              const SizedBox(height: 16),

              field(
                label: "Amount (UGX)",

                controller: amount,

                type: TextInputType.number,

                icon: Icons.money,
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: paymentMethod,

                decoration: const InputDecoration(
                  labelText: "Payment Method",

                  border: OutlineInputBorder(),
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

              field(
                label: "Reference Number",

                controller: reference,

                icon: Icons.receipt,
              ),

              const SizedBox(height: 16),

              ListTile(
                contentPadding: EdgeInsets.zero,

                leading: const Icon(Icons.calendar_month),

                title: Text(
                  "Expense Date: "
                  "${expenseDate.toString().substring(0, 10)}",
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

              const SizedBox(height: 16),

              field(
                label: "Description",

                controller: description,

                lines: 3,

                icon: Icons.description,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,

                height: 50,

                child: ElevatedButton(
                  onPressed: saving ? null : save,

                  child: saving
                      ? const CircularProgressIndicator()
                      : const Text("SAVE EXPENDITURE"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
