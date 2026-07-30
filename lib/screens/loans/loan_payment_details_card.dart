// import 'package:creafton_financial_services/core/theme/app_colors.dart';
// import 'package:creafton_financial_services/providers/loan_payment_details_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class LoanPaymentDetailsCard extends StatefulWidget {
//   final int loanId;

//   final double loanBalance;

//   const LoanPaymentDetailsCard({
//     super.key,

//     required this.loanId,

//     required this.loanBalance,
//   });

//   @override
//   State<LoanPaymentDetailsCard> createState() => _LoanPaymentDetailsCardState();
// }

// class _LoanPaymentDetailsCardState extends State<LoanPaymentDetailsCard> {
//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<LoanPaymentDetailsProvider>().loadPayments(
//         widget.loanId,
//         widget.loanBalance,
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<LoanPaymentDetailsProvider>(
//       builder: (context, provider, child) {
//         if (provider.loading) {
//           return _loadingCard();
//         }

//         if (provider.error != null) {
//           return _errorCard(provider.error!);
//         }

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,

//           children: [
//             _header(),

//             const SizedBox(height: 20),

//             _summary(provider),

//             const SizedBox(height: 25),

//             _history(provider),
//           ],
//         );
//       },
//     );
//   }

//   Widget _header() {
//     return Container(
//       width: double.infinity,

//       padding: const EdgeInsets.all(22),

//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             AppColors.primaryBlue,

//             AppColors.primaryBlue.withOpacity(.75),
//           ],
//         ),

//         borderRadius: BorderRadius.circular(20),
//       ),

//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),

//             decoration: BoxDecoration(
//               color: Colors.white24,

//               borderRadius: BorderRadius.circular(15),
//             ),

//             child: const Icon(
//               Icons.account_balance_wallet,

//               color: Colors.white,

//               size: 30,
//             ),
//           ),

//           const SizedBox(width: 15),

//           const Column(
//             crossAxisAlignment: CrossAxisAlignment.start,

//             children: [
//               Text(
//                 "Loan Payment History",

//                 style: TextStyle(
//                   color: Colors.white,

//                   fontSize: 20,

//                   fontWeight: FontWeight.bold,
//                 ),
//               ),

//               SizedBox(height: 5),

//               Text(
//                 "Track all collections",

//                 style: TextStyle(color: Colors.white70),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _summary(LoanPaymentDetailsProvider provider) {
//     return Row(
//       children: [
//         Expanded(
//           child: _summaryBox(
//             Icons.payments,

//             "Paid",

//             "UGX ${provider.totalPaid.toStringAsFixed(0)}",

//             Colors.green,
//           ),
//         ),

//         const SizedBox(width: 12),

//         Expanded(
//           child: _summaryBox(
//             Icons.account_balance,

//             "Balance",

//             "UGX ${provider.remainingBalance.toStringAsFixed(0)}",

//             Colors.orange,
//           ),
//         ),

//         const SizedBox(width: 12),

//         Expanded(
//           child: _summaryBox(
//             Icons.receipt_long,

//             "Payments",

//             provider.paymentCount.toString(),

//             AppColors.primaryBlue,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _summaryBox(IconData icon, String title, String value, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(15),

//       decoration: BoxDecoration(
//         color: Colors.white,

//         borderRadius: BorderRadius.circular(18),

//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10),
//         ],
//       ),

//       child: Column(
//         children: [
//           CircleAvatar(
//             backgroundColor: color.withOpacity(.15),

//             child: Icon(icon, color: color),
//           ),

//           const SizedBox(height: 10),

//           Text(
//             value,

//             textAlign: TextAlign.center,

//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//           ),

//           Text(
//             title,

//             style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _history(LoanPaymentDetailsProvider provider) {
//     return Card(
//       elevation: 2,

//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

//       child: Padding(
//         padding: const EdgeInsets.all(20),

//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,

//           children: [
//             const Text(
//               "Payment Transactions",

//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 15),

//             if (provider.payments.isEmpty)
//               _emptyState()
//             else
//               ListView.builder(
//                 shrinkWrap: true,

//                 physics: const NeverScrollableScrollPhysics(),

//                 itemCount: provider.payments.length,

//                 itemBuilder: (context, index) {
//                   final payment = provider.payments[index];

//                   return _paymentItem(payment);
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _paymentItem(dynamic payment) {
//     final status = payment.status ?? "PAID";

//     final color = status == "PAID"
//         ? Colors.green
//         : status == "LATE"
//         ? Colors.orange
//         : Colors.red;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 15),

//       padding: const EdgeInsets.all(15),

//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,

//         borderRadius: BorderRadius.circular(15),

//         border: Border.all(color: Colors.grey.shade200),
//       ),

//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 22,

//             backgroundColor: color.withOpacity(.15),

//             child: Icon(Icons.check_circle, color: color),
//           ),

//           const SizedBox(width: 15),

//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,

//               children: [
//                 Text(
//                   "Payment #${payment.paymentNumber ?? '-'}",

//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),

//                 const SizedBox(height: 5),

//                 Text("UGX ${payment.amount.toStringAsFixed(0)}"),

//                 Text(
//                   _date(payment.paymentDate),

//                   style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
//                 ),
//               ],
//             ),
//           ),

//           Chip(label: Text(status), backgroundColor: color.withOpacity(.15)),
//         ],
//       ),
//     );
//   }

//   Widget _emptyState() {
//     return const Padding(
//       padding: EdgeInsets.all(25),

//       child: Center(
//         child: Column(
//           children: [
//             Icon(Icons.history, size: 45, color: Colors.grey),

//             SizedBox(height: 10),

//             Text("No payments recorded"),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _loadingCard() {
//     return const Card(
//       child: SizedBox(
//         height: 150,

//         child: Center(child: CircularProgressIndicator()),
//       ),
//     );
//   }

//   Widget _errorCard(String error) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(20),

//         child: Text(error, style: const TextStyle(color: Colors.red)),
//       ),
//     );
//   }

//   String _date(String? value) {
//     if (value == null) {
//       return "-";
//     }

//     try {
//       final d = DateTime.parse(value);

//       return "${d.day}/${d.month}/${d.year}";
//     } catch (e) {
//       return value;
//     }
//   }
// }

import 'package:creafton_financial_services/core/theme/app_colors.dart';
import 'package:creafton_financial_services/providers/loan_payment_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Status of an individual day in the loan's payment schedule.
enum DayPaymentStatus { paid, pending, upcoming }

/// Design tokens for this card. Kept local to this file so the redesign is
/// self-contained; promote any of these to AppColors if you want the rest
/// of the app to share them.
class _Tone {
  static const Color ink = Color(0xFF0F172A);
  static const Color muted = Color(0xFF64748B);
  static const Color faint = Color(0xFF94A3B8);
  static const Color surface = Color(0xFFF8FAFC);
  static const Color border = Color(0xFFE7EAF0);

  static const Color paid = Color(0xFF059669);
  static const Color paidBg = Color(0xFFECFDF5);

  static const Color pending = Color(0xFFD97706);
  static const Color pendingBg = Color(0xFFFFF7ED);

  static const Color upcoming = Color(0xFFB4BCC9);
  static const Color upcomingBg = Color(0xFFF1F5F9);

  static const Color streak = Color(0xFF7C3AED);
  static const Color streakBg = Color(0xFFF5F3FF);
}

/// Precomputed schedule data shared across the header, stats and day grid so
/// it's only calculated once per build.
class _ScheduleData {
  final int totalDays;
  final DateTime? startDate;
  final Set<int> paidDays;
  final int currentDay;
  final int streak;

  _ScheduleData({
    required this.totalDays,
    required this.startDate,
    required this.paidDays,
    required this.currentDay,
    required this.streak,
  });

  double get completion => totalDays == 0 ? 0 : paidDays.length / totalDays;
}

class LoanPaymentDetailsCard extends StatefulWidget {
  final int loanId;

  final double loanBalance;

  /// Loan term length in days, i.e. `Loan.loanDuration`.
  final int loanDuration;

  /// `Loan.startDate` (ISO8601 string), used to know which day is "today"
  /// so days that haven't arrived yet show as upcoming rather than pending.
  final String? startDate;

  const LoanPaymentDetailsCard({
    super.key,

    required this.loanId,

    required this.loanBalance,

    required this.loanDuration,

    this.startDate,
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

        final schedule = _buildScheduleData(provider);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            _header(schedule),

            const SizedBox(height: 18),

            _statsStrip(provider),

            const SizedBox(height: 18),

            _daySchedule(schedule),

            const SizedBox(height: 18),

            _history(provider),
          ],
        );
      },
    );
  }

  // -------------------------------------------------------------------
  // Schedule computation
  // -------------------------------------------------------------------

  _ScheduleData _buildScheduleData(LoanPaymentDetailsProvider provider) {
    final int totalDays = widget.loanDuration;

    final DateTime? startDate = widget.startDate == null
        ? null
        : DateTime.tryParse(widget.startDate!);

    // Which days already have a registered payment. We do NOT use
    // payment.paymentNumber — that field is a global/running counter and
    // does not reset per loan. Instead we derive the day number from how
    // many days after this loan's startDate the payment was made.
    final Set<int> paidDays = startDate == null
        ? <int>{}
        : provider.payments
              .map<int?>((p) {
                final rawDate = p.paymentDate;

                if (rawDate == null) return null;

                DateTime? paymentDate;

                if (rawDate is DateTime) {
                  paymentDate = rawDate as DateTime?;
                } else {
                  paymentDate = DateTime.tryParse(rawDate.toString());
                }

                if (paymentDate == null) return null;

                final startDay = DateTime(
                  startDate.year,
                  startDate.month,
                  startDate.day,
                );
                final payDay = DateTime(
                  paymentDate.year,
                  paymentDate.month,
                  paymentDate.day,
                );

                return payDay.difference(startDay).inDays + 1;
              })
              .whereType<int>()
              .where((day) => day >= 1 && day <= totalDays)
              .toSet();

    final int currentDay = startDate == null
        ? totalDays
        : (DateTime.now().difference(startDate).inDays + 1).clamp(0, totalDays);

    // Current streak: consecutive paid days ending at the most recently
    // due day (today if already paid, otherwise the day before).
    int streak = 0;

    int cursor = paidDays.contains(currentDay) ? currentDay : currentDay - 1;

    while (cursor >= 1 && paidDays.contains(cursor)) {
      streak++;

      cursor--;
    }

    return _ScheduleData(
      totalDays: totalDays,
      startDate: startDate,
      paidDays: paidDays,
      currentDay: currentDay,
      streak: streak,
    );
  }

  // -------------------------------------------------------------------
  // Header
  // -------------------------------------------------------------------

  Widget _header(_ScheduleData schedule) {
    final percent = (schedule.completion * 100).round();

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,

          end: Alignment.bottomRight,

          colors: [
            AppColors.primaryBlue,

            AppColors.primaryBlue.withOpacity(.82),
          ],
        ),

        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(.25),

            blurRadius: 20,

            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.16),

              borderRadius: BorderRadius.circular(16),
            ),

            child: const Icon(
              Icons.account_balance_wallet_rounded,

              color: Colors.white,

              size: 26,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  "Loan Payment History",

                  style: TextStyle(
                    color: Colors.white,

                    fontSize: 19,

                    fontWeight: FontWeight.w800,

                    letterSpacing: -0.2,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  schedule.totalDays > 0
                      ? "Day ${schedule.currentDay.clamp(1, schedule.totalDays)} of ${schedule.totalDays}"
                      : "Track all collections",

                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          _completionRing(percent),
        ],
      ),
    );
  }

  Widget _completionRing(int percent) {
    return SizedBox(
      width: 54,

      height: 54,

      child: Stack(
        alignment: Alignment.center,

        children: [
          SizedBox(
            width: 54,

            height: 54,

            child: CircularProgressIndicator(
              value: (percent / 100).clamp(0, 1).toDouble(),

              strokeWidth: 5,

              backgroundColor: Colors.white.withOpacity(.22),

              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),

          Text(
            "$percent%",

            style: const TextStyle(
              color: Colors.white,

              fontSize: 13,

              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------
  // Stats strip
  // -------------------------------------------------------------------

  Widget _statsStrip(LoanPaymentDetailsProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: _Tone.border),
      ),

      padding: const EdgeInsets.symmetric(vertical: 18),

      child: Row(
        children: [
          Expanded(
            child: _statItem(
              Icons.payments_rounded,

              "Paid",

              "UGX ${provider.totalPaid.toStringAsFixed(0)}",

              _Tone.paid,
            ),
          ),

          _statDivider(),

          Expanded(
            child: _statItem(
              Icons.account_balance_rounded,

              "Balance",

              "UGX ${provider.remainingBalance.toStringAsFixed(0)}",

              _Tone.pending,
            ),
          ),

          _statDivider(),

          Expanded(
            child: _statItem(
              Icons.receipt_long_rounded,

              "Payments",

              provider.paymentCount.toString(),

              AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statDivider() {
    return Container(width: 1, height: 40, color: _Tone.border);
  }

  Widget _statItem(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(9),

          decoration: BoxDecoration(
            color: color.withOpacity(.12),

            borderRadius: BorderRadius.circular(12),
          ),

          child: Icon(icon, color: color, size: 18),
        ),

        const SizedBox(height: 10),

        Text(
          value,

          textAlign: TextAlign.center,

          maxLines: 1,

          overflow: TextOverflow.ellipsis,

          style: const TextStyle(
            fontWeight: FontWeight.w800,

            fontSize: 13,

            color: _Tone.ink,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          label,

          style: const TextStyle(
            color: _Tone.muted,

            fontSize: 11,

            fontWeight: FontWeight.w500,

            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------------
  // Day schedule (heatmap grid)
  // -------------------------------------------------------------------

  Widget _daySchedule(_ScheduleData schedule) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: _Tone.border),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              const Text(
                "Daily Schedule",

                style: TextStyle(
                  fontSize: 16,

                  fontWeight: FontWeight.w800,

                  color: _Tone.ink,
                ),
              ),

              if (schedule.streak > 0) _streakBadge(schedule.streak),
            ],
          ),

          const SizedBox(height: 14),

          _dayLegend(),

          const SizedBox(height: 16),

          Wrap(
            spacing: 7,

            runSpacing: 7,

            children: List.generate(schedule.totalDays, (i) {
              final day = i + 1;

              final status = schedule.paidDays.contains(day)
                  ? DayPaymentStatus.paid
                  : (day <= schedule.currentDay
                        ? DayPaymentStatus.pending
                        : DayPaymentStatus.upcoming);

              final isToday = day == schedule.currentDay;

              return _dayCell(day, status, isToday, schedule.startDate);
            }),
          ),
        ],
      ),
    );
  }

  Widget _streakBadge(int streak) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

      decoration: BoxDecoration(
        color: _Tone.streakBg,

        borderRadius: BorderRadius.circular(999),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          const Icon(Icons.bolt_rounded, size: 14, color: _Tone.streak),

          const SizedBox(width: 4),

          Text(
            "$streak-day streak",

            style: const TextStyle(
              fontSize: 11,

              fontWeight: FontWeight.w700,

              color: _Tone.streak,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dayLegend() {
    Widget dot(Color color, String label) {
      return Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Container(
            width: 9,

            height: 9,

            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          const SizedBox(width: 6),

          Text(
            label,
            style: const TextStyle(color: _Tone.muted, fontSize: 11.5),
          ),
        ],
      );
    }

    return Wrap(
      spacing: 16,

      runSpacing: 6,

      children: [
        dot(_Tone.paid, "Paid"),

        dot(_Tone.pending, "Pending"),

        dot(_Tone.upcoming, "Upcoming"),
      ],
    );
  }

  Widget _dayCell(
    int day,
    DayPaymentStatus status,
    bool isToday,
    DateTime? startDate,
  ) {
    late final Color fg;

    late final Color bg;

    switch (status) {
      case DayPaymentStatus.paid:
        fg = _Tone.paid;

        bg = _Tone.paidBg;

        break;

      case DayPaymentStatus.pending:
        fg = _Tone.pending;

        bg = _Tone.pendingBg;

        break;

      case DayPaymentStatus.upcoming:
        fg = _Tone.upcoming;

        bg = _Tone.upcomingBg;

        break;
    }

    final message = startDate == null
        ? "Day $day"
        : "Day $day — ${_formatDate(startDate.add(Duration(days: day - 1)))}";

    return Tooltip(
      message:
          "$message"
          "${status == DayPaymentStatus.paid
              ? ' · Paid'
              : status == DayPaymentStatus.pending
              ? ' · Pending'
              : ' · Upcoming'}",

      child: Container(
        width: 30,

        height: 30,

        alignment: Alignment.center,

        decoration: BoxDecoration(
          color: status == DayPaymentStatus.paid ? fg : bg,

          borderRadius: BorderRadius.circular(8),

          border: isToday
              ? Border.all(color: AppColors.primaryBlue, width: 2)
              : null,
        ),

        child: status == DayPaymentStatus.paid
            ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
            : Text(
                "$day",

                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
              ),
      ),
    );
  }

  // -------------------------------------------------------------------
  // Payment history
  // -------------------------------------------------------------------

  Widget _history(LoanPaymentDetailsProvider provider) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: _Tone.border),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            "Payment Transactions",

            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: _Tone.ink,
            ),
          ),

          const SizedBox(height: 14),

          if (provider.payments.isEmpty)
            _emptyState()
          else
            ListView.separated(
              shrinkWrap: true,

              physics: const NeverScrollableScrollPhysics(),

              itemCount: provider.payments.length,

              separatorBuilder: (context, index) => const SizedBox(height: 10),

              itemBuilder: (context, index) {
                final payment = provider.payments[index];

                return _paymentItem(payment);
              },
            ),
        ],
      ),
    );
  }

  Widget _paymentItem(dynamic payment) {
    final status = payment.status ?? "PAID";

    final color = status == "PAID"
        ? _Tone.paid
        : status == "LATE"
        ? _Tone.pending
        : Colors.red;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          Container(
            width: 4,

            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),

              decoration: BoxDecoration(
                color: _Tone.surface,

                borderRadius: BorderRadius.circular(14),
              ),

              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),

                    decoration: BoxDecoration(
                      color: color.withOpacity(.12),

                      shape: BoxShape.circle,
                    ),

                    child: Icon(Icons.check_rounded, color: color, size: 16),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          "UGX ${payment.amount.toStringAsFixed(0)}",

                          style: const TextStyle(
                            fontWeight: FontWeight.w800,

                            fontSize: 14,

                            color: _Tone.ink,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          "Payment #${payment.paymentNumber ?? '-'}  ·  ${_date(payment.paymentDate)}",

                          style: const TextStyle(
                            color: _Tone.muted,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),

                    decoration: BoxDecoration(
                      color: color.withOpacity(.12),

                      borderRadius: BorderRadius.circular(999),
                    ),

                    child: Text(
                      status,

                      style: TextStyle(
                        color: color,

                        fontSize: 10.5,

                        fontWeight: FontWeight.w700,

                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),

      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: _Tone.surface,
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.history_rounded,
                size: 30,
                color: _Tone.faint,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "No payments recorded",

              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: _Tone.ink,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              "Payments will show up here once collected",

              style: TextStyle(color: _Tone.muted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loadingCard() {
    return Container(
      height: 160,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: _Tone.border),
      ),

      child: const Center(
        child: SizedBox(
          width: 26,

          height: 26,

          child: CircularProgressIndicator(strokeWidth: 3),
        ),
      ),
    );
  }

  Widget _errorCard(String error) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.red.withOpacity(.05),

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: Colors.red.withOpacity(.2)),
      ),

      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.red, size: 20),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              error,

              style: const TextStyle(
                color: Colors.red,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _date(String? value) {
    if (value == null) {
      return "-";
    }

    try {
      final d = DateTime.parse(value);

      return _formatDate(d);
    } catch (e) {
      return value;
    }
  }

  String _formatDate(DateTime d) => "${d.day}/${d.month}/${d.year}";
}
