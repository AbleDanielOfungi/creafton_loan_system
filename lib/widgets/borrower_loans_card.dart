import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/loan.dart';
import '../screens/loans/loan_details_screen.dart';

class BorrowerLoansCard extends StatelessWidget {
  final List<Loan> loans;

  const BorrowerLoansCard({super.key, required this.loans});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Loan Portfolio",

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const Divider(),

            if (loans.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),

                  child: Text("No loans found"),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,

                physics: const NeverScrollableScrollPhysics(),

                itemCount: loans.length,

                itemBuilder: (context, index) {
                  final loan = loans[index];

                  return _loanTile(context, loan);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _loanTile(BuildContext context, Loan loan) {
    final statusColor = loan.status == "ACTIVE" ? Colors.green : Colors.grey;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryBlue,

          child: const Icon(Icons.account_balance, color: Colors.white),
        ),

        title: Text(
          loan.loanNumber,

          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text("Principal: UGX ${loan.principalAmount.toStringAsFixed(0)}"),

            Text("Balance: UGX ${loan.remainingBalance.toStringAsFixed(0)}"),

            const SizedBox(height: 5),

            Chip(
              label: Text(loan.status),

              backgroundColor: statusColor.withOpacity(.15),
            ),
          ],
        ),

        trailing: const Icon(Icons.arrow_forward_ios, size: 18),

        onTap: () {
          Navigator.push(
            context,

            MaterialPageRoute(builder: (_) => LoanDetailsScreen(loan: loan)),
          );
        },
      ),
    );
  }
}
