import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/payment_schedule_provider.dart';

class LoanScheduleScreen extends StatefulWidget {
  final int loanId;

  const LoanScheduleScreen({super.key, required this.loanId});

  @override
  State<LoanScheduleScreen> createState() => _LoanScheduleScreenState();
}

class _LoanScheduleScreenState extends State<LoanScheduleScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentScheduleProvider>().loadSchedule(widget.loanId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Repayment Schedule")),

      body: Consumer<PaymentScheduleProvider>(
        builder: (context, provider, _) {
          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.schedule.isEmpty) {
            return const Center(child: Text("No repayment schedule found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),

            itemCount: provider.schedule.length,

            itemBuilder: (context, index) {
              final item = provider.schedule[index];

              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text("${item.paymentNumber}")),

                  title: Text("UGX ${item.amount.toStringAsFixed(0)}"),

                  subtitle: Text("Due: ${item.dueDate}"),

                  trailing: Chip(
                    label: Text(item.status),

                    backgroundColor: item.status == "PAID"
                        ? Colors.green.shade200
                        : Colors.orange.shade200,
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
