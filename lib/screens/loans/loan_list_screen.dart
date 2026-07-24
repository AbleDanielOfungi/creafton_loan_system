import 'package:creafton_financial_services/screens/loans/loan_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/loan_provider.dart';

import '../../models/loan.dart';

class LoanListScreen extends StatefulWidget {
  const LoanListScreen({super.key});

  @override
  State<LoanListScreen> createState() => _LoanListScreenState();
}

class _LoanListScreenState extends State<LoanListScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoanProvider>().loadLoans();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Loan Management"),

        backgroundColor: AppColors.primaryBlue,

        foregroundColor: Colors.white,
      ),

      body: Consumer<LoanProvider>(
        builder: (context, provider, _) {
          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.loans.isEmpty) {
            return const Center(
              child: Text(
                "No loans registered",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),

            itemCount: provider.loans.length,

            itemBuilder: (context, index) {
              final loan = provider.loans[index];

              return _loanCard(context, loan);
            },
          );
        },
      ),
    );
  }

  Widget _loanCard(BuildContext context, Loan loan) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),

      child: ListTile(
        contentPadding: const EdgeInsets.all(15),

        leading: CircleAvatar(
          backgroundColor: loan.status == "ACTIVE" ? Colors.green : Colors.grey,

          child: const Icon(Icons.account_balance_wallet, color: Colors.white),
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

            Text("Status: ${loan.status}"),
          ],
        ),

        trailing: const Icon(Icons.arrow_forward_ios),

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
