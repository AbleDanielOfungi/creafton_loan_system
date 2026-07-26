// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../providers/guarantor_provider.dart';
// import '../../../models/guarantor.dart';

// import 'add_guarantor_screen.dart';
// import 'edit_guarantor_screen.dart';

// class GuarantorsScreen extends StatefulWidget {
//   final int borrowerId;

//   const GuarantorsScreen({super.key, required this.borrowerId});

//   @override
//   State<GuarantorsScreen> createState() => _GuarantorsScreenState();
// }

// class _GuarantorsScreenState extends State<GuarantorsScreen> {
//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<GuarantorProvider>(
//         context,
//         listen: false,
//       ).loadGuarantors(widget.borrowerId);
//     });
//   }

//   Future<void> addGuarantor() async {
//     await Navigator.push(
//       context,

//       MaterialPageRoute(
//         builder: (_) => AddGuarantorScreen(borrowerId: widget.borrowerId),
//       ),
//     );

//     if (!mounted) return;

//     Provider.of<GuarantorProvider>(
//       context,
//       listen: false,
//     ).loadGuarantors(widget.borrowerId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Guarantors")),

//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),

//         onPressed: addGuarantor,
//       ),

//       body: Consumer<GuarantorProvider>(
//         builder: (context, provider, _) {
//           if (provider.guarantors.isEmpty) {
//             return const Center(child: Text("No guarantors added"));
//           }

//           return ListView.builder(
//             itemCount: provider.guarantors.length,

//             itemBuilder: (context, index) {
//               final Guarantor guarantor = provider.guarantors[index];

//               return Card(
//                 margin: const EdgeInsets.all(10),

//                 child: ListTile(
//                   leading: CircleAvatar(
//                     child: Text(guarantor.fullName[0].toUpperCase()),
//                   ),

//                   title: Text(guarantor.fullName),

//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,

//                     children: [
//                       Text(guarantor.relationship ?? ""),

//                       Text(guarantor.phone ?? ""),

//                       Text(guarantor.nationalId ?? ""),
//                     ],
//                   ),

//                   trailing: PopupMenuButton(
//                     itemBuilder: (context) => [
//                       const PopupMenuItem(value: "edit", child: Text("Edit")),

//                       const PopupMenuItem(
//                         value: "delete",

//                         child: Text("Delete"),
//                       ),
//                     ],

//                     onSelected: (value) async {
//                       if (value == "edit") {
//                         await Navigator.push(
//                           context,

//                           MaterialPageRoute(
//                             builder: (_) =>
//                                 EditGuarantorScreen(guarantor: guarantor),
//                           ),
//                         );

//                         provider.loadGuarantors(widget.borrowerId);
//                       }

//                       if (value == "delete") {
//                         await provider.deleteGuarantor(guarantor.id!);

//                         provider.loadGuarantors(widget.borrowerId);
//                       }
//                     },
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
