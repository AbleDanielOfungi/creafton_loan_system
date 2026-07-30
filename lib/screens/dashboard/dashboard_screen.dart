
// import 'package:creafton_financial_services/screens/dashboard/dashboard_repository.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';



// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   late Future<DashboardStats> _future;

//   static const _bg = Color(0xFFF4F6F9);
//   static const _card = Colors.white;
//   static const _ink = Color(0xFF1B2430);
//   static const _muted = Color(0xFF6B7280);
//   static const _primary = Color(0xFF2F6FED);

//   static const _statusColors = {
//     'ACTIVE': Color(0xFF16A34A),
//     'COMPLETED': Color(0xFF2F6FED),
//     'OVERDUE': Color(0xFFDC2626),
//     'DEFAULTED': Color(0xFF9333EA),
//     'PENDING': Color(0xFFF59E0B),
//   };

//   @override
//   void initState() {
//     super.initState();
//     _future = DashboardRepository.loadDashboard();
//   }

//   // void _refresh() {
//   //   setState(() => _future = DashboardRepository.loadDashboard());
//   // }


//   void _refresh() {
//   setState(() {
//     _future = DashboardRepository.loadDashboard();
//   });
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _bg,
//       body: SafeArea(
//         child: FutureBuilder<DashboardStats>(
//           future: _future,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (snapshot.hasError) {
//               return _ErrorState(error: snapshot.error.toString(), onRetry: _refresh);
//             }
//             final stats = snapshot.data!;
//             final money = NumberFormat.currency(
//               locale: 'en_US',
//               symbol: '${stats.currency} ',
//               decimalDigits: 0,
//             );

//             return RefreshIndicator(
//               onRefresh: () async => _refresh(),
//               child: SingleChildScrollView(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 padding: const EdgeInsets.all(24),
//                 child: ConstrainedBox(
//                   constraints: const BoxConstraints(maxWidth: 1400),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _Header(businessName: stats.businessName, onRefresh: _refresh),
//                       const SizedBox(height: 24),
//                       _StatGrid(stats: stats, money: money),
//                       const SizedBox(height: 24),
//                       LayoutBuilder(
//                         builder: (context, constraints) {
//                           final wide = constraints.maxWidth > 900;
//                           final loanStatus = _SectionCard(
//                             title: 'Loan Portfolio Status',
//                             child: _LoanStatusBreakdown(
//                               breakdown: stats.loanStatusBreakdown,
//                               colors: _statusColors,
//                             ),
//                           );
//                           final payments = _SectionCard(
//                             title: 'Recent Payments',
//                             child: _RecentPaymentsList(
//                               payments: stats.recentPayments,
//                               money: money,
//                               statusColors: _statusColors,
//                             ),
//                           );
//                           if (!wide) {
//                             return Column(children: [
//                               loanStatus,
//                               const SizedBox(height: 20),
//                               payments,
//                             ]);
//                           }
//                           return IntrinsicHeight(
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.stretch,
//                               children: [
//                                 Expanded(flex: 2, child: loanStatus),
//                                 const SizedBox(width: 20),
//                                 Expanded(flex: 3, child: payments),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                       LayoutBuilder(
//                         builder: (context, constraints) {
//                           final wide = constraints.maxWidth > 900;
//                           final officers = _SectionCard(
//                             title: 'Top Field Officers',
//                             child: _OfficerLeaderboard(
//                               officers: stats.topOfficers,
//                               money: money,
//                             ),
//                           );
//                           final borrowers = _SectionCard(
//                             title: 'Recently Onboarded Borrowers',
//                             child: _RecentBorrowersList(borrowers: stats.recentBorrowers),
//                           );
//                           if (!wide) {
//                             return Column(children: [
//                               officers,
//                               const SizedBox(height: 20),
//                               borrowers,
//                             ]);
//                           }
//                           return IntrinsicHeight(
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.stretch,
//                               children: [
//                                 Expanded(child: officers),
//                                 const SizedBox(width: 20),
//                                 Expanded(child: borrowers),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                       const SizedBox(height: 12),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// // ---------------------------------------------------------------------------
// // Header
// // ---------------------------------------------------------------------------

// class _Header extends StatelessWidget {
//   final String businessName;
//   final VoidCallback onRefresh;

//   const _Header({required this.businessName, required this.onRefresh});

//   @override
//   Widget build(BuildContext context) {
//     final today = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
//     return Row(
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 businessName,
//                 style: const TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.w700,
//                   color: _DashboardScreenState._ink,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 'Dashboard overview · $today',
//                 style: const TextStyle(fontSize: 14, color: _DashboardScreenState._muted),
//               ),
//             ],
//           ),
//         ),
//         OutlinedButton.icon(
//           onPressed: onRefresh,
//           icon: const Icon(Icons.refresh, size: 18),
//           label: const Text('Refresh'),
//           style: OutlinedButton.styleFrom(
//             foregroundColor: _DashboardScreenState._ink,
//             side: BorderSide(color: Colors.grey.shade300),
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ---------------------------------------------------------------------------
// // KPI stat grid
// // ---------------------------------------------------------------------------

// class _StatGrid extends StatelessWidget {
//   final DashboardStats stats;
//   final NumberFormat money;

//   const _StatGrid({required this.stats, required this.money});

//   @override
//   Widget build(BuildContext context) {
//     final items = <_StatCardData>[
//       _StatCardData(
//         label: 'Active Borrowers',
//         value: '${stats.activeBorrowers}',
//         sub: '${stats.totalBorrowers} total',
//         icon: Icons.people_alt_rounded,
//         color: const Color(0xFF2F6FED),
//       ),
//       _StatCardData(
//         label: 'Active Loans',
//         value: '${stats.activeLoans}',
//         sub: '${stats.totalLoans} total · ${stats.overdueLoans} overdue',
//         icon: Icons.request_page_rounded,
//         color: const Color(0xFF16A34A),
//       ),
//       _StatCardData(
//         label: 'Outstanding Portfolio',
//         value: money.format(stats.totalPortfolio),
//         sub: '${money.format(stats.totalDisbursed)} disbursed total',
//         icon: Icons.account_balance_wallet_rounded,
//         color: const Color(0xFFF59E0B),
//       ),
//       _StatCardData(
//         label: 'Collected Today',
//         value: money.format(stats.collectedToday),
//         sub: '${money.format(stats.collectedThisMonth)} this month',
//         icon: Icons.payments_rounded,
//         color: const Color(0xFF0EA5E9),
//       ),
//       _StatCardData(
//         label: 'Expenses This Month',
//         value: money.format(stats.expendituresThisMonth),
//         sub: 'Net: ${money.format(stats.netThisMonth)}',
//         icon: Icons.trending_down_rounded,
//         color: const Color(0xFFDC2626),
//       ),
//       _StatCardData(
//         label: 'Field Officers',
//         value: '${stats.activeFieldOfficers}',
//         sub: '${stats.totalFieldOfficers} total',
//         icon: Icons.badge_rounded,
//         color: const Color(0xFF9333EA),
//       ),
//       _StatCardData(
//         label: 'Completed Loans',
//         value: '${stats.completedLoans}',
//         sub: 'Fully repaid',
//         icon: Icons.check_circle_rounded,
//         color: const Color(0xFF14B8A6),
//       ),
//       _StatCardData(
//         label: 'Recovery Rate',
//         value: '${stats.overallRecoveryRate.toStringAsFixed(1)}%',
//         sub: 'Collected vs disbursed',
//         icon: Icons.insights_rounded,
//         color: const Color(0xFF64748B),
//       ),
//     ];

//     return LayoutBuilder(
//       builder: (context, constraints) {
//         int columns = 4;
//         if (constraints.maxWidth < 1200) columns = 3;
//         if (constraints.maxWidth < 850) columns = 2;
//         if (constraints.maxWidth < 500) columns = 1;

//         return GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: items.length,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: columns,
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 16,
//             childAspectRatio: 2.4,
//           ),
//           itemBuilder: (context, i) => _StatCard(data: items[i]),
//         );
//       },
//     );
//   }
// }

// class _StatCardData {
//   final String label;
//   final String value;
//   final String sub;
//   final IconData icon;
//   final Color color;

//   _StatCardData({
//     required this.label,
//     required this.value,
//     required this.sub,
//     required this.icon,
//     required this.color,
//   });
// }

// class _StatCard extends StatelessWidget {
//   final _StatCardData data;

//   const _StatCard({required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: _DashboardScreenState._card,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: Colors.grey.shade200),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 44,
//             height: 44,
//             decoration: BoxDecoration(
//               color: data.color.withOpacity(0.12),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(data.icon, color: data.color, size: 22),
//           ),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   data.label,
//                   style: const TextStyle(fontSize: 13, color: _DashboardScreenState._muted),
//                 ),
//                 const SizedBox(height: 4),
//                 FittedBox(
//                   fit: BoxFit.scaleDown,
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     data.value,
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w700,
//                       color: _DashboardScreenState._ink,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   data.sub,
//                   style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ---------------------------------------------------------------------------
// // Reusable section card wrapper
// // ---------------------------------------------------------------------------

// class _SectionCard extends StatelessWidget {
//   final String title;
//   final Widget child;

//   const _SectionCard({required this.title, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: _DashboardScreenState._card,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               color: _DashboardScreenState._ink,
//             ),
//           ),
//           const SizedBox(height: 16),
//           child,
//         ],
//       ),
//     );
//   }
// }

// // ---------------------------------------------------------------------------
// // Loan status breakdown (simple horizontal bars, no external chart package)
// // ---------------------------------------------------------------------------

// class _LoanStatusBreakdown extends StatelessWidget {
//   final Map<String, int> breakdown;
//   final Map<String, Color> colors;

//   const _LoanStatusBreakdown({required this.breakdown, required this.colors});

//   @override
//   Widget build(BuildContext context) {
//     if (breakdown.isEmpty) {
//       return const _EmptyHint(text: 'No loans recorded yet.');
//     }
//     final total = breakdown.values.fold<int>(0, (a, b) => a + b);
//     final entries = breakdown.entries.toList()
//       ..sort((a, b) => b.value.compareTo(a.value));

//     return Column(
//       children: entries.map((e) {
//         final pct = total == 0 ? 0.0 : e.value / total;
//         final color = colors[e.key] ?? Colors.grey;
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 14),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Text(
//                     e.key,
//                     style: const TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600,
//                       color: _DashboardScreenState._ink,
//                     ),
//                   ),
//                   const Spacer(),
//                   Text(
//                     '${e.value} (${(pct * 100).toStringAsFixed(0)}%)',
//                     style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 6),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(6),
//                 child: LinearProgressIndicator(
//                   value: pct,
//                   minHeight: 8,
//                   backgroundColor: Colors.grey.shade100,
//                   valueColor: AlwaysStoppedAnimation(color),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }).toList(),
//     );
//   }
// }

// // ---------------------------------------------------------------------------
// // Recent payments list
// // ---------------------------------------------------------------------------

// class _RecentPaymentsList extends StatelessWidget {
//   final List<RecentPayment> payments;
//   final NumberFormat money;
//   final Map<String, Color> statusColors;

//   const _RecentPaymentsList({
//     required this.payments,
//     required this.money,
//     required this.statusColors,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (payments.isEmpty) {
//       return const _EmptyHint(text: 'No payments recorded yet.');
//     }
//     return Column(
//       children: payments.map((p) {
//         final color = statusColors[p.status] ?? Colors.grey;
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 12),
//           child: Row(
//             children: [
//               Container(
//                 width: 8,
//                 height: 8,
//                 decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       p.borrowerName,
//                       style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
//                     ),
//                     Text(
//                       'Loan ${p.loanNumber} · ${p.paymentDate ?? '—'}',
//                       style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
//                     ),
//                   ],
//                 ),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(
//                     money.format(p.amount),
//                     style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
//                   ),
//                   Text(
//                     p.status,
//                     style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       }).toList(),
//     );
//   }
// }

// // ---------------------------------------------------------------------------
// // Officer leaderboard
// // ---------------------------------------------------------------------------

// class _OfficerLeaderboard extends StatelessWidget {
//   final List<OfficerPerformance> officers;
//   final NumberFormat money;

//   const _OfficerLeaderboard({required this.officers, required this.money});

//   @override
//   Widget build(BuildContext context) {
//     if (officers.isEmpty) {
//       return const _EmptyHint(text: 'No performance data yet.');
//     }
//     return Column(
//       children: officers.asMap().entries.map((entry) {
//         final i = entry.key;
//         final o = entry.value;
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 12),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 radius: 14,
//                 backgroundColor: _DashboardScreenState._primary.withOpacity(0.1),
//                 child: Text(
//                   '${i + 1}',
//                   style: const TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w700,
//                     color: _DashboardScreenState._primary,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(o.fullName,
//                         style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
//                     Text(
//                       '${o.activeLoans} active loans · ${o.recoveryRate.toStringAsFixed(0)}% recovery',
//                       style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
//                     ),
//                   ],
//                 ),
//               ),
//               Text(
//                 money.format(o.totalCollected),
//                 style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
//               ),
//             ],
//           ),
//         );
//       }).toList(),
//     );
//   }
// }

// // ---------------------------------------------------------------------------
// // Recent borrowers list
// // ---------------------------------------------------------------------------

// class _RecentBorrowersList extends StatelessWidget {
//   final List<RecentBorrower> borrowers;

//   const _RecentBorrowersList({required this.borrowers});

//   @override
//   Widget build(BuildContext context) {
//     if (borrowers.isEmpty) {
//       return const _EmptyHint(text: 'No borrowers onboarded yet.');
//     }
//     return Column(
//       children: borrowers.map((b) {
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 12),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 radius: 16,
//                 backgroundColor: Colors.grey.shade100,
//                 child: Text(
//                   b.fullName.isNotEmpty ? b.fullName[0].toUpperCase() : '?',
//                   style: const TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w700,
//                     color: _DashboardScreenState._ink,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(b.fullName,
//                         style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
//                     Text(
//                       '${b.borrowerNumber} · ${b.phone}',
//                       style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.green.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Text(
//                   b.status,
//                   style: const TextStyle(
//                     fontSize: 11,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF16A34A),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }).toList(),
//     );
//   }
// }

// // ---------------------------------------------------------------------------
// // Shared small widgets
// // ---------------------------------------------------------------------------

// class _EmptyHint extends StatelessWidget {
//   final String text;

//   const _EmptyHint({required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 20),
//       child: Center(
//         child: Text(text, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
//       ),
//     );
//   }
// }

// class _ErrorState extends StatelessWidget {
//   final String error;
//   final VoidCallback onRetry;

//   const _ErrorState({required this.error, required this.onRetry});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Icon(Icons.error_outline_rounded, size: 40, color: Colors.redAccent),
//           const SizedBox(height: 12),
//           const Text('Could not load dashboard data',
//               style: TextStyle(fontWeight: FontWeight.w600)),
//           const SizedBox(height: 6),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 32),
//             child: Text(
//               error,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//             ),
//           ),
//           const SizedBox(height: 16),
//           ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
//         ],
//       ),
//     );
//   }
// }


import 'package:creafton_financial_services/screens/dashboard/dashboard_repository.dart';
import 'package:creafton_financial_services/screens/dashboard/pdf_export.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


/// Desktop-oriented overview dashboard for the Creafton Financial app.
///
/// Pulls a single aggregated [DashboardStats] snapshot from
/// [DashboardRepository.loadDashboard] and renders:
///   - Header with business name + refresh
///   - KPI stat cards (borrowers, loans, portfolio, collections, etc.)
///   - Loan status breakdown
///   - Recent payments feed
///   - Top field officer leaderboard
///   - Recently onboarded borrowers
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<DashboardStats> _future;
  bool _exporting = false;

  static const _bg = Color(0xFFF4F6F9);
  static const _card = Colors.white;
  static const _ink = Color(0xFF1B2430);
  static const _muted = Color(0xFF6B7280);
  static const _primary = Color(0xFF2F6FED);

  static const _statusColors = {
    'ACTIVE': Color(0xFF16A34A),
    'COMPLETED': Color(0xFF2F6FED),
    'OVERDUE': Color(0xFFDC2626),
    'DEFAULTED': Color(0xFF9333EA),
    'PENDING': Color(0xFFF59E0B),
  };

  @override
  void initState() {
    super.initState();
    _future = DashboardRepository.loadDashboard();
  }

  void _refresh() {
    setState(() {
      _future = DashboardRepository.loadDashboard();
    });
  }

  Future<void> _exportTodayDefaulters(DashboardStats stats) async {
    if (_exporting) return;
    setState(() => _exporting = true);
    try {
      await PdfExport.exportTodayDefaulters(
        defaulters: stats.todayDefaulters,
        businessName: stats.businessName,
        currency: stats.currency,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not export PDF: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: FutureBuilder<DashboardStats>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return _ErrorState(error: snapshot.error.toString(), onRetry: _refresh);
            }
            final stats = snapshot.data!;
            final money = NumberFormat.currency(
              locale: 'en_US',
              symbol: '${stats.currency} ',
              decimalDigits: 0,
            );

            return RefreshIndicator(
              onRefresh: () async => _refresh(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Header(businessName: stats.businessName, onRefresh: _refresh),
                      const SizedBox(height: 24),
                      _StatGrid(stats: stats, money: money),
                      const SizedBox(height: 24),
                      _SectionCard(
                        title: 'Not Paid Today (${stats.todayDefaulters.length})',
                        trailing: OutlinedButton.icon(
                          onPressed: stats.todayDefaulters.isEmpty || _exporting
                              ? null
                              : () => _exportTodayDefaulters(stats),
                          icon: _exporting
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.picture_as_pdf_rounded, size: 16),
                          label: Text(_exporting ? 'Exporting…' : 'Export PDF'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFDC2626),
                            side: const BorderSide(color: Color(0xFFDC2626)),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          ),
                        ),
                        child: _TodayDefaultersList(
                          defaulters: stats.todayDefaulters,
                          money: money,
                        ),
                      ),
                      const SizedBox(height: 24),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final wide = constraints.maxWidth > 900;
                          final loanStatus = _SectionCard(
                            title: 'Loan Portfolio Status',
                            child: _LoanStatusBreakdown(
                              breakdown: stats.loanStatusBreakdown,
                              colors: _statusColors,
                            ),
                          );
                          final payments = _SectionCard(
                            title: 'Recent Payments',
                            child: _RecentPaymentsList(
                              payments: stats.recentPayments,
                              money: money,
                              statusColors: _statusColors,
                            ),
                          );
                          if (!wide) {
                            return Column(children: [
                              loanStatus,
                              const SizedBox(height: 20),
                              payments,
                            ]);
                          }
                          return IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(flex: 2, child: loanStatus),
                                const SizedBox(width: 20),
                                Expanded(flex: 3, child: payments),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final wide = constraints.maxWidth > 900;
                          final officers = _SectionCard(
                            title: 'Top Field Officers',
                            child: _OfficerLeaderboard(
                              officers: stats.topOfficers,
                              money: money,
                            ),
                          );
                          final borrowers = _SectionCard(
                            title: 'Recently Onboarded Borrowers',
                            child: _RecentBorrowersList(borrowers: stats.recentBorrowers),
                          );
                          if (!wide) {
                            return Column(children: [
                              officers,
                              const SizedBox(height: 20),
                              borrowers,
                            ]);
                          }
                          return IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(child: officers),
                                const SizedBox(width: 20),
                                Expanded(child: borrowers),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
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
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  final String businessName;
  final VoidCallback onRefresh;

  const _Header({required this.businessName, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                businessName,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: _DashboardScreenState._ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Dashboard overview · $today',
                style: const TextStyle(fontSize: 14, color: _DashboardScreenState._muted),
              ),
            ],
          ),
        ),
        OutlinedButton.icon(
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text('Refresh'),
          style: OutlinedButton.styleFrom(
            foregroundColor: _DashboardScreenState._ink,
            side: BorderSide(color: Colors.grey.shade300),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// KPI stat grid
// ---------------------------------------------------------------------------

class _StatGrid extends StatelessWidget {
  final DashboardStats stats;
  final NumberFormat money;

  const _StatGrid({required this.stats, required this.money});

  @override
  Widget build(BuildContext context) {
    final items = <_StatCardData>[
      _StatCardData(
        label: 'Active Borrowers',
        value: '${stats.activeBorrowers}',
        sub: '${stats.totalBorrowers} total',
        icon: Icons.people_alt_rounded,
        color: const Color(0xFF2F6FED),
      ),
      _StatCardData(
        label: 'Active Loans',
        value: '${stats.activeLoans}',
        sub: '${stats.totalLoans} total · ${stats.overdueLoans} overdue',
        icon: Icons.request_page_rounded,
        color: const Color(0xFF16A34A),
      ),
      _StatCardData(
        label: 'Outstanding Portfolio',
        value: money.format(stats.totalPortfolio),
        sub: '${money.format(stats.totalDisbursed)} disbursed total',
        icon: Icons.account_balance_wallet_rounded,
        color: const Color(0xFFF59E0B),
      ),
      _StatCardData(
        label: 'Collected Today',
        value: money.format(stats.collectedToday),
        sub: '${money.format(stats.collectedThisMonth)} this month',
        icon: Icons.payments_rounded,
        color: const Color(0xFF0EA5E9),
      ),
      _StatCardData(
        label: 'Unpaid Today',
        value: '${stats.todayDefaulters.length}',
        sub: '${money.format(stats.totalUnpaidToday)} outstanding',
        icon: Icons.report_gmailerrorred_rounded,
        color: const Color(0xFFDC2626),
      ),
      _StatCardData(
        label: 'Expenses This Month',
        value: money.format(stats.expendituresThisMonth),
        sub: 'Net: ${money.format(stats.netThisMonth)}',
        icon: Icons.trending_down_rounded,
        color: const Color(0xFFDC2626),
      ),
      _StatCardData(
        label: 'Field Officers',
        value: '${stats.activeFieldOfficers}',
        sub: '${stats.totalFieldOfficers} total',
        icon: Icons.badge_rounded,
        color: const Color(0xFF9333EA),
      ),
      _StatCardData(
        label: 'Completed Loans',
        value: '${stats.completedLoans}',
        sub: 'Fully repaid',
        icon: Icons.check_circle_rounded,
        color: const Color(0xFF14B8A6),
      ),
      _StatCardData(
        label: 'Recovery Rate',
        value: '${stats.overallRecoveryRate.toStringAsFixed(1)}%',
        sub: 'Collected vs disbursed',
        icon: Icons.insights_rounded,
        color: const Color(0xFF64748B),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = 4;
        if (constraints.maxWidth < 1200) columns = 3;
        if (constraints.maxWidth < 850) columns = 2;
        if (constraints.maxWidth < 500) columns = 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.4,
          ),
          itemBuilder: (context, i) => _StatCard(data: items[i]),
        );
      },
    );
  }
}

class _StatCardData {
  final String label;
  final String value;
  final String sub;
  final IconData icon;
  final Color color;

  _StatCardData({
    required this.label,
    required this.value,
    required this.sub,
    required this.icon,
    required this.color,
  });
}

class _StatCard extends StatelessWidget {
  final _StatCardData data;

  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _DashboardScreenState._card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(data.icon, color: data.color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.label,
                  style: const TextStyle(fontSize: 13, color: _DashboardScreenState._muted),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    data.value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _DashboardScreenState._ink,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.sub,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Reusable section card wrapper
// ---------------------------------------------------------------------------

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const _SectionCard({required this.title, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _DashboardScreenState._card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _DashboardScreenState._ink,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Loan status breakdown (simple horizontal bars, no external chart package)
// ---------------------------------------------------------------------------

class _LoanStatusBreakdown extends StatelessWidget {
  final Map<String, int> breakdown;
  final Map<String, Color> colors;

  const _LoanStatusBreakdown({required this.breakdown, required this.colors});

  @override
  Widget build(BuildContext context) {
    if (breakdown.isEmpty) {
      return const _EmptyHint(text: 'No loans recorded yet.');
    }
    final total = breakdown.values.fold<int>(0, (a, b) => a + b);
    final entries = breakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: entries.map((e) {
        final pct = total == 0 ? 0.0 : e.value / total;
        final color = colors[e.key] ?? Colors.grey;
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    e.key,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _DashboardScreenState._ink,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${e.value} (${(pct * 100).toStringAsFixed(0)}%)',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: pct,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade100,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Recent payments list
// ---------------------------------------------------------------------------

class _RecentPaymentsList extends StatelessWidget {
  final List<RecentPayment> payments;
  final NumberFormat money;
  final Map<String, Color> statusColors;

  const _RecentPaymentsList({
    required this.payments,
    required this.money,
    required this.statusColors,
  });

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) {
      return const _EmptyHint(text: 'No payments recorded yet.');
    }
    return Column(
      children: payments.map((p) {
        final color = statusColors[p.status] ?? Colors.grey;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.borrowerName,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Loan ${p.loanNumber} · ${p.paymentDate ?? '—'}',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    money.format(p.amount),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    p.status,
                    style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Borrowers who have not paid today
// ---------------------------------------------------------------------------

class _TodayDefaultersList extends StatelessWidget {
  final List<TodayDefaulter> defaulters;
  final NumberFormat money;

  const _TodayDefaultersList({required this.defaulters, required this.money});

  @override
  Widget build(BuildContext context) {
    if (defaulters.isEmpty) {
      return const _EmptyHint(text: 'Everyone with a payment due today has paid. 🎉');
    }
    return Column(
      children: [
        // Header row
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text('Borrower',
                    style: TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey.shade500)),
              ),
              Expanded(
                flex: 2,
                child: Text('Phone',
                    style: TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey.shade500)),
              ),
              Expanded(
                flex: 2,
                child: Text('Loan No.',
                    style: TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey.shade500)),
              ),
              Expanded(
                flex: 2,
                child: Text('Amount Due',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey.shade500)),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        ...defaulters.map((d) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: const Color(0xFFDC2626).withOpacity(0.1),
                          child: Text(
                            d.borrowerName.isNotEmpty ? d.borrowerName[0].toUpperCase() : '?',
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFDC2626)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(d.borrowerName,
                                  style: const TextStyle(
                                      fontSize: 13, fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis),
                              if (d.district != null)
                                Text(d.district!,
                                    style:
                                        TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(d.phone, style: const TextStyle(fontSize: 12)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(d.loanNumber, style: const TextStyle(fontSize: 12)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      money.format(d.amountDue),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFDC2626)),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Officer leaderboard
// ---------------------------------------------------------------------------

class _OfficerLeaderboard extends StatelessWidget {
  final List<OfficerPerformance> officers;
  final NumberFormat money;

  const _OfficerLeaderboard({required this.officers, required this.money});

  @override
  Widget build(BuildContext context) {
    if (officers.isEmpty) {
      return const _EmptyHint(text: 'No performance data yet.');
    }
    return Column(
      children: officers.asMap().entries.map((entry) {
        final i = entry.key;
        final o = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: _DashboardScreenState._primary.withOpacity(0.1),
                child: Text(
                  '${i + 1}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _DashboardScreenState._primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(o.fullName,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    Text(
                      '${o.activeLoans} active loans · ${o.recoveryRate.toStringAsFixed(0)}% recovery',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              Text(
                money.format(o.totalCollected),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Recent borrowers list
// ---------------------------------------------------------------------------

class _RecentBorrowersList extends StatelessWidget {
  final List<RecentBorrower> borrowers;

  const _RecentBorrowersList({required this.borrowers});

  @override
  Widget build(BuildContext context) {
    if (borrowers.isEmpty) {
      return const _EmptyHint(text: 'No borrowers onboarded yet.');
    }
    return Column(
      children: borrowers.map((b) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey.shade100,
                child: Text(
                  b.fullName.isNotEmpty ? b.fullName[0].toUpperCase() : '?',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _DashboardScreenState._ink,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(b.fullName,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    Text(
                      '${b.borrowerNumber} · ${b.phone}',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  b.status,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF16A34A),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared small widgets
// ---------------------------------------------------------------------------

class _EmptyHint extends StatelessWidget {
  final String text;

  const _EmptyHint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(text, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorState({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded, size: 40, color: Colors.redAccent),
          const SizedBox(height: 12),
          const Text('Could not load dashboard data',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}