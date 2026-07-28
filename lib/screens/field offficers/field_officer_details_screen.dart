// import 'package:flutter/material.dart';

// import '../../../models/field_officer.dart';
// import '../../../services/field_officer_service.dart';

// import 'edit_field_officer_screen.dart';

// class FieldOfficerDetailsScreen extends StatefulWidget {

//   final FieldOfficer officer;

//   const FieldOfficerDetailsScreen({

//     super.key,

//     required this.officer,

//   });

//   @override
//   State<FieldOfficerDetailsScreen> createState() =>
//       _FieldOfficerDetailsScreenState();

// }

// class _FieldOfficerDetailsScreenState
//     extends State<FieldOfficerDetailsScreen>{

//   final FieldOfficerService _service =
//       FieldOfficerService();

//   Map<String,dynamic> performance={};

//   bool loading=true;

//   @override
//   void initState(){

//     super.initState();

//     loadPerformance();

//   }

//   Future<void> loadPerformance() async{

//     final result =
//     await _service.getOfficerPerformance(
//         widget.officer.id!
//     );

//     setState(() {

//       performance=result;

//       loading=false;

//     });

//   }

//   @override
//   Widget build(BuildContext context){

//     final officer =
//     widget.officer;

//     return Scaffold(

//       appBar:
//       AppBar(

//         title:
//         Text(
//           officer.fullName,
//         ),

//         actions:[

//           IconButton(

//             icon:
//             const Icon(Icons.edit),

//             onPressed:() async{

//               await Navigator.push(

//                 context,

//                 MaterialPageRoute(

//                   builder:(_)=>
//                   EditFieldOfficerScreen(

//                     officer:officer,

//                   ),

//                 ),

//               );

//               Navigator.pop(context);

//             },

//           )

//         ],

//       ),

//       body:
//       ListView(

//         padding:
//         const EdgeInsets.all(16),

//         children:[

//           CircleAvatar(

//             radius:40,

//             child:
//             Text(
//               officer.fullName[0],
//               style:
//               const TextStyle(
//                 fontSize:30,
//               ),
//             ),

//           ),

//           const SizedBox(height:20),

//           Text(
//             "Officer Number: ${officer.officerNumber}",
//           ),

//           Text(
//             "Phone: ${officer.phone}",
//           ),

//           Text(
//             "National ID: ${officer.nationalId ?? ''}",
//           ),

//           Text(
//             "District: ${officer.district ?? ''}",
//           ),

//           Text(
//             "Address: ${officer.address ?? ''}",
//           ),

//           Text(
//             "Status: ${officer.status}",
//           ),

//           const Divider(),

//           const Text(
//             "Performance",
//             style:
//             TextStyle(
//               fontSize:20,
//               fontWeight:
//               FontWeight.bold,
//             ),
//           ),

//           loading

//           ?

//           const CircularProgressIndicator()

//           :

//           Column(

//             children:[

//               Text(
//                 "Assigned Borrowers: ${performance['total_assigned'] ?? 0}",
//               ),

//               Text(
//                 "Active Loans: ${performance['active_loans'] ?? 0}",
//               ),

//               Text(
//                 "Collected: ${performance['total_collected'] ?? 0}",
//               ),

//               Text(
//                 "Recovery Rate: ${performance['recovery_rate'] ?? 0}%",
//               ),

//             ],

//           )

//         ],

//       ),

//     );

//   }

// }

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/field_officer.dart';
import '../../../services/field_officer_service.dart';

import 'edit_field_officer_screen.dart';

class FieldOfficerDetailsScreen extends StatefulWidget {
  final FieldOfficer officer;

  const FieldOfficerDetailsScreen({super.key, required this.officer});

  @override
  State<FieldOfficerDetailsScreen> createState() =>
      _FieldOfficerDetailsScreenState();
}

class _FieldOfficerDetailsScreenState extends State<FieldOfficerDetailsScreen> {
  final FieldOfficerService _service = FieldOfficerService();

  Map<String, dynamic> performance = {};

  bool loading = true;

  @override
  void initState() {
    super.initState();

    loadPerformance();
  }

  Future<void> loadPerformance() async {
    final result = await _service.getOfficerPerformance(widget.officer.id!);

    if (!mounted) return;

    setState(() {
      performance = result;

      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final officer = widget.officer;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,

        foregroundColor: Colors.white,

        elevation: 0,

        title: Text(
          officer.fullName,

          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(
            tooltip: "Edit Officer",

            icon: const Icon(Icons.edit),

            onPressed: () async {
              await Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (_) => EditFieldOfficerScreen(officer: officer),
                ),
              );

              if (!mounted) return;

              Navigator.pop(context);
            },
          ),
        ],
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(35),

          child: Container(
            constraints: const BoxConstraints(maxWidth: 1100),

            child: Column(
              children: [
                _profileHeader(officer),

                const SizedBox(height: 25),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Expanded(child: _informationCard(officer)),

                    const SizedBox(width: 25),

                    Expanded(child: _performanceCard()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileHeader(FieldOfficer officer) {
    return Container(
      padding: const EdgeInsets.all(30),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(24),

        border: Border.all(color: AppColors.border),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),

            blurRadius: 25,

            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Row(
        children: [
          CircleAvatar(
            radius: 45,

            backgroundColor: AppColors.primaryBlue.withOpacity(.1),

            child: Text(
              officer.fullName.substring(0, 1).toUpperCase(),

              style: const TextStyle(
                fontSize: 32,

                fontWeight: FontWeight.bold,

                color: AppColors.primaryBlue,
              ),
            ),
          ),

          const SizedBox(width: 25),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  officer.fullName,

                  style: const TextStyle(
                    fontSize: 26,

                    fontWeight: FontWeight.bold,

                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  officer.phone,

                  style: const TextStyle(
                    color: AppColors.textSecondary,

                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          _statusBadge(officer.status),
        ],
      ),
    );
  }

  Widget _informationCard(FieldOfficer officer) {
    return _card(
      title: "Officer Information",

      icon: Icons.badge,

      child: Column(
        children: [
          _row("Officer Number", officer.officerNumber),

          _row("Phone", officer.phone),

          _row("National ID", officer.nationalId ?? "-"),

          _row("District", officer.district ?? "-"),

          _row("Address", officer.address ?? "-"),
        ],
      ),
    );
  }

  Widget _performanceCard() {
    return _card(
      title: "Performance",

      icon: Icons.analytics,

      child: loading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(30),

                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                _statCard(
                  "Assigned Borrowers",

                  "${performance['total_assigned'] ?? 0}",

                  Icons.people,

                  AppColors.primaryBlue,
                ),

                _statCard(
                  "Active Loans",

                  "${performance['active_loans'] ?? 0}",

                  Icons.account_balance_wallet,

                  AppColors.primaryGreen,
                ),

                _statCard(
                  "Collected",

                  "UGX ${performance['total_collected'] ?? 0}",

                  Icons.payments,

                  AppColors.warning,
                ),

                _statCard(
                  "Recovery Rate",

                  "${performance['recovery_rate'] ?? 0}%",

                  Icons.trending_up,

                  AppColors.success,
                ),
              ],
            ),
    );
  }

  Widget _card({
    required String title,

    required IconData icon,

    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(25),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),

        border: Border.all(color: AppColors.border),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryBlue),

              const SizedBox(width: 10),

              Text(
                title,

                style: const TextStyle(
                  fontSize: 18,

                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          child,
        ],
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(
            title,

            style: const TextStyle(
              color: AppColors.textSecondary,

              fontWeight: FontWeight.w600,
            ),
          ),

          Flexible(
            child: Text(
              value,

              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: color.withOpacity(.08),

        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        children: [
          Icon(icon, color: color),

          const SizedBox(width: 15),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                title,

                style: const TextStyle(
                  color: AppColors.textSecondary,

                  fontSize: 12,
                ),
              ),

              Text(
                value,

                style: TextStyle(
                  color: color,

                  fontWeight: FontWeight.bold,

                  fontSize: 17,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    final active = status == "ACTIVE";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),

      decoration: BoxDecoration(
        color: active
            ? AppColors.success.withOpacity(.12)
            : AppColors.danger.withOpacity(.12),

        borderRadius: BorderRadius.circular(30),
      ),

      child: Text(
        status,

        style: TextStyle(
          color: active ? AppColors.success : AppColors.danger,

          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
