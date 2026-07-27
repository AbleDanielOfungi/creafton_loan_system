import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/expenditure.dart';
import '../../providers/expenditure_provider.dart';
import '../../providers/expenditure_category_provider.dart';

class EditExpenditureScreen extends StatefulWidget {
  final Expenditure expenditure;

  const EditExpenditureScreen({super.key, required this.expenditure});

  @override
  State<EditExpenditureScreen> createState() => _EditExpenditureScreenState();
}

class _EditExpenditureScreenState extends State<EditExpenditureScreen> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController title;

  late TextEditingController amount;

  late TextEditingController reference;

  late TextEditingController description;

  late int categoryId;

  String? paymentMethod;

  late DateTime expenseDate;

  bool saving = false;

  @override
  void initState() {
    super.initState();

    final e = widget.expenditure;

    title = TextEditingController(text: e.title);

    amount = TextEditingController(text: e.amount.toString());

    reference = TextEditingController(text: e.referenceNumber ?? "");

    description = TextEditingController(text: e.description ?? "");

    categoryId = e.categoryId;

    paymentMethod = e.paymentMethod;

    expenseDate = DateTime.parse(e.expenseDate);

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

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      saving = true;
    });

    final updated = widget.expenditure.copyWith(
      categoryId: categoryId,

      title: title.text.trim(),

      amount: double.parse(amount.text),

      paymentMethod: paymentMethod,

      referenceNumber: reference.text.trim(),

      description: description.text.trim(),

      expenseDate: expenseDate.toIso8601String().substring(0, 10),
    );

    final success = await context.read<ExpenditureProvider>().updateExpenditure(
      updated,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
    }

    setState(() {
      saving = false;
    });
  }

  Widget field(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,

      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$label required";
        }

        return null;
      },

      decoration: InputDecoration(
        labelText: label,

        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Expenditure")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: formKey,

          child: Column(
            children: [
              Consumer<ExpenditureCategoryProvider>(
                builder: (context, provider, _) {
                  return DropdownButtonFormField<int>(
                    value: categoryId,

                    decoration: const InputDecoration(
                      labelText: "Category",

                      border: OutlineInputBorder(),
                    ),

                    items: provider.categories
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.id,

                            child: Text(c.name),
                          ),
                        )
                        .toList(),

                    onChanged: (value) {
                      setState(() {
                        categoryId = value!;
                      });
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              field("Title", title),

              const SizedBox(height: 16),

              TextFormField(
                controller: amount,

                keyboardType: TextInputType.number,

                decoration: const InputDecoration(
                  labelText: "Amount",

                  border: OutlineInputBorder(),
                ),
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

                onChanged: (v) {
                  setState(() {
                    paymentMethod = v;
                  });
                },
              ),

              const SizedBox(height: 16),

              field("Reference", reference),

              const SizedBox(height: 16),

              ListTile(
                title: Text("Date: ${expenseDate.toString().substring(0, 10)}"),

                leading: const Icon(Icons.calendar_month),

                onTap: () async {
                  final d = await showDatePicker(
                    context: context,

                    firstDate: DateTime(2020),

                    lastDate: DateTime(2100),

                    initialDate: expenseDate,
                  );

                  if (d != null) {
                    setState(() {
                      expenseDate = d;
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: description,

                maxLines: 3,

                decoration: const InputDecoration(
                  labelText: "Description",

                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,

                height: 50,

                child: ElevatedButton(
                  onPressed: saving ? null : save,

                  child: saving
                      ? const CircularProgressIndicator()
                      : const Text("UPDATE EXPENDITURE"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
