// import 'package:creafton_financial_services/widgets/borrower_loans_card.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../core/theme/app_colors.dart';
// import '../../providers/borrower_statistics_provider.dart';
// import '../../providers/loan_provider.dart';
// import '../../screens/loans/create_loan_screen.dart';
// import '../../screens/payments/collect_payment_screen.dart';
// import 'borrower.dart';

// class BorrowerProfileScreen extends StatefulWidget {
//   final Borrower borrower;

//   const BorrowerProfileScreen({super.key, required this.borrower});

//   @override
//   State<BorrowerProfileScreen> createState() => _BorrowerProfileScreenState();
// }

// class _BorrowerProfileScreenState extends State<BorrowerProfileScreen> {
//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadData();
//     });
//   }

//   Future<void> _loadData() async {
//     if (widget.borrower.id == null) {
//       return;
//     }

//     final id = widget.borrower.id!;

//     await context.read<BorrowerStatisticsProvider>().loadStatistics(id);

//     await context.read<LoanProvider>().loadBorrowerLoans(id);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,

//       appBar: AppBar(
//         title: Text(widget.borrower.fullName),

//         backgroundColor: AppColors.primaryBlue,

//         foregroundColor: Colors.white,
//       ),

//       body: RefreshIndicator(
//         onRefresh: _loadData,

//         child: Consumer2<BorrowerStatisticsProvider, LoanProvider>(
//           builder: (context, statisticsProvider, loanProvider, child) {
//             if (statisticsProvider.loading || loanProvider.loading) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             return SingleChildScrollView(
//               physics: const AlwaysScrollableScrollPhysics(),

//               padding: const EdgeInsets.all(24),

//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,

//                 children: [
//                   _profileHeader(),

//                   const SizedBox(height: 25),

//                   _informationCard(),

//                   const SizedBox(height: 25),

//                   _loanSummary(loanProvider),

//                   // _performanceCard(statisticsProvider),
//                   const SizedBox(height: 25),

//                   BorrowerLoansCard(loans: loanProvider.loans),

//                   const SizedBox(height: 25),

//                   _actionButtons(),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _profileHeader() {
//     return Card(
//       elevation: 3,

//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

//       child: Padding(
//         padding: const EdgeInsets.all(25),

//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 45,

//               backgroundColor: AppColors.primaryBlue,

//               child: Text(
//                 widget.borrower.fullName.isNotEmpty
//                     ? widget.borrower.fullName[0].toUpperCase()
//                     : "?",

//                 style: const TextStyle(
//                   color: Colors.white,

//                   fontSize: 35,

//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),

//             const SizedBox(width: 25),

//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,

//               children: [
//                 Text(
//                   widget.borrower.fullName,

//                   style: const TextStyle(
//                     fontSize: 25,

//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),

//                 const SizedBox(height: 8),

//                 Text(widget.borrower.phone),

//                 const SizedBox(height: 5),

//                 Chip(label: Text(widget.borrower.status)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _informationCard() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(20),

//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,

//           children: [
//             const Text(
//               "Borrower Information",

//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),

//             const Divider(),

//             _row("Borrower ID", widget.borrower.borrowerNumber),

//             _row("Phone", widget.borrower.phone),

//             _row("Gender", widget.borrower.gender ?? "-"),

//             _row("National ID", widget.borrower.nationalId ?? "-"),

//             _row("District", widget.borrower.district ?? "-"),

//             _row("Occupation", widget.borrower.occupation ?? "-"),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _loanSummary(LoanProvider provider) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(20),

//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,

//           children: [
//             const Text(
//               "Loan Summary",

//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),

//             const Divider(),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,

//               children: [
//                 _stat("Total Loans", provider.loans.length.toString()),

//                 _stat("Active", provider.activeLoans.toString()),

//                 _stat(
//                   "Balance",

//                   "UGX ${provider.outstandingBalance.toStringAsFixed(0)}",
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _performanceCard(BorrowerStatisticsProvider provider) {
//     final stats = provider.statistics;

//     final score = stats?.repaymentScore ?? 0;

//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(20),

//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,

//           children: [
//             const Text(
//               "Borrower Performance",

//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 20),

//             LinearProgressIndicator(
//               value: (score / 100).clamp(0, 1),

//               minHeight: 12,

//               borderRadius: BorderRadius.circular(10),
//             ),

//             const SizedBox(height: 10),

//             Text("Performance Score: ${score.toStringAsFixed(1)}%"),

//             const SizedBox(height: 20),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,

//               children: [
//                 _stat("Payments", stats?.totalPayments.toString() ?? "0"),

//                 _stat("Late", stats?.latePayments.toString() ?? "0"),

//                 _stat("Missed", stats?.missedPayments.toString() ?? "0"),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _actionButtons() {
//     return Row(
//       children: [
//         Expanded(
//           child: ElevatedButton.icon(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primaryBlue,

//               foregroundColor: Colors.white,
//             ),

//             onPressed: () async {
//               await Navigator.push(
//                 context,

//                 MaterialPageRoute(
//                   builder: (_) => CreateLoanScreen(
//                     borrowerId: widget.borrower.id!,

//                     borrowerName: widget.borrower.fullName,
//                   ),
//                 ),
//               );

//               _loadData();
//             },

//             icon: const Icon(Icons.add_card),

//             label: const Text("Create Loan"),
//           ),
//         ),

//         const SizedBox(width: 15),

//         Expanded(
//           child: ElevatedButton.icon(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,

//               foregroundColor: Colors.white,
//             ),

//             onPressed: () async {
//               final loanProvider = context.read<LoanProvider>();

//               await loanProvider.loadBorrowerLoans(widget.borrower.id!);

//               final loan = loanProvider.currentLoan;

//               if (loan == null) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("No active loan found")),
//                 );

//                 return;
//               }

//               await Navigator.push(
//                 context,

//                 MaterialPageRoute(
//                   builder: (_) => CollectPaymentScreen(loan: loan),
//                 ),
//               );

//               _loadData();
//             },

//             icon: const Icon(Icons.payment),

//             label: const Text("Record Payment"),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _row(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),

//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,

//         children: [
//           Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),

//           Flexible(child: Text(value)),
//         ],
//       ),
//     );
//   }

//   Widget _stat(String title, String value) {
//     return Column(
//       children: [
//         Text(
//           value,

//           style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),

//         Text(title),
//       ],
//     );
//   }
// }


import 'package:creafton_financial_services/widgets/borrower_loans_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/borrower_statistics_provider.dart';
import '../../providers/loan_provider.dart';
import '../../screens/loans/create_loan_screen.dart';
import '../../screens/payments/collect_payment_screen.dart';
import 'borrower.dart';

class BorrowerProfileScreen extends StatefulWidget {
  final Borrower borrower;

  const BorrowerProfileScreen({super.key, required this.borrower});

  @override
  State<BorrowerProfileScreen> createState() => _BorrowerProfileScreenState();
}

class _BorrowerProfileScreenState extends State<BorrowerProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (widget.borrower.id == null) {
      return;
    }

    final id = widget.borrower.id!;
    await context.read<BorrowerStatisticsProvider>().loadStatistics(id);
    await context.read<LoanProvider>().loadBorrowerLoans(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: Text(widget.borrower.fullName),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: Consumer2<BorrowerStatisticsProvider, LoanProvider>(
          builder: (context, statisticsProvider, loanProvider, child) {
            if (statisticsProvider.loading || loanProvider.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _profileHeader(),
                      const SizedBox(height: 25),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                _informationCard(),
                                const SizedBox(height: 25),
                                _performanceCard(statisticsProvider),
                              ],
                            ),
                          ),
                          const SizedBox(width: 25),
                          Expanded(
                            flex: 6,
                            child: Column(
                              children: [
                                _loanSummary(loanProvider),
                                const SizedBox(height: 25),
                                BorrowerLoansCard(loans: loanProvider.loans),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      _actionButtons(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _profileHeader() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
            child: Text(
              widget.borrower.fullName.isNotEmpty
                  ? widget.borrower.fullName[0].toUpperCase()
                  : "?",
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.borrower.fullName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.borrower.phone,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Chip(
            label: Text(widget.borrower.status),
            backgroundColor: Colors.green.withOpacity(0.1),
            labelStyle: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _informationCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Borrower Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const Divider(height: 25),
            _row("Borrower ID", widget.borrower.borrowerNumber),
            _row("Phone", widget.borrower.phone),
            _row("Gender", widget.borrower.gender ?? "-"),
            _row("National ID", widget.borrower.nationalId ?? "-"),
            _row("District", widget.borrower.district ?? "-"),
            _row("Occupation", widget.borrower.occupation ?? "-"),
          ],
        ),
      ),
    );
  }

  Widget _loanSummary(LoanProvider provider) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Loan Portfolio Summary",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const Divider(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _stat("Total Loans", provider.loans.length.toString(), AppColors.primaryBlue),
                _stat("Active", provider.activeLoans.toString(), Colors.green),
                _stat("Balance", "UGX ${provider.outstandingBalance.toStringAsFixed(0)}", Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _performanceCard(BorrowerStatisticsProvider provider) {
    final stats = provider.statistics;
    final score = stats?.repaymentScore ?? 0;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Borrower Performance",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 15),
            LinearProgressIndicator(
              value: (score / 100).clamp(0, 1),
              minHeight: 10,
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(
                score > 70 ? Colors.green : (score > 40 ? Colors.orange : Colors.red),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 10),
            Text(
              "Performance Score: ${score.toStringAsFixed(1)}%",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _stat("Payments", stats?.totalPayments.toString() ?? "0", Colors.blueGrey),
                _stat("Late", stats?.latePayments.toString() ?? "0", Colors.orange),
                _stat("Missed", stats?.missedPayments.toString() ?? "0", Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateLoanScreen(
                      borrowerId: widget.borrower.id!,
                      borrowerName: widget.borrower.fullName,
                    ),
                  ),
                );
                _loadData();
              },
              icon: const Icon(Icons.add_card, size: 20),
              label: const Text(
                "CREATE NEW LOAN",
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              onPressed: () async {
                final loanProvider = context.read<LoanProvider>();
                await loanProvider.loadBorrowerLoans(widget.borrower.id!);
                final loan = loanProvider.currentLoan;

                if (loan == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No active loan found")),
                  );
                  return;
                }

                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CollectPaymentScreen(loan: loan),
                  ),
                );
                _loadData();
              },
              icon: const Icon(Icons.payment, size: 20),
              label: const Text(
                "RECORD PAYMENT",
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
          Flexible(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _stat(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}