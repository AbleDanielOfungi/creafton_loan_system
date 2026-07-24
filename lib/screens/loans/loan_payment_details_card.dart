
import 'package:creafton_financial_services/core/theme/app_colors.dart';
import 'package:creafton_financial_services/providers/loan_payment_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoanPaymentDetailsCard extends StatefulWidget {
  final int loanId;

  final double loanBalance;

  const LoanPaymentDetailsCard({
    super.key,

    required this.loanId,

    required this.loanBalance,
  });

  @override
  State<LoanPaymentDetailsCard> createState() => _LoanPaymentDetailsCardState();
}

class _LoanPaymentDetailsCardState extends State<LoanPaymentDetailsCard> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoanPaymentDetailsProvider>().loadPayments(
        widget.loanId,
        widget.loanBalance,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoanPaymentDetailsProvider>(
      builder: (context, provider, child) {
        if (provider.loading) {
          return _loadingCard();
        }

        if (provider.error != null) {
          return _errorCard(provider.error!);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            _header(),

            const SizedBox(height: 20),

            _summary(provider),

            const SizedBox(height: 25),

            _history(provider),
          ],
        );
      },
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBlue,

            AppColors.primaryBlue.withOpacity(.75),
          ],
        ),

        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: Colors.white24,

              borderRadius: BorderRadius.circular(15),
            ),

            child: const Icon(
              Icons.account_balance_wallet,

              color: Colors.white,

              size: 30,
            ),
          ),

          const SizedBox(width: 15),

          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                "Loan Payment History",

                style: TextStyle(
                  color: Colors.white,

                  fontSize: 20,

                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 5),

              Text(
                "Track all collections",

                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summary(LoanPaymentDetailsProvider provider) {
    return Row(
      children: [
        Expanded(
          child: _summaryBox(
            Icons.payments,

            "Paid",

            "UGX ${provider.totalPaid.toStringAsFixed(0)}",

            Colors.green,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _summaryBox(
            Icons.account_balance,

            "Balance",

            "UGX ${provider.remainingBalance.toStringAsFixed(0)}",

            Colors.orange,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _summaryBox(
            Icons.receipt_long,

            "Payments",

            provider.paymentCount.toString(),

            AppColors.primaryBlue,
          ),
        ),
      ],
    );
  }

  Widget _summaryBox(IconData icon, String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10),
        ],
      ),

      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(.15),

            child: Icon(icon, color: color),
          ),

          const SizedBox(height: 10),

          Text(
            value,

            textAlign: TextAlign.center,

            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),

          Text(
            title,

            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _history(LoanPaymentDetailsProvider provider) {
    return Card(
      elevation: 2,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Payment Transactions",

              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            if (provider.payments.isEmpty)
              _emptyState()
            else
              ListView.builder(
                shrinkWrap: true,

                physics: const NeverScrollableScrollPhysics(),

                itemCount: provider.payments.length,

                itemBuilder: (context, index) {
                  final payment = provider.payments[index];

                  return _paymentItem(payment);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _paymentItem(dynamic payment) {
    final status = payment.status ?? "PAID";

    final color = status == "PAID"
        ? Colors.green
        : status == "LATE"
        ? Colors.orange
        : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.grey.shade50,

        borderRadius: BorderRadius.circular(15),

        border: Border.all(color: Colors.grey.shade200),
      ),

      child: Row(
        children: [
          CircleAvatar(
            radius: 22,

            backgroundColor: color.withOpacity(.15),

            child: Icon(Icons.check_circle, color: color),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "Payment #${payment.paymentNumber ?? '-'}",

                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 5),

                Text("UGX ${payment.amount.toStringAsFixed(0)}"),

                Text(
                  _date(payment.paymentDate),

                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),

          Chip(label: Text(status), backgroundColor: color.withOpacity(.15)),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return const Padding(
      padding: EdgeInsets.all(25),

      child: Center(
        child: Column(
          children: [
            Icon(Icons.history, size: 45, color: Colors.grey),

            SizedBox(height: 10),

            Text("No payments recorded"),
          ],
        ),
      ),
    );
  }

  Widget _loadingCard() {
    return const Card(
      child: SizedBox(
        height: 150,

        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _errorCard(String error) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Text(error, style: const TextStyle(color: Colors.red)),
      ),
    );
  }

  String _date(String? value) {
    if (value == null) {
      return "-";
    }

    try {
      final d = DateTime.parse(value);

      return "${d.day}/${d.month}/${d.year}";
    } catch (e) {
      return value;
    }
  }
}
