// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../models/guarantor.dart';
// import '../../providers/guarantor_provider.dart';

// import 'add_guarantor_screen.dart';
// import 'edit_guarantor_screen.dart';

// class GuarantorsScreen extends StatefulWidget {

//   const GuarantorsScreen({
//     super.key,
//   });

//   @override
//   State<GuarantorsScreen> createState() =>
//       _GuarantorsScreenState();

// }

// class _GuarantorsScreenState
//     extends State<GuarantorsScreen> {

//   final TextEditingController searchController =
//       TextEditingController();

//   @override
//   void initState() {

//     super.initState();

//     WidgetsBinding.instance
//         .addPostFrameCallback((_) {

//       Provider.of<GuarantorProvider>(
//         context,
//         listen:false,
//       )
//       .loadAllGuarantors();

//     });

//   }

//   @override
//   void dispose() {

//     searchController.dispose();

//     super.dispose();

//   }

//   Future<void> addGuarantor() async {

//     await Navigator.push(

//       context,

//       MaterialPageRoute(

//         builder: (_) =>
//         const AddGuarantorScreen(),

//       ),

//     );

//     if(!mounted) return;

//     Provider.of<GuarantorProvider>(
//       context,
//       listen:false,
//     )
//     .loadAllGuarantors();

//   }

//   Future<void> deleteGuarantor(
//       Guarantor guarantor
//       ) async {

//     final confirm =
//     await showDialog<bool>(

//       context: context,

//       builder:(context){

//         return AlertDialog(

//           title:
//           const Text(
//             "Delete Guarantor",
//           ),

//           content:
//           Text(
//             "Delete ${guarantor.fullName}?",
//           ),

//           actions:[

//             TextButton(

//               onPressed:(){

//                 Navigator.pop(
//                     context,
//                     false
//                 );

//               },

//               child:
//               const Text(
//                 "Cancel",
//               ),

//             ),

//             ElevatedButton(

//               onPressed:(){

//                 Navigator.pop(
//                     context,
//                     true
//                 );

//               },

//               child:
//               const Text(
//                 "Delete",
//               ),

//             ),

//           ],

//         );

//       },

//     );

//     if(confirm != true){
//       return;
//     }

//     await Provider.of<GuarantorProvider>(
//       context,
//       listen:false,
//     )
//     .deleteGuarantor(
//       guarantor.id!,
//     );

//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(

//       appBar:
//       AppBar(

//         title:
//         const Text(
//           "Guarantors",
//         ),

//         actions:[

//           IconButton(

//             icon:
//             const Icon(
//               Icons.refresh,
//             ),

//             onPressed:(){

//               Provider.of<GuarantorProvider>(
//                 context,
//                 listen:false,
//               )
//               .loadAllGuarantors();

//             },

//           ),

//         ],

//       ),

//       floatingActionButton:
//       FloatingActionButton(

//         onPressed:
//         addGuarantor,

//         child:
//         const Icon(
//           Icons.add,
//         ),

//       ),

//       body:
//       Consumer<GuarantorProvider>(

//         builder:
//         (
//             context,
//             provider,
//             child
//             ){

//           if(provider.loading){

//             return const Center(

//               child:
//               CircularProgressIndicator(),

//             );

//           }

//           if(provider.error != null){

//             return Center(

//               child:
//               Text(

//                 provider.error!,

//                 style:
//                 const TextStyle(

//                   color:
//                   Colors.red,

//                 ),

//               ),

//             );

//           }

//           return Column(

//             children:[

//               Padding(

//                 padding:
//                 const EdgeInsets.all(12),

//                 child:
//                 TextField(

//                   controller:
//                   searchController,

//                   decoration:
//                   const InputDecoration(

//                     labelText:
//                     "Search guarantor",

//                     prefixIcon:
//                     Icon(
//                       Icons.search,
//                     ),

//                     border:
//                     OutlineInputBorder(),

//                   ),

//                   onChanged:
//                   (value){

//                     provider.searchGuarantors(
//                       value,
//                     );

//                   },

//                 ),

//               ),

//               Expanded(

//                 child:

//                 provider.guarantors.isEmpty

//                     ?

//                 const Center(

//                   child:
//                   Text(
//                     "No guarantors found",
//                   ),

//                 )

//                     :

//                 RefreshIndicator(

//                   onRefresh:
//                   provider.loadAllGuarantors,

//                   child:
//                   ListView.builder(

//                     itemCount:
//                     provider.guarantors.length,

//                     itemBuilder:
//                     (context,index){

//                       final guarantor =
//                       provider.guarantors[index];

//                       return Card(

//                         margin:
//                         const EdgeInsets.symmetric(

//                           horizontal:12,

//                           vertical:6,

//                         ),

//                         child:
//                         ListTile(

//                           leading:
//                           CircleAvatar(

//                             child:
//                             Text(

//                               guarantor.fullName
//                                   .isNotEmpty

//                                   ?

//                               guarantor.fullName
//                                   .substring(0,1)
//                                   .toUpperCase()

//                                   :

//                               "G",

//                             ),

//                           ),

//                           title:
//                           Text(

//                             guarantor.fullName,

//                             style:
//                             const TextStyle(

//                               fontWeight:
//                               FontWeight.bold,

//                             ),

//                           ),

//                           subtitle:
//                           Column(

//                             crossAxisAlignment:
//                             CrossAxisAlignment.start,

//                             children:[

//                               Text(

//                                 guarantor.relationship ??
//                                     "Relationship not set",

//                               ),

//                               Text(

//                                 guarantor.phone ??
//                                     "No phone",

//                               ),

//                               Text(

//                                 "Borrower ID: ${guarantor.borrowerId}",

//                               ),

//                             ],

//                           ),

//                           trailing:
//                           PopupMenuButton(

//                             itemBuilder:
//                             (context)=>[

//                               const PopupMenuItem(

//                                 value:
//                                 "edit",

//                                 child:
//                                 Text(
//                                   "Edit",
//                                 ),

//                               ),

//                               const PopupMenuItem(

//                                 value:
//                                 "delete",

//                                 child:
//                                 Text(
//                                   "Delete",
//                                 ),

//                               ),

//                             ],

//                             onSelected:
//                             (value) async {

//                               if(value == "edit"){

//                                 await Navigator.push(

//                                   context,

//                                   MaterialPageRoute(

//                                     builder:(_)=>

//                                     EditGuarantorScreen(

//                                       guarantor:
//                                       guarantor,

//                                     ),

//                                   ),

//                                 );

//                                 provider
//                                     .loadAllGuarantors();

//                               }

//                               if(value == "delete"){

//                                 deleteGuarantor(
//                                   guarantor,
//                                 );

//                               }

//                             },

//                           ),

//                         ),

//                       );

//                     },

//                   ),

//                 ),

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

import '../../core/theme/app_colors.dart';
import '../../models/guarantor.dart';
import '../../providers/guarantor_provider.dart';

import 'add_guarantor_screen.dart';
import 'edit_guarantor_screen.dart';

class GuarantorsScreen extends StatefulWidget {
  const GuarantorsScreen({super.key});

  @override
  State<GuarantorsScreen> createState() => _GuarantorsScreenState();
}

class _GuarantorsScreenState extends State<GuarantorsScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GuarantorProvider>().loadAllGuarantors();
    });
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  Future<void> addGuarantor() async {
    await Navigator.push(
      context,

      MaterialPageRoute(builder: (_) => const AddGuarantorScreen()),
    );

    if (!mounted) return;

    context.read<GuarantorProvider>().loadAllGuarantors();
  }

  Future<void> deleteGuarantor(Guarantor guarantor) async {
    final confirm = await showDialog<bool>(
      context: context,

      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),

          title: const Text("Delete Guarantor"),

          content: Text(
            "Are you sure you want to delete ${guarantor.fullName}?",
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },

              child: const Text("Cancel"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,

                foregroundColor: Colors.white,
              ),

              onPressed: () {
                Navigator.pop(context, true);
              },

              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    await context.read<GuarantorProvider>().deleteGuarantor(guarantor.id!);
  }

  Widget searchBox(GuarantorProvider provider) {
    return TextField(
      controller: searchController,

      onChanged: (value) {
        provider.searchGuarantors(value);
      },

      decoration: InputDecoration(
        hintText: "Search guarantor",

        prefixIcon: const Icon(Icons.search, color: AppColors.primaryBlue),

        filled: true,

        fillColor: const Color(0xFFF8FAFC),

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

          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
      ),
    );
  }

  Widget guarantorCard(Guarantor guarantor, GuarantorProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),

            blurRadius: 15,

            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,

          vertical: 10,
        ),

        leading: CircleAvatar(
          radius: 26,

          backgroundColor: AppColors.primaryBlue.withOpacity(.12),

          child: Text(
            guarantor.fullName.isNotEmpty
                ? guarantor.fullName.substring(0, 1).toUpperCase()
                : "G",

            style: const TextStyle(
              color: AppColors.primaryBlue,

              fontWeight: FontWeight.bold,

              fontSize: 18,
            ),
          ),
        ),

        title: Text(
          guarantor.fullName,

          style: const TextStyle(
            fontWeight: FontWeight.bold,

            fontSize: 16,

            color: AppColors.textPrimary,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(guarantor.relationship ?? "Relationship not set"),

              Text(guarantor.phone ?? "No phone"),

              Text("Borrower ID: ${guarantor.borrowerId}"),
            ],
          ),
        ),

        trailing: PopupMenuButton<String>(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          itemBuilder: (context) => [
            const PopupMenuItem(
              value: "edit",

              child: Row(
                children: [
                  Icon(Icons.edit, size: 18),

                  SizedBox(width: 8),

                  Text("Edit"),
                ],
              ),
            ),

            const PopupMenuItem(
              value: "delete",

              child: Row(
                children: [
                  Icon(Icons.delete, size: 18),

                  SizedBox(width: 8),

                  Text("Delete"),
                ],
              ),
            ),
          ],

          onSelected: (value) async {
            if (value == "edit") {
              await Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (_) => EditGuarantorScreen(guarantor: guarantor),
                ),
              );

              provider.loadAllGuarantors();
            }

            if (value == "delete") {
              deleteGuarantor(guarantor);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,

        foregroundColor: Colors.white,

        elevation: 0,

        title: const Text("Guarantors"),

        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),

            onPressed: () {
              context.read<GuarantorProvider>().loadAllGuarantors();
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryBlue,

        foregroundColor: Colors.white,

        onPressed: addGuarantor,

        child: const Icon(Icons.add),
      ),

      body: Consumer<GuarantorProvider>(
        builder: (context, provider, _) {
          if (provider.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Text(
                provider.error!,

                style: const TextStyle(color: AppColors.danger),
              ),
            );
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),

              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25),

                    child: searchBox(provider),
                  ),

                  Expanded(
                    child: provider.guarantors.isEmpty
                        ? const Center(child: Text("No guarantors found"))
                        : RefreshIndicator(
                            onRefresh: provider.loadAllGuarantors,

                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                              ),

                              itemCount: provider.guarantors.length,

                              itemBuilder: (context, index) {
                                return guarantorCard(
                                  provider.guarantors[index],

                                  provider,
                                );
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
}
