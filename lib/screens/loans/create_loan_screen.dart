// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../core/theme/app_colors.dart';
// import '../../core/utils/loan_calculator.dart';
// import '../../core/utils/number_generator.dart';

// import '../../models/loan.dart';

// import '../../providers/loan_provider.dart';
// import '../../providers/borrower_statistics_provider.dart';

// class CreateLoanScreen extends StatefulWidget {
//   final int borrowerId;

//   final String borrowerName;

//   const CreateLoanScreen({
//     super.key,

//     required this.borrowerId,

//     required this.borrowerName,
//   });

//   @override
//   State<CreateLoanScreen> createState() => _CreateLoanScreenState();
// }

// class _CreateLoanScreenState extends State<CreateLoanScreen> {
//   final principalController = TextEditingController();

//   final interestController = TextEditingController(text: "20");

//   final durationController = TextEditingController();

//   String paymentFrequency = "DAILY";

//   Map<String, dynamic>? calculation;

//   bool saving = false;

//   @override
//   void dispose() {
//     principalController.dispose();

//     interestController.dispose();

//     durationController.dispose();

//     super.dispose();
//   }

//   void calculate() {
//     final principal = double.tryParse(principalController.text) ?? 0;

//     final interest = double.tryParse(interestController.text) ?? 0;

//     final duration = int.tryParse(durationController.text) ?? 0;

//     if (principal <= 0 || duration <= 0) {
//       setState(() {
//         calculation = null;
//       });

//       return;
//     }

//     setState(() {
//       calculation = LoanCalculator.calculateLoan(
//         principal: principal,

//         interestRate: interest,

//         duration: duration,
//       );
//     });
//   }

//   Future<void> saveLoan() async {
//     if (calculation == null) return;

//     setState(() => saving = true);

//     final loan = Loan(
//       loanNumber: NumberGenerator.loanNumber(),

//       borrowerId: widget.borrowerId,

//       principalAmount: calculation!["principal_amount"],

//       interestRate: calculation!["interest_rate"],

//       interestAmount: calculation!["interest_amount"],

//       totalPayable: calculation!["total_payable"],

//       remainingBalance: calculation!["total_payable"],

//       dailyPaymentAmount: calculation!["daily_payment_amount"],

//       loanDuration: calculation!["loan_duration"],

//       paymentFrequency: paymentFrequency,

//       startDate: calculation!["start_date"],

//       endDate: calculation!["end_date"],

//       status: "ACTIVE",

//       createdAt: DateTime.now().toIso8601String(),
//     );

//     final loanProvider = context.read<LoanProvider>();

//     // ignore: unnecessary_non_null_assertion
//     final success = await loanProvider.createLoan(loan);

//     if (success) {
//       // Update borrower statistics
//       await context.read<BorrowerStatisticsProvider>().addLoan(
//         widget.borrowerId,
//         loan.principalAmount,
//       );

//       // Refresh statistics
//       await context.read<BorrowerStatisticsProvider>().loadStatistics(
//         widget.borrowerId,
//       );

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Loan created successfully"),
//             backgroundColor: Colors.green,
//           ),
//         );

//         Navigator.pop(context);
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(loanProvider.error ?? "Failed creating loan"),

//           backgroundColor: Colors.red,
//         ),
//       );
//     }

//     setState(() => saving = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,

//       appBar: AppBar(
//         title: Text("Create Loan - ${widget.borrowerName}"),

//         backgroundColor: AppColors.primaryBlue,

//         foregroundColor: Colors.white,
//       ),

//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(25),

//         child: Column(
//           children: [
//             _buildInput("Loan Amount", principalController),

//             _buildInput("Interest Rate (%)", interestController),

//             _buildInput("Duration (Days)", durationController),

//             DropdownButtonFormField<String>(
//               initialValue: paymentFrequency,

//               decoration: const InputDecoration(
//                 labelText: "Payment Frequency",

//                 border: OutlineInputBorder(),
//               ),

//               items: [
//                 "DAILY",
//                 "WEEKLY",
//                 "MONTHLY",
//               ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),

//               onChanged: (value) {
//                 setState(() {
//                   paymentFrequency = value!;
//                 });
//               },
//             ),

//             const SizedBox(height: 25),

//             ElevatedButton.icon(
//               onPressed: calculate,

//               icon: const Icon(Icons.calculate),

//               label: const Text("Calculate Loan"),
//             ),

//             if (calculation != null) ...[
//               const SizedBox(height: 20),

//               _buildPreview(),

//               const SizedBox(height: 20),

//               SizedBox(
//                 width: double.infinity,

//                 child: ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,

//                     foregroundColor: Colors.white,

//                     padding: const EdgeInsets.all(16),
//                   ),

//                   onPressed: saving ? null : saveLoan,

//                   icon: saving
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Icon(Icons.save),

//                   label: const Text("CREATE LOAN"),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInput(String label, TextEditingController controller) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 15),

//       child: TextField(
//         controller: controller,

//         keyboardType: TextInputType.number,

//         onChanged: (_) => calculate(),

//         decoration: InputDecoration(
//           labelText: label,

//           border: const OutlineInputBorder(),
//         ),
//       ),
//     );
//   }

//   Widget _buildPreview() {
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

//             _textRow("Principal", calculation!["principal_amount"]),

//             _textRow("Interest", calculation!["interest_amount"]),

//             _textRow("Total Payable", calculation!["total_payable"]),

//             _textRow("Daily Payment", calculation!["daily_payment_amount"]),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _textRow(String title, dynamic value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),

//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,

//         children: [
//           Text(title),

//           Text(
//             "UGX ${value.toStringAsFixed(0)}",

//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:creafton_financial_services/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/loan_calculator.dart';
import '../../core/utils/number_generator.dart';

import '../../models/loan.dart';

import '../../providers/loan_provider.dart';
import '../../providers/borrower_statistics_provider.dart';



class CreateLoanScreen extends StatefulWidget {
  final int borrowerId;

  final String borrowerName;

  const CreateLoanScreen({
    super.key,

    required this.borrowerId,

    required this.borrowerName,
  });

  @override
  State<CreateLoanScreen> createState() => _CreateLoanScreenState();
}

class _CreateLoanScreenState extends State<CreateLoanScreen> {
  final principalController = TextEditingController();

  final interestController = TextEditingController(text: "20");

  final durationController = TextEditingController();

  String paymentFrequency = "DAILY";

  Map<String, dynamic>? calculation;

  bool saving = false;

  // --- Active-loan guard state ---
  bool checkingExistingLoan = true;
  Map<String, dynamic>? existingActiveLoan; // non-null => block the form

  @override
  void initState() {
    super.initState();
    _checkExistingActiveLoan();
  }

  @override
  void dispose() {
    principalController.dispose();

    interestController.dispose();

    durationController.dispose();

    super.dispose();
  }

  /// Looks up whether [widget.borrowerId] already has a loan that hasn't
  /// reached 'COMPLETED' status. If so, the create-loan form is blocked.
  Future<void> _checkExistingActiveLoan() async {
    final db = await DatabaseHelper.database;

    final rows = await db.query(
      'loans',
      where: 'borrower_id = ? AND status != ?',
      whereArgs: [widget.borrowerId, 'COMPLETED'],
      orderBy: 'id DESC',
      limit: 1,
    );

    if (!mounted) return;

    setState(() {
      existingActiveLoan = rows.isNotEmpty ? rows.first : null;
      checkingExistingLoan = false;
    });
  }

  void calculate() {
    final principal = double.tryParse(principalController.text) ?? 0;

    final interest = double.tryParse(interestController.text) ?? 0;

    final duration = int.tryParse(durationController.text) ?? 0;

    if (principal <= 0 || duration <= 0) {
      setState(() {
        calculation = null;
      });

      return;
    }

    setState(() {
      calculation = LoanCalculator.calculateLoan(
        principal: principal,

        interestRate: interest,

        duration: duration,
      );
    });
  }

  Future<void> saveLoan() async {
    if (calculation == null) return;

    // Defensive re-check: guards against the borrower being given another
    // loan elsewhere in the app between this screen opening and Save being
    // tapped (e.g. two staff members working the same borrower at once).
    await _checkExistingActiveLoan();
    if (existingActiveLoan != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "This borrower already has an active loan. Cannot create another.",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() => saving = true);

    final loan = Loan(
      loanNumber: NumberGenerator.loanNumber(),

      borrowerId: widget.borrowerId,

      principalAmount: calculation!["principal_amount"],

      interestRate: calculation!["interest_rate"],

      interestAmount: calculation!["interest_amount"],

      totalPayable: calculation!["total_payable"],

      remainingBalance: calculation!["total_payable"],

      dailyPaymentAmount: calculation!["daily_payment_amount"],

      loanDuration: calculation!["loan_duration"],

      paymentFrequency: paymentFrequency,

      startDate: calculation!["start_date"],

      endDate: calculation!["end_date"],

      status: "ACTIVE",

      createdAt: DateTime.now().toIso8601String(),
    );

    final loanProvider = context.read<LoanProvider>();

    // ignore: unnecessary_non_null_assertion
    final success = await loanProvider.createLoan(loan);

    if (success) {
      // Update borrower statistics
      await context.read<BorrowerStatisticsProvider>().addLoan(
        widget.borrowerId,
        loan.principalAmount,
      );

      // Refresh statistics
      await context.read<BorrowerStatisticsProvider>().loadStatistics(
        widget.borrowerId,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Loan created successfully"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loanProvider.error ?? "Failed creating loan"),

          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: Text("Create Loan - ${widget.borrowerName}"),

        backgroundColor: AppColors.primaryBlue,

        foregroundColor: Colors.white,
      ),

      body: checkingExistingLoan
          ? const Center(child: CircularProgressIndicator())
          : existingActiveLoan != null
              ? _buildBlockedState()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(25),

                  child: Column(
                    children: [
                      _buildInput("Loan Amount", principalController),

                      _buildInput("Interest Rate (%)", interestController),

                      _buildInput("Duration (Days)", durationController),

                      DropdownButtonFormField<String>(
                        initialValue: paymentFrequency,

                        decoration: const InputDecoration(
                          labelText: "Payment Frequency",

                          border: OutlineInputBorder(),
                        ),

                        items: [
                          "DAILY",
                          "WEEKLY",
                          "MONTHLY",
                        ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),

                        onChanged: (value) {
                          setState(() {
                            paymentFrequency = value!;
                          });
                        },
                      ),

                      const SizedBox(height: 25),

                      ElevatedButton.icon(
                        onPressed: calculate,

                        icon: const Icon(Icons.calculate),

                        label: const Text("Calculate Loan"),
                      ),

                      if (calculation != null) ...[
                        const SizedBox(height: 20),

                        _buildPreview(),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,

                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,

                              foregroundColor: Colors.white,

                              padding: const EdgeInsets.all(16),
                            ),

                            onPressed: saving ? null : saveLoan,

                            icon: saving
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Icon(Icons.save),

                            label: const Text("CREATE LOAN"),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }

  /// Shown instead of the form when the borrower already has a loan that
  /// isn't 'COMPLETED' yet.
  Widget _buildBlockedState() {
    final loan = existingActiveLoan!;
    final remaining = (loan['remaining_balance'] as num?)?.toDouble() ?? 0;
    final status = loan['status'] as String? ?? 'ACTIVE';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.block_rounded, size: 48, color: Colors.red.shade400),
                const SizedBox(height: 16),
                Text(
                  "${widget.borrowerName} already has an active loan",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "A new loan can't be created until the existing one is fully paid off.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
                const Divider(height: 32),
                _textRow("Loan Number", loan['loan_number'] ?? '—', isMoney: false),
                _textRow("Status", status, isMoney: false),
                _textRow("Remaining Balance", remaining),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Go Back"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),

      child: TextField(
        controller: controller,

        keyboardType: TextInputType.number,

        onChanged: (_) => calculate(),

        decoration: InputDecoration(
          labelText: label,

          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildPreview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Loan Summary",

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const Divider(),

            _textRow("Principal", calculation!["principal_amount"]),

            _textRow("Interest", calculation!["interest_amount"]),

            _textRow("Total Payable", calculation!["total_payable"]),

            _textRow("Daily Payment", calculation!["daily_payment_amount"]),
          ],
        ),
      ),
    );
  }

  Widget _textRow(String title, dynamic value, {bool isMoney = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(title),

          Text(
            isMoney ? "UGX ${(value as num).toStringAsFixed(0)}" : "$value",

            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}