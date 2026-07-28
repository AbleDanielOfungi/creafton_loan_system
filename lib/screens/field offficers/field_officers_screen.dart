// // import 'package:flutter/material.dart';

// // import '../../../models/field_officer.dart';
// // import '../../../services/field_officer_service.dart';

// // import 'add_field_officer_screen.dart';
// // import 'field_officer_details_screen.dart';

// // class FieldOfficersScreen extends StatefulWidget {

// //   const FieldOfficersScreen({
// //     super.key,
// //   });

// //   @override
// //   State<FieldOfficersScreen> createState() =>
// //       _FieldOfficersScreenState();

// // }

// // class _FieldOfficersScreenState
// //     extends State<FieldOfficersScreen> {

// //   final FieldOfficerService _service =
// //       FieldOfficerService();

// //   List<FieldOfficer> officers = [];

// //   bool loading = true;

// //   String searchText = "";

// //   @override
// //   void initState() {
// //     super.initState();

// //     loadOfficers();
// //   }

// //   Future<void> loadOfficers() async {

// //     setState(() {
// //       loading = true;
// //     });

// //     final result =
// //         await _service.getAllOfficers();

// //     setState(() {

// //       officers = result;

// //       loading = false;

// //     });

// //   }

// //   Future<void> searchOfficer(
// //       String value) async {

// //     setState(() {

// //       searchText = value;

// //     });

// //     if(value.isEmpty){

// //       loadOfficers();

// //       return;

// //     }

// //     final result =
// //         await _service.searchOfficer(value);

// //     setState(() {

// //       officers = result;

// //     });

// //   }

// //   @override
// //   Widget build(BuildContext context) {

// //     return Scaffold(

// //       appBar: AppBar(

// //         title: const Text(
// //           "Field Officers",
// //         ),

// //         actions: [

// //           IconButton(

// //             icon: const Icon(
// //               Icons.refresh,
// //             ),

// //             onPressed: loadOfficers,

// //           )

// //         ],

// //       ),

// //       floatingActionButton:
// //           FloatingActionButton(

// //         child: const Icon(
// //           Icons.add,
// //         ),

// //         onPressed: () async {

// //           await Navigator.push(

// //             context,

// //             MaterialPageRoute(

// //               builder: (_) =>
// //               const AddFieldOfficerScreen(),

// //             ),

// //           );

// //           loadOfficers();

// //         },

// //       ),

// //       body: Column(

// //         children: [

// //           Padding(

// //             padding:
// //             const EdgeInsets.all(12),

// //             child: TextField(

// //               decoration:
// //               const InputDecoration(

// //                 labelText:
// //                 "Search officer",

// //                 prefixIcon:
// //                 Icon(Icons.search),

// //                 border:
// //                 OutlineInputBorder(),

// //               ),

// //               onChanged:
// //               searchOfficer,

// //             ),

// //           ),

// //           Expanded(

// //             child:
// //             loading

// //             ?

// //             const Center(

// //               child:
// //               CircularProgressIndicator(),

// //             )

// //             :

// //             officers.isEmpty

// //             ?

// //             const Center(

// //               child:
// //               Text(
// //                 "No field officers found",
// //               ),

// //             )

// //             :

// //             ListView.builder(

// //               itemCount:
// //               officers.length,

// //               itemBuilder:
// //               (context,index){

// //                 final officer =
// //                 officers[index];

// //                 return Card(

// //                   margin:
// //                   const EdgeInsets
// //                       .symmetric(

// //                     horizontal:12,

// //                     vertical:6,

// //                   ),

// //                   child:
// //                   ListTile(

// //                     leading:
// //                     CircleAvatar(

// //                       child:
// //                       Text(

// //                         officer.fullName
// //                             .substring(0,1)
// //                             .toUpperCase(),

// //                       ),

// //                     ),

// //                     title:
// //                     Text(

// //                       officer.fullName,

// //                     ),

// //                     subtitle:
// //                     Column(

// //                       crossAxisAlignment:
// //                       CrossAxisAlignment.start,

// //                       children: [

// //                         Text(
// //                           officer.officerNumber,
// //                         ),

// //                         Text(
// //                           officer.phone,
// //                         ),

// //                       ],

// //                     ),

// //                     trailing:
// //                     Chip(

// //                       label:
// //                       Text(

// //                         officer.status,

// //                       ),

// //                     ),

// //                     onTap: () async {

// //                       await Navigator.push(

// //                         context,

// //                         MaterialPageRoute(

// //                           builder: (_)=>
// //                           FieldOfficerDetailsScreen(

// //                             officer:
// //                             officer,

// //                           ),

// //                         ),

// //                       );

// //                       loadOfficers();

// //                     },

// //                   ),

// //                 );

// //               },

// //             ),

// //           )

// //         ],

// //       ),

// //     );

// //   }

// // }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../providers/field_officer_provider.dart';
// import '../../../models/field_officer.dart';

// import 'add_field_officer_screen.dart';
// import 'field_officer_details_screen.dart';

// class FieldOfficersScreen extends StatefulWidget {
//   const FieldOfficersScreen({super.key});

//   @override
//   State<FieldOfficersScreen> createState() => _FieldOfficersScreenState();
// }

// class _FieldOfficersScreenState extends State<FieldOfficersScreen> {
//   final TextEditingController searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<FieldOfficerProvider>(context, listen: false).loadOfficers();
//     });
//   }

//   @override
//   void dispose() {
//     searchController.dispose();

//     super.dispose();
//   }

//   Future<void> openAddOfficer() async {
//     await Navigator.push(
//       context,

//       MaterialPageRoute(builder: (_) => const AddFieldOfficerScreen()),
//     );

//     if (!mounted) return;

//     Provider.of<FieldOfficerProvider>(context, listen: false).loadOfficers();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Field Officers"),

//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),

//             onPressed: () {
//               Provider.of<FieldOfficerProvider>(
//                 context,
//                 listen: false,
//               ).loadOfficers();
//             },
//           ),
//         ],
//       ),

//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),

//         onPressed: openAddOfficer,
//       ),

//       body: Consumer<FieldOfficerProvider>(
//         builder: (context, provider, child) {
//           if (provider.loading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           return Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(12),

//                 child: TextField(
//                   controller: searchController,

//                   decoration: const InputDecoration(
//                     labelText: "Search field officer",

//                     prefixIcon: Icon(Icons.search),

//                     border: OutlineInputBorder(),
//                   ),

//                   onChanged: (value) {
//                     if (value.isEmpty) {
//                       provider.loadOfficers();
//                     } else {
//                       provider.search(value);
//                     }
//                   },
//                 ),
//               ),

//               Expanded(
//                 child: provider.officers.isEmpty
//                     ? const Center(child: Text("No field officers found"))
//                     : RefreshIndicator(
//                         onRefresh: provider.loadOfficers,

//                         child: ListView.builder(
//                           itemCount: provider.officers.length,

//                           itemBuilder: (context, index) {
//                             final FieldOfficer officer =
//                                 provider.officers[index];

//                             return Card(
//                               margin: const EdgeInsets.symmetric(
//                                 horizontal: 12,

//                                 vertical: 6,
//                               ),

//                               child: ListTile(
//                                 leading: CircleAvatar(
//                                   child: Text(
//                                     officer.fullName
//                                         .substring(0, 1)
//                                         .toUpperCase(),
//                                   ),
//                                 ),

//                                 title: Text(
//                                   officer.fullName,

//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),

//                                 subtitle: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,

//                                   children: [
//                                     Text(officer.officerNumber),

//                                     Text(officer.phone),

//                                     Text(officer.district ?? "No district"),
//                                   ],
//                                 ),

//                                 trailing: Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 10,

//                                     vertical: 5,
//                                   ),

//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(20),

//                                     color: officer.status == "ACTIVE"
//                                         ? Colors.green.shade100
//                                         : Colors.red.shade100,
//                                   ),

//                                   child: Text(
//                                     officer.status,

//                                     style: TextStyle(
//                                       color: officer.status == "ACTIVE"
//                                           ? Colors.green
//                                           : Colors.red,

//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),

//                                 onTap: () async {
//                                   await Navigator.push(
//                                     context,

//                                     MaterialPageRoute(
//                                       builder: (_) => FieldOfficerDetailsScreen(
//                                         officer: officer,
//                                       ),
//                                     ),
//                                   );

//                                   if (!mounted) return;

//                                   provider.loadOfficers();
//                                 },
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../providers/field_officer_provider.dart';
import '../../../models/field_officer.dart';

import 'add_field_officer_screen.dart';
import 'field_officer_details_screen.dart';

class FieldOfficersScreen extends StatefulWidget {
  const FieldOfficersScreen({super.key});

  @override
  State<FieldOfficersScreen> createState() => _FieldOfficersScreenState();
}

class _FieldOfficersScreenState extends State<FieldOfficersScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FieldOfficerProvider>().loadOfficers();
    });
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  Future<void> openAddOfficer() async {
    await Navigator.push(
      context,

      MaterialPageRoute(builder: (_) => const AddFieldOfficerScreen()),
    );

    if (!mounted) return;

    context.read<FieldOfficerProvider>().loadOfficers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,

        foregroundColor: Colors.white,

        elevation: 0,

        title: const Text(
          "Field Officers",

          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),

            onPressed: () {
              context.read<FieldOfficerProvider>().loadOfficers();
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryBlue,

        foregroundColor: Colors.white,

        icon: const Icon(Icons.person_add),

        label: const Text("ADD OFFICER"),

        onPressed: openAddOfficer,
      ),

      body: Consumer<FieldOfficerProvider>(
        builder: (context, provider, _) {
          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),

              padding: const EdgeInsets.all(30),

              child: Column(
                children: [
                  _searchBox(provider),

                  const SizedBox(height: 25),

                  Expanded(
                    child: provider.loading
                        ? const Center(child: CircularProgressIndicator())
                        : provider.officers.isEmpty
                        ? _emptyState()
                        : RefreshIndicator(
                            onRefresh: provider.loadOfficers,

                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),

                              itemCount: provider.officers.length,

                              itemBuilder: (context, index) {
                                final FieldOfficer officer =
                                    provider.officers[index];

                                return _officerCard(officer);
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _searchBox(FieldOfficerProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: AppColors.border),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),

            blurRadius: 20,

            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: TextField(
        controller: searchController,

        onChanged: (value) {
          if (value.trim().isEmpty) {
            provider.loadOfficers();
          } else {
            provider.search(value);
          }
        },

        decoration: InputDecoration(
          labelText: "Search Field Officer",

          hintText: "Search by name or phone",

          prefixIcon: const Icon(Icons.search, color: AppColors.primaryBlue),

          filled: true,

          fillColor: AppColors.background,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,

            vertical: 18,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),

            borderSide: const BorderSide(color: AppColors.border),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),

            borderSide: const BorderSide(color: AppColors.border),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),

            borderSide: const BorderSide(
              color: AppColors.primaryBlue,

              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _officerCard(FieldOfficer officer) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),

      onTap: () async {
        await Navigator.push(
          context,

          MaterialPageRoute(
            builder: (_) => FieldOfficerDetailsScreen(officer: officer),
          ),
        );

        if (!mounted) return;

        context.read<FieldOfficerProvider>().loadOfficers();
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 15),

        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(20),

          border: Border.all(color: AppColors.border),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.03),

              blurRadius: 15,

              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Row(
          children: [
            CircleAvatar(
              radius: 28,

              backgroundColor: AppColors.primaryBlue.withOpacity(.1),

              child: Text(
                officer.fullName.substring(0, 1).toUpperCase(),

                style: const TextStyle(
                  fontSize: 20,

                  fontWeight: FontWeight.bold,

                  color: AppColors.primaryBlue,
                ),
              ),
            ),

            const SizedBox(width: 20),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    officer.fullName,

                    style: const TextStyle(
                      fontSize: 17,

                      fontWeight: FontWeight.bold,

                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    officer.officerNumber,

                    style: const TextStyle(color: AppColors.textSecondary),
                  ),

                  Text(
                    officer.phone,

                    style: const TextStyle(color: AppColors.textSecondary),
                  ),

                  Text(
                    officer.district ?? "No district",

                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),

            _statusBadge(officer.status),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    final active = status == "ACTIVE";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),

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

          fontSize: 12,
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(Icons.people_outline, size: 70, color: AppColors.textSecondary),

          const SizedBox(height: 15),

          const Text(
            "No field officers found",

            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
