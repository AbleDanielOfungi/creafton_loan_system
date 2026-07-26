// import 'package:flutter/material.dart';

// import '../../../models/field_officer.dart';
// import '../../../services/field_officer_service.dart';

// import 'add_field_officer_screen.dart';
// import 'field_officer_details_screen.dart';

// class FieldOfficersScreen extends StatefulWidget {

//   const FieldOfficersScreen({
//     super.key,
//   });

//   @override
//   State<FieldOfficersScreen> createState() =>
//       _FieldOfficersScreenState();

// }

// class _FieldOfficersScreenState
//     extends State<FieldOfficersScreen> {

//   final FieldOfficerService _service =
//       FieldOfficerService();

//   List<FieldOfficer> officers = [];

//   bool loading = true;

//   String searchText = "";

//   @override
//   void initState() {
//     super.initState();

//     loadOfficers();
//   }

//   Future<void> loadOfficers() async {

//     setState(() {
//       loading = true;
//     });

//     final result =
//         await _service.getAllOfficers();

//     setState(() {

//       officers = result;

//       loading = false;

//     });

//   }

//   Future<void> searchOfficer(
//       String value) async {

//     setState(() {

//       searchText = value;

//     });

//     if(value.isEmpty){

//       loadOfficers();

//       return;

//     }

//     final result =
//         await _service.searchOfficer(value);

//     setState(() {

//       officers = result;

//     });

//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(

//       appBar: AppBar(

//         title: const Text(
//           "Field Officers",
//         ),

//         actions: [

//           IconButton(

//             icon: const Icon(
//               Icons.refresh,
//             ),

//             onPressed: loadOfficers,

//           )

//         ],

//       ),

//       floatingActionButton:
//           FloatingActionButton(

//         child: const Icon(
//           Icons.add,
//         ),

//         onPressed: () async {

//           await Navigator.push(

//             context,

//             MaterialPageRoute(

//               builder: (_) =>
//               const AddFieldOfficerScreen(),

//             ),

//           );

//           loadOfficers();

//         },

//       ),

//       body: Column(

//         children: [

//           Padding(

//             padding:
//             const EdgeInsets.all(12),

//             child: TextField(

//               decoration:
//               const InputDecoration(

//                 labelText:
//                 "Search officer",

//                 prefixIcon:
//                 Icon(Icons.search),

//                 border:
//                 OutlineInputBorder(),

//               ),

//               onChanged:
//               searchOfficer,

//             ),

//           ),

//           Expanded(

//             child:
//             loading

//             ?

//             const Center(

//               child:
//               CircularProgressIndicator(),

//             )

//             :

//             officers.isEmpty

//             ?

//             const Center(

//               child:
//               Text(
//                 "No field officers found",
//               ),

//             )

//             :

//             ListView.builder(

//               itemCount:
//               officers.length,

//               itemBuilder:
//               (context,index){

//                 final officer =
//                 officers[index];

//                 return Card(

//                   margin:
//                   const EdgeInsets
//                       .symmetric(

//                     horizontal:12,

//                     vertical:6,

//                   ),

//                   child:
//                   ListTile(

//                     leading:
//                     CircleAvatar(

//                       child:
//                       Text(

//                         officer.fullName
//                             .substring(0,1)
//                             .toUpperCase(),

//                       ),

//                     ),

//                     title:
//                     Text(

//                       officer.fullName,

//                     ),

//                     subtitle:
//                     Column(

//                       crossAxisAlignment:
//                       CrossAxisAlignment.start,

//                       children: [

//                         Text(
//                           officer.officerNumber,
//                         ),

//                         Text(
//                           officer.phone,
//                         ),

//                       ],

//                     ),

//                     trailing:
//                     Chip(

//                       label:
//                       Text(

//                         officer.status,

//                       ),

//                     ),

//                     onTap: () async {

//                       await Navigator.push(

//                         context,

//                         MaterialPageRoute(

//                           builder: (_)=>
//                           FieldOfficerDetailsScreen(

//                             officer:
//                             officer,

//                           ),

//                         ),

//                       );

//                       loadOfficers();

//                     },

//                   ),

//                 );

//               },

//             ),

//           )

//         ],

//       ),

//     );

//   }

// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      Provider.of<FieldOfficerProvider>(context, listen: false).loadOfficers();
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

    Provider.of<FieldOfficerProvider>(context, listen: false).loadOfficers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Field Officers"),

        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),

            onPressed: () {
              Provider.of<FieldOfficerProvider>(
                context,
                listen: false,
              ).loadOfficers();
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),

        onPressed: openAddOfficer,
      ),

      body: Consumer<FieldOfficerProvider>(
        builder: (context, provider, child) {
          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),

                child: TextField(
                  controller: searchController,

                  decoration: const InputDecoration(
                    labelText: "Search field officer",

                    prefixIcon: Icon(Icons.search),

                    border: OutlineInputBorder(),
                  ),

                  onChanged: (value) {
                    if (value.isEmpty) {
                      provider.loadOfficers();
                    } else {
                      provider.search(value);
                    }
                  },
                ),
              ),

              Expanded(
                child: provider.officers.isEmpty
                    ? const Center(child: Text("No field officers found"))
                    : RefreshIndicator(
                        onRefresh: provider.loadOfficers,

                        child: ListView.builder(
                          itemCount: provider.officers.length,

                          itemBuilder: (context, index) {
                            final FieldOfficer officer =
                                provider.officers[index];

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,

                                vertical: 6,
                              ),

                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text(
                                    officer.fullName
                                        .substring(0, 1)
                                        .toUpperCase(),
                                  ),
                                ),

                                title: Text(
                                  officer.fullName,

                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(officer.officerNumber),

                                    Text(officer.phone),

                                    Text(officer.district ?? "No district"),
                                  ],
                                ),

                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,

                                    vertical: 5,
                                  ),

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),

                                    color: officer.status == "ACTIVE"
                                        ? Colors.green.shade100
                                        : Colors.red.shade100,
                                  ),

                                  child: Text(
                                    officer.status,

                                    style: TextStyle(
                                      color: officer.status == "ACTIVE"
                                          ? Colors.green
                                          : Colors.red,

                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                onTap: () async {
                                  await Navigator.push(
                                    context,

                                    MaterialPageRoute(
                                      builder: (_) => FieldOfficerDetailsScreen(
                                        officer: officer,
                                      ),
                                    ),
                                  );

                                  if (!mounted) return;

                                  provider.loadOfficers();
                                },
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
