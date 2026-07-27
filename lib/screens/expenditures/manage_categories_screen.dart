import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/expenditure_category.dart';
import '../../providers/expenditure_category_provider.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpenditureCategoryProvider>().loadCategories();
    });
  }

  void addCategory() {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text("New Category"),

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
                await context.read<ExpenditureCategoryProvider>().addCategory(
                  ExpenditureCategory(
                    name: controller.text,

                    createdAt: DateTime.now().toIso8601String(),
                  ),
                );

                controller.clear();

                Navigator.pop(context);
              },

              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Expense Categories")),

      floatingActionButton: FloatingActionButton(
        onPressed: addCategory,

        child: const Icon(Icons.add),
      ),

      body: Consumer<ExpenditureCategoryProvider>(
        builder: (context, provider, _) {
          return ListView.builder(
            itemCount: provider.categories.length,

            itemBuilder: (context, index) {
              final category = provider.categories[index];

              return Card(
                child: ListTile(
                  title: Text(category.name),

                  trailing: IconButton(
                    icon: const Icon(Icons.delete),

                    onPressed: () {},
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
