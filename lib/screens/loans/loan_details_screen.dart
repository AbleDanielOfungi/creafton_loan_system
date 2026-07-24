// import 'package:creafton_financial_services/screens/payments/collect_payment_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../core/theme/app_colors.dart';

// import '../../models/loan.dart';

// import '../../providers/loan_provider.dart';

// class LoanDetailsScreen extends StatelessWidget {
//   final Loan loan;

//   const LoanDetailsScreen({super.key, required this.loan});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,

//       appBar: AppBar(
//         title: const Text("Loan Details"),

//         backgroundColor: AppColors.primaryBlue,

//         foregroundColor: Colors.white,
//       ),

//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(25),

//         child: Column(
//           children: [
//             _buildLoanCard(),

//             const SizedBox(height: 20),

//             _buildRepaymentCard(),

//             const SizedBox(height: 20),

//             _buildActions(context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLoanCard() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(20),

//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,

//           children: [
//             const Text(
//               "Loan Information",

//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),

//             const Divider(),

//             _row("Loan Number", loan.loanNumber),

//             _row("Principal", "UGX ${loan.principalAmount.toStringAsFixed(0)}"),

//             _row("Interest", "${loan.interestRate}%"),

//             _row(
//               "Interest Amount",
//               "UGX ${loan.interestAmount.toStringAsFixed(0)}",
//             ),

//             _row(
//               "Total Payable",
//               "UGX ${loan.totalPayable.toStringAsFixed(0)}",
//             ),

//             _row("Balance", "UGX ${loan.remainingBalance.toStringAsFixed(0)}"),

//             _row("Status", loan.status),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRepaymentCard() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(20),

//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,

//           children: [
//             const Text(
//               "Repayment Schedule",

//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),

//             const Divider(),

//             _row(
//               "Daily Payment",
//               "UGX ${loan.dailyPaymentAmount.toStringAsFixed(0)}",
//             ),

//             _row("Duration", "${loan.loanDuration} Days"),

//             _row("Frequency", loan.paymentFrequency),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActions(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           width: double.infinity,

//           child: ElevatedButton.icon(
//             icon: const Icon(Icons.payment),

//             label: const Text("Record Payment"),

//             onPressed: () {
//               Navigator.push(
//                 context,

//                 MaterialPageRoute(
//                   builder: (_) => CollectPaymentScreen(loan: loan),
//                 ),
//               );
//             },
//           ),
//         ),

//         const SizedBox(height: 15),

//         SizedBox(
//           width: double.infinity,

//           child: ElevatedButton.icon(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,

//               foregroundColor: Colors.white,
//             ),

//             icon: const Icon(Icons.check_circle),

//             label: const Text("Complete Loan"),

//             onPressed: () async {
//               await context.read<LoanProvider>().completeLoan(loan.id!);

//               Navigator.pop(context);
//             },
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

//           Text(value),
//         ],
//       ),
//     );
//   }
// }

import 'package:creafton_financial_services/screens/payments/collect_payment_screen.dart';
import 'package:creafton_financial_services/widgets/loan_payment_details_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../models/loan.dart';
import '../../providers/loan_provider.dart';
// TODO: Adjust this import path to where your LoanPaymentDetailsCard file is located

class LoanDetailsScreen extends StatelessWidget {
  final Loan loan;

  const LoanDetailsScreen({super.key, required this.loan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Loan Details"),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            _buildLoanCard(),

            const SizedBox(height: 20),

            _buildRepaymentCard(),

            const SizedBox(height: 20),

            // Linked LoanPaymentDetailsCard inserted here
            LoanPaymentDetailsCard(
              loanId: loan.id ?? 0,
              loanBalance: loan.remainingBalance,
            ),

            const SizedBox(height: 20),

            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLoanCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Loan Information",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _row("Loan Number", loan.loanNumber),
            _row("Principal", "UGX ${loan.principalAmount.toStringAsFixed(0)}"),
            _row("Interest", "${loan.interestRate}%"),
            _row(
              "Interest Amount",
              "UGX ${loan.interestAmount.toStringAsFixed(0)}",
            ),
            _row(
              "Total Payable",
              "UGX ${loan.totalPayable.toStringAsFixed(0)}",
            ),
            _row("Balance", "UGX ${loan.remainingBalance.toStringAsFixed(0)}"),
            _row("Status", loan.status),
          ],
        ),
      ),
    );
  }

  Widget _buildRepaymentCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Repayment Schedule",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _row(
              "Daily Payment",
              "UGX ${loan.dailyPaymentAmount.toStringAsFixed(0)}",
            ),
            _row("Duration", "${loan.loanDuration} Days"),
            _row("Frequency", loan.paymentFrequency),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.payment),
            label: const Text("Record Payment"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CollectPaymentScreen(loan: loan),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.check_circle),
            label: const Text("Complete Loan"),
            onPressed: () async {
              await context.read<LoanProvider>().completeLoan(loan.id!);
              Navigator.pop(context);
            },
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
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value),
        ],
      ),
    );
  }
}
