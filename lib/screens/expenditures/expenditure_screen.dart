// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:data_table_2/data_table_2.dart';

// import '../../providers/expenditure_provider.dart';
// import '../../models/expenditure.dart';

// import 'add_expenditure_screen.dart';
// import 'edit_expenditure_screen.dart';

// class ExpendituresScreen extends StatefulWidget {

//   const ExpendituresScreen({
//     super.key,
//   });

//   @override
//   State<ExpendituresScreen> createState() =>
//       _ExpendituresScreenState();

// }

// class _ExpendituresScreenState
//     extends State<ExpendituresScreen> {

//   final TextEditingController searchController =
//       TextEditingController();

//   @override
//   void initState(){

//     super.initState();

//     WidgetsBinding.instance
//         .addPostFrameCallback((_) {

//       context
//           .read<ExpenditureProvider>()
//           .loadExpenditures();

//     });

//   }

//   @override
//   void dispose(){

//     searchController.dispose();

//     super.dispose();

//   }

//   String money(double value){

//     return "UGX ${value.toStringAsFixed(0)}";

//   }

//   void openAdd() async{

//     await Navigator.push(

//       context,

//       MaterialPageRoute(

//         builder:(_)=>
//         const AddExpenditureScreen(),

//       ),

//     );

//     if(!mounted)return;

//     context
//         .read<ExpenditureProvider>()
//         .loadExpenditures();

//   }

//   @override
//   Widget build(BuildContext context){

//     return Scaffold(

//       appBar: AppBar(

//         title:
//         const Text(
//           "Expenditures",
//         ),

//         actions:[

//           IconButton(

//             icon:
//             const Icon(
//               Icons.refresh,
//             ),

//             onPressed:(){

//               context
//                   .read<ExpenditureProvider>()
//                   .loadExpenditures();

//             },

//           )

//         ],

//       ),

//       floatingActionButton:

//       FloatingActionButton.extended(

//         onPressed:
//         openAdd,

//         icon:
//         const Icon(
//           Icons.add,
//         ),

//         label:
//         const Text(
//           "Add Expense",
//         ),

//       ),

//       body:

//       Consumer<ExpenditureProvider>(

//         builder:
//         (
//             context,
//             provider,
//             child
//             ){

//           if(provider.loading){

//             return const Center(

//               child:
//               CircularProgressIndicator(),

//             );

//           }

//           return Padding(

//             padding:
//             const EdgeInsets.all(16),

//             child:
//             Column(

//               children:[

//                 _statistics(provider),

//                 const SizedBox(
//                   height:20,
//                 ),

//                 _search(provider),

//                 const SizedBox(
//                   height:20,
//                 ),

//                 Expanded(

//                   child:
//                   _table(provider),

//                 )

//               ],

//             ),

//           );

//         },

//       ),

//     );

//   }

//   Widget _statistics(
//       ExpenditureProvider provider
//       ){

//     return Row(

//       children:[

//         Expanded(

//           child:
//           _card(

//               "Total Expenses",

//               money(
//                   provider.total
//               ),

//               Icons.money

//           ),

//         ),

//         const SizedBox(
//           width:12,
//         ),

//         Expanded(

//           child:
//           _card(

//               "This Month",

//               money(
//                   provider.monthlyTotal
//               ),

//               Icons.calendar_month

//           ),

//         ),

//         const SizedBox(
//           width:12,
//         ),

//         Expanded(

//           child:
//           _card(

//               "Today",

//               money(
//                   provider.todayTotal
//               ),

//               Icons.today

//           ),

//         ),

//       ],

//     );

//   }

//   Widget _card(
//       String title,
//       String value,
//       IconData icon
//       ){

//     return Card(

//       elevation:3,

//       child:
//       Padding(

//         padding:
//         const EdgeInsets.all(18),

//         child:
//         Column(

//           crossAxisAlignment:
//           CrossAxisAlignment.start,

//           children:[

//             Icon(icon),

//             const SizedBox(
//               height:10,
//             ),

//             Text(

//               title,

//               style:
//               const TextStyle(

//                 fontSize:14,

//               ),

//             ),

//             const SizedBox(
//               height:5,
//             ),

//             Text(

//               value,

//               style:
//               const TextStyle(

//                 fontWeight:
//                 FontWeight.bold,

//                 fontSize:18,

//               ),

//             )

//           ],

//         ),

//       ),

//     );

//   }

//   Widget _search(
//       ExpenditureProvider provider
//       ){

//     return TextField(

//       controller:
//       searchController,

//       decoration:
//       InputDecoration(

//         hintText:
//         "Search expenditure",

//         prefixIcon:
//         const Icon(
//           Icons.search,
//         ),

//         border:
//         OutlineInputBorder(

//           borderRadius:
//           BorderRadius.circular(12),

//         ),

//       ),

//       onChanged:
//       (value){

//         provider.search(value);

//       },

//     );

//   }

//   Widget _table(
//       ExpenditureProvider provider
//       ){

//     if(provider.filtered.isEmpty){

//       return const Center(

//         child:
//         Text(
//           "No expenditures found",
//         ),

//       );

//     }

//     return Container(

//       decoration:
//       BoxDecoration(

//         color:
//         Colors.white,

//         borderRadius:
//         BorderRadius.circular(15),

//       ),

//       child:
//       DataTable2(

//         columnSpacing:
//         25,

//         headingRowColor:

//         WidgetStateProperty.all(
//             Colors.grey.shade200
//         ),

//         columns:[

//           const DataColumn(
//               label:
//               Text("Title")
//           ),

//           const DataColumn(
//               label:
//               Text("Amount")
//           ),

//           const DataColumn(
//               label:
//               Text("Payment")
//           ),

//           const DataColumn(
//               label:
//               Text("Date")
//           ),

//           const DataColumn(
//               label:
//               Text("Actions")
//           ),

//         ],

//         rows:

//         provider.filtered
//             .map(

//                 (Expenditure expense){

//               return DataRow(

//                 cells:[

//                   DataCell(

//                     Text(
//                       expense.title,
//                     ),

//                   ),

//                   DataCell(

//                     Text(

//                       money(
//                           expense.amount
//                       ),

//                     ),

//                   ),

//                   DataCell(

//                     Text(

//                       expense.paymentMethod ??
//                           "-",

//                     ),

//                   ),

//                   DataCell(

//                     Text(

//                       expense.expenseDate,

//                     ),

//                   ),

//                   DataCell(

//                     Row(

//                       children:[

//                         IconButton(

//                           icon:
//                           const Icon(
//                               Icons.edit
//                           ),

//                           onPressed:(){

//                             Navigator.push(

//                               context,

//                               MaterialPageRoute(

//                                 builder:(_)=>

//                                 EditExpenditureScreen(

//                                   expenditure:
//                                   expense,

//                                 ),

//                               ),

//                             );

//                           },

//                         ),

//                         IconButton(

//                           icon:
//                           const Icon(
//                             Icons.delete,
//                           ),

//                           onPressed:()async{

//                             await provider
//                                 .delete(
//                                 expense.id!
//                             );

//                           },

//                         )

//                       ],

//                     ),

//                   )

//                 ],

//               );

//             })

//             .toList(),

//       ),

//     );

//   }

// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:data_table_2/data_table_2.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/expenditure_provider.dart';
import '../../models/expenditure.dart';

import 'add_expenditure_screen.dart';
import 'edit_expenditure_screen.dart';

class ExpendituresScreen extends StatefulWidget {
  const ExpendituresScreen({super.key});

  @override
  State<ExpendituresScreen> createState() => _ExpendituresScreenState();
}

class _ExpendituresScreenState extends State<ExpendituresScreen> {
  final TextEditingController searchController = TextEditingController();

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

  String money(double value) {
    return "UGX ${value.toStringAsFixed(0)}";
  }

  // ADD THE METHOD HERE
  Future<void> confirmDelete(
    ExpenditureProvider provider,
    Expenditure expense,
  ) async {
    final result = await showDialog<bool>(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Expense"),

          content: Text("Are you sure you want to delete ${expense.title}?"),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },

              child: const Text("Cancel"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,

                foregroundColor: Colors.white,
              ),

              onPressed: () {
                Navigator.pop(context, true);
              },

              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await provider.delete(expense.id!);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,

          content: Text("Expense deleted successfully"),
        ),
      );
    }
  }

  Future<void> openAdd() async {
    await Navigator.push(
      context,

      MaterialPageRoute(builder: (_) => const AddExpenditureScreen()),
    );

    if (!mounted) return;

    context.read<ExpenditureProvider>().loadExpenditures();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,

        foregroundColor: Colors.white,

        elevation: 0,

        title: const Text(
          "Expenditures",

          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),

            onPressed: () {
              context.read<ExpenditureProvider>().loadExpenditures();
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryBlue,

        foregroundColor: Colors.white,

        onPressed: openAdd,

        icon: const Icon(Icons.add),

        label: const Text("Add Expense"),
      ),

      body: Consumer<ExpenditureProvider>(
        builder: (context, provider, _) {
          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(25),

            child: Container(
              padding: const EdgeInsets.all(25),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(24),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),

                    blurRadius: 25,

                    offset: const Offset(0, 10),
                  ),
                ],
              ),

              child: Column(
                children: [
                  _statistics(provider),

                  const SizedBox(height: 25),

                  _search(provider),

                  const SizedBox(height: 25),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * .55,

                    child: _table(provider),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _statistics(ExpenditureProvider provider) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            "Total Expenses",

            money(provider.total),

            Icons.account_balance_wallet,
          ),
        ),

        const SizedBox(width: 20),

        Expanded(
          child: _statCard(
            "This Month",

            money(provider.monthlyTotal),

            Icons.calendar_month,
          ),
        ),

        const SizedBox(width: 20),

        Expanded(
          child: _statCard("Today", money(provider.todayTotal), Icons.today),
        ),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(.05),

        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Icon(icon, color: AppColors.primaryBlue),

          const SizedBox(height: 12),

          Text(title, style: const TextStyle(color: Colors.grey)),

          const SizedBox(height: 5),

          Text(
            value,

            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _search(ExpenditureProvider provider) {
    return TextField(
      controller: searchController,

      decoration: InputDecoration(
        hintText: "Search expenditure...",

        prefixIcon: const Icon(Icons.search),

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

      onChanged: provider.search,
    );
  }

  Widget _table(ExpenditureProvider provider) {
    if (provider.filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 70,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 15),

            Text(
              "No expenditures found",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              "Start adding expenses to see them here",
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),

            blurRadius: 10,

            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: DataTable2(
        headingRowHeight: 55,

        dataRowHeight: 65,

        columnSpacing: 25,

        horizontalMargin: 20,

        headingRowColor: WidgetStateProperty.all(Colors.grey.shade100),

        columns: [
          const DataColumn2(label: Text("TITLE"), size: ColumnSize.L),

          const DataColumn(label: Text("AMOUNT")),

          const DataColumn(label: Text("PAYMENT")),

          const DataColumn(label: Text("DATE")),

          const DataColumn(label: Text("ACTION")),
        ],

        rows: provider.filtered.map((expense) {
          return DataRow(
            cells: [
              DataCell(
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,

                      child: const Icon(Icons.money_outlined, size: 18),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        expense.title,

                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

              DataCell(
                Text(
                  money(expense.amount),

                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,

                    vertical: 5,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,

                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(
                    expense.paymentMethod ?? "-",

                    style: TextStyle(
                      color: Colors.blue.shade700,

                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              DataCell(Text(expense.expenseDate)),

              DataCell(
                Row(
                  children: [
                    IconButton(
                      tooltip: "Edit Expense",

                      icon: const Icon(Icons.edit, color: Colors.blue),

                      onPressed: () async {
                        await Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                                EditExpenditureScreen(expenditure: expense),
                          ),
                        );

                        if (!mounted) return;

                        provider.loadExpenditures();
                      },
                    ),

                    IconButton(
                      tooltip: "Delete Expense",

                      icon: const Icon(Icons.delete, color: Colors.red),

                      onPressed: () {
                        confirmDelete(provider, expense);
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
  }
}
