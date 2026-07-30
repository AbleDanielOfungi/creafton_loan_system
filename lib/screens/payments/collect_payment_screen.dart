// import 'package:creafton_financial_services/providers/payment_provder.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../core/theme/app_colors.dart';

// import '../../models/loan.dart';
// import '../../models/loan_payment.dart';

// import '../../providers/loan_provider.dart';
// import '../../providers/borrower_statistics_provider.dart';

// class CollectPaymentScreen extends StatefulWidget {
//   final Loan loan;

//   const CollectPaymentScreen({super.key, required this.loan});

//   @override
//   State<CollectPaymentScreen> createState() => _CollectPaymentScreenState();
// }

// class _CollectPaymentScreenState extends State<CollectPaymentScreen> {
//   final amountController = TextEditingController();

//   bool saving = false;

//   @override
//   void dispose() {
//     amountController.dispose();

//     super.dispose();
//   }

//   Future<void> savePayment() async {
//     final amount = double.tryParse(amountController.text.trim()) ?? 0;

//     if (amount <= 0) {
//       _message("Enter a valid payment amount", Colors.red);

//       return;
//     }

//     if (widget.loan.id == null) {
//       _message("Invalid loan record", Colors.red);

//       return;
//     }

//     if (amount > widget.loan.remainingBalance) {
//       _message("Payment exceeds outstanding balance", Colors.red);

//       return;
//     }

//     setState(() {
//       saving = true;
//     });

//     try {
//       final now = DateTime.now().toIso8601String();

//       final payment = LoanPayment(
//         loanId: widget.loan.id!,

//         amount: amount,

//         paymentDate: now,

//         createdAt: now,
//       );

//       final paymentProvider = context.read<PaymentProvider>();

//       final success = await paymentProvider.createPayment(payment);

//       if (!success) {
//         _message(paymentProvider.error ?? "Payment failed", Colors.red);

//         return;
//       }

//       /*
//       =====================================================
//       UPDATE LOAN BALANCE
//       =====================================================
//       */

//       final newBalance = widget.loan.remainingBalance - amount;

//       final loanProvider = context.read<LoanProvider>();

//       await loanProvider.updateBalance(
//         widget.loan.id!,
//         newBalance < 0 ? 0 : newBalance,
//       );

//       /*
//       =====================================================
//       COMPLETE LOAN IF FULLY PAID
//       =====================================================
//       */

//       if (newBalance <= 0) {
//         await loanProvider.completeLoan(widget.loan.id!);
//       }

//       /*
//       =====================================================
//       UPDATE BORROWER PERFORMANCE
//       =====================================================
//       */

//       await context.read<BorrowerStatisticsProvider>().addPayment(
//         widget.loan.borrowerId,
//         amount,
//         now,
//       );

//       /*
//       =====================================================
//       REFRESH DATA
//       =====================================================
//       */

//       await loanProvider.loadBorrowerLoans(widget.loan.borrowerId);

//       if (!mounted) return;

//       _message("Payment recorded successfully", Colors.green);

//       Navigator.pop(context);
//     } catch (e) {
//       _message(e.toString(), Colors.red);
//     } finally {
//       if (mounted) {
//         setState(() {
//           saving = false;
//         });
//       }
//     }
//   }

//   void _message(String message, Color color) {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,

//       appBar: AppBar(
//         title: const Text("Collect Payment"),

//         backgroundColor: AppColors.primaryBlue,

//         foregroundColor: Colors.white,
//       ),

//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(25),

//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,

//           children: [
//             _buildLoanCard(),

//             const SizedBox(height: 25),

//             TextField(
//               controller: amountController,

//               keyboardType: TextInputType.number,

//               decoration: const InputDecoration(
//                 labelText: "Payment Amount",

//                 prefixText: "UGX ",

//                 border: OutlineInputBorder(),
//               ),
//             ),

//             const SizedBox(height: 30),

//             SizedBox(
//               width: double.infinity,

//               child: ElevatedButton.icon(
//                 onPressed: saving ? null : savePayment,

//                 icon: saving
//                     ? const SizedBox(
//                         width: 20,

//                         height: 20,

//                         child: CircularProgressIndicator(color: Colors.white),
//                       )
//                     : const Icon(Icons.payment),

//                 label: const Text("RECORD PAYMENT"),

//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,

//                   foregroundColor: Colors.white,

//                   padding: const EdgeInsets.all(16),
//                 ),
//               ),
//             ),
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
//               "Loan Details",

//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),

//             const Divider(),

//             _row("Loan Number", widget.loan.loanNumber),

//             _row(
//               "Principal",

//               "UGX ${widget.loan.principalAmount.toStringAsFixed(0)}",
//             ),

//             _row(
//               "Total Payable",

//               "UGX ${widget.loan.totalPayable.toStringAsFixed(0)}",
//             ),

//             _row(
//               "Outstanding",

//               "UGX ${widget.loan.remainingBalance.toStringAsFixed(0)}",
//             ),

//             _row(
//               "Installment",

//               "UGX ${widget.loan.dailyPaymentAmount.toStringAsFixed(0)}",
//             ),
//           ],
//         ),
//       ),
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

import 'package:creafton_financial_services/providers/payment_provder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';

import '../../models/loan.dart';

import '../../providers/loan_provider.dart';
import '../../providers/borrower_statistics_provider.dart';

class CollectPaymentScreen extends StatefulWidget {
  final Loan loan;

  const CollectPaymentScreen({super.key, required this.loan});

  @override
  State<CollectPaymentScreen> createState() => _CollectPaymentScreenState();
}

class _CollectPaymentScreenState extends State<CollectPaymentScreen> {
  final amountController = TextEditingController();

  bool saving = false;

  @override
  void dispose() {
    amountController.dispose();

    super.dispose();
  }

  Future<void> savePayment() async {
    final amount = double.tryParse(amountController.text.trim()) ?? 0;

    if (amount <= 0) {
      _message("Enter a valid payment amount", Colors.red);

      return;
    }

    if (widget.loan.id == null) {
      _message("Invalid loan record", Colors.red);

      return;
    }

    if (amount > widget.loan.remainingBalance) {
      _message("Payment exceeds outstanding balance", Colors.red);

      return;
    }

    setState(() {
      saving = true;
    });

    try {
      final now = DateTime.now().toIso8601String();

      final paymentProvider = context.read<PaymentProvider>();

      // Fills the earliest PENDING installment card for this loan (flips
      // it to PAID with today's date) instead of adding a new card. This
      // also updates the loan's remaining_balance / status internally, so
      // there's no need to call loanProvider.updateBalance/completeLoan
      // separately afterward.
      final success = await paymentProvider.recordInstallmentPayment(
        loanId: widget.loan.id!,
        amount: amount,
        paymentDate: now,
      );

      if (!success) {
        _message(paymentProvider.error ?? "Payment failed", Colors.red);

        return;
      }

      /*
      =====================================================
      UPDATE BORROWER PERFORMANCE
      =====================================================
      */

      await context.read<BorrowerStatisticsProvider>().addPayment(
        widget.loan.borrowerId,
        amount,
        now,
      );

      /*
      =====================================================
      REFRESH DATA
      =====================================================
      */

      final loanProvider = context.read<LoanProvider>();

      await loanProvider.loadBorrowerLoans(widget.loan.borrowerId);

      if (!mounted) return;

      _message("Payment recorded successfully", Colors.green);

      Navigator.pop(context);
    } catch (e) {
      _message(e.toString(), Colors.red);
    } finally {
      if (mounted) {
        setState(() {
          saving = false;
        });
      }
    }
  }

  void _message(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Collect Payment"),

        backgroundColor: AppColors.primaryBlue,

        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            _buildLoanCard(),

            const SizedBox(height: 25),

            TextField(
              controller: amountController,

              keyboardType: TextInputType.number,

              decoration: const InputDecoration(
                labelText: "Payment Amount",

                prefixText: "UGX ",

                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                onPressed: saving ? null : savePayment,

                icon: saving
                    ? const SizedBox(
                        width: 20,

                        height: 20,

                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Icon(Icons.payment),

                label: const Text("RECORD PAYMENT"),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,

                  foregroundColor: Colors.white,

                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
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
              "Loan Details",

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const Divider(),

            _row("Loan Number", widget.loan.loanNumber),

            _row(
              "Principal",

              "UGX ${widget.loan.principalAmount.toStringAsFixed(0)}",
            ),

            _row(
              "Total Payable",

              "UGX ${widget.loan.totalPayable.toStringAsFixed(0)}",
            ),

            _row(
              "Outstanding",

              "UGX ${widget.loan.remainingBalance.toStringAsFixed(0)}",
            ),

            _row(
              "Installment",

              "UGX ${widget.loan.dailyPaymentAmount.toStringAsFixed(0)}",
            ),
          ],
        ),
      ),
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
