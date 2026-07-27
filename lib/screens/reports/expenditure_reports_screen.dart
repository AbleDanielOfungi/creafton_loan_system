import 'package:creafton_financial_services/services/services/expenditure_pdf_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/expenditure_provider.dart';
import '../../models/expenditure.dart';

class ExpenditureReportsScreen extends StatefulWidget {
  const ExpenditureReportsScreen({super.key});

  @override
  State<ExpenditureReportsScreen> createState() =>
      _ExpenditureReportsScreenState();
}

class _ExpenditureReportsScreenState extends State<ExpenditureReportsScreen> {
  final searchController = TextEditingController();

  DateTime? startDate;

  DateTime? endDate;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpenditureProvider>().loadExpenditures();
    });
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  Widget statisticCard(String title, double amount, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 3,

        child: Padding(
          padding: const EdgeInsets.all(18),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Icon(icon, size: 35),

              const SizedBox(height: 10),

              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),

              const SizedBox(height: 8),

              Text(
                "UGX ${amount.toStringAsFixed(0)}",

                style: const TextStyle(
                  fontSize: 20,

                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget reportButtons(){

  //   final provider =
  //   context.read<ExpenditureProvider>();

  //   return Wrap(

  //     spacing:10,

  //     children:[

  //       ElevatedButton.icon(

  //         icon:
  //         const Icon(Icons.today),

  //         label:
  //         const Text("Today"),

  //         onPressed:(){

  //           provider.generateDailyReport();

  //         },

  //       ),

  //       ElevatedButton.icon(

  //         icon:
  //         const Icon(Icons.date_range),

  //         label:
  //         const Text("Week"),

  //         onPressed:(){

  //           provider.generateWeeklyReport();

  //         },

  //       ),

  //       ElevatedButton.icon(

  //         icon:
  //         const Icon(Icons.calendar_month),

  //         label:
  //         const Text("Year"),

  //         onPressed:(){

  //           provider.generateYearlyReport();

  //         },

  //       ),

  //     ],

  //   );

  // }

  Widget reportButtons() {
    final provider = context.read<ExpenditureProvider>();

    return Wrap(
      spacing: 10,

      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.today),

          label: const Text("Today"),

          onPressed: () {
            provider.generateDailyReport();
          },
        ),

        ElevatedButton.icon(
          icon: const Icon(Icons.date_range),

          label: const Text("Week"),

          onPressed: () {
            provider.generateWeeklyReport();
          },
        ),

        ElevatedButton.icon(
          icon: const Icon(Icons.calendar_month),

          label: const Text("Year"),

          onPressed: () {
            provider.generateYearlyReport();
          },
        ),

        ElevatedButton.icon(
          icon: const Icon(Icons.filter_alt),

          label: Text(
            startDate == null
                ? "Custom Report"
                : "${startDate!.day}/${startDate!.month}/${startDate!.year}",
          ),

          onPressed: () async {
            await selectDateRange();

            if (startDate != null && endDate != null) {
              provider.generateCustomReport(startDate!, endDate!);
            }
          },
        ),
      ],
    );
  }

  Widget search() {
    return TextField(
      controller: searchController,

      decoration: const InputDecoration(
        hintText: "Search report...",

        prefixIcon: Icon(Icons.search),

        border: OutlineInputBorder(),
      ),

      onChanged: (value) {
        context.read<ExpenditureProvider>().search(value);
      },
    );
  }

  Widget table(List<Expenditure> data) {
    return Expanded(
      child: Card(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,

          child: DataTable(
            columns: [
              const DataColumn(label: Text("Date")),

              const DataColumn(label: Text("Title")),

              const DataColumn(label: Text("Amount")),

              const DataColumn(label: Text("Payment")),
            ],

            rows: data
                .map(
                  (e) => DataRow(
                    cells: [
                      DataCell(Text(e.expenseDate)),

                      DataCell(Text(e.title)),

                      DataCell(Text("UGX ${e.amount}")),

                      DataCell(Text(e.paymentMethod ?? "-")),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Future<void> selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,

      firstDate: DateTime(2020),

      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;

        endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Reports"),

        actions: [
          // IconButton(

          //   icon:
          //   const Icon(
          //       Icons.picture_as_pdf
          //   ),

          //   onPressed:(){

          //     // PDF export will be connected here

          //   },

          // ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),

            onPressed: () async {
              await ExpenditurePdfService.generate(
                context.read<ExpenditureProvider>().filtered,
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.table_view),

            onPressed: () {
              // Excel export will be connected here
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Consumer<ExpenditureProvider>(
          builder: (context, provider, child) {
            if (provider.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Row(
                  children: [
                    statisticCard("Total", provider.total, Icons.money),

                    statisticCard("Today", provider.todayTotal, Icons.today),

                    statisticCard(
                      "This Month",
                      provider.monthlyTotal,
                      Icons.calendar_month,
                    ),

                    statisticCard(
                      "This Year",
                      provider.yearlyTotal,
                      Icons.bar_chart,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                reportButtons(),
                if (startDate != null && endDate != null)
                  Padding(
                    padding: const EdgeInsets.all(10),

                    child: Text(
                      "Report Period: "
                      "${startDate!.toIso8601String().substring(0, 10)} "
                      "to "
                      "${endDate!.toIso8601String().substring(0, 10)}",

                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                const SizedBox(height: 20),

                search(),

                const SizedBox(height: 20),

                table(provider.filtered),
              ],
            );
          },
        ),
      ),
    );
  }
}
