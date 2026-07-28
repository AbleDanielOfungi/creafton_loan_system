// import 'package:creafton_financial_services/screens/borrowers/borrower.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../models/field_officer.dart';

// import '../../providers/borrower_provider.dart';
// import '../../providers/field_officer_provider.dart';

// class AddBorrowerScreen extends StatefulWidget {

//   const AddBorrowerScreen({
//     super.key,
//   });

//   @override
//   State<AddBorrowerScreen> createState() =>
//       _AddBorrowerScreenState();

// }

// class _AddBorrowerScreenState
//     extends State<AddBorrowerScreen> {

//   final nameController =
//       TextEditingController();

//   final phoneController =
//       TextEditingController();

//   final nationalIdController =
//       TextEditingController();

//   final districtController =
//       TextEditingController();

//   final occupationController =
//       TextEditingController();

//   final officerSearchController =
//       TextEditingController();

//   FieldOfficer? selectedOfficer;

//   bool showOfficerResults = false;

//   @override
//   void dispose(){

//     nameController.dispose();

//     phoneController.dispose();

//     nationalIdController.dispose();

//     districtController.dispose();

//     occupationController.dispose();

//     officerSearchController.dispose();

//     super.dispose();

//   }

//   void searchOfficer(String value){

//     if(value.trim().isEmpty){

//       setState(() {

//         showOfficerResults = false;

//       });

//       return;

//     }

//     setState(() {

//       showOfficerResults = true;

//     });

//     context
//         .read<FieldOfficerProvider>()
//         .searchFieldOfficers(value);

//   }

//   void selectOfficer(FieldOfficer officer){

//     setState(() {

//       selectedOfficer = officer;

//       officerSearchController.text =
//           officer.fullName;

//       showOfficerResults = false;

//     });

//   }

//   Future<void> save() async{

//     if(selectedOfficer == null){

//       ScaffoldMessenger.of(context)
//           .showSnackBar(

//         const SnackBar(
//           content:
//           Text(
//               "Please assign a field officer"
//           ),
//         ),

//       );

//       return;

//     }

//     final borrower = Borrower(

//       borrowerNumber:
//       "CR${DateTime.now().millisecondsSinceEpoch}",

//       fullName:
//       nameController.text.trim(),

//       phone:
//       phoneController.text.trim(),

//       nationalId:
//       nationalIdController.text.trim(),

//       district:
//       districtController.text.trim(),

//       occupation:
//       occupationController.text.trim(),

//       fieldOfficerId:
//       selectedOfficer!.id,

//       createdAt:
//       DateTime.now()
//           .toIso8601String(),

//     );

//     await context
//         .read<BorrowerProvider>()
//         .addBorrower(
//         borrower
//     );

//     if(!mounted)return;

//     Navigator.pop(context);

//   }

//   @override
//   Widget build(BuildContext context){

//     return Scaffold(

//       appBar:
//       AppBar(

//         title:
//         const Text(
//             "Register Borrower"
//         ),

//       ),

//       body:
//       SingleChildScrollView(

//         padding:
//         const EdgeInsets.all(30),

//         child:
//         Column(

//           children:[

//             TextField(

//               controller:
//               nameController,

//               decoration:
//               const InputDecoration(

//                 labelText:
//                 "Full Name",

//               ),

//             ),

//             TextField(

//               controller:
//               phoneController,

//               decoration:
//               const InputDecoration(

//                 labelText:
//                 "Phone Number",

//               ),

//             ),

//             TextField(

//               controller:
//               nationalIdController,

//               decoration:
//               const InputDecoration(

//                 labelText:
//                 "National ID",

//               ),

//             ),

//             TextField(

//               controller:
//               districtController,

//               decoration:
//               const InputDecoration(

//                 labelText:
//                 "District",

//               ),

//             ),

//             TextField(

//               controller:
//               occupationController,

//               decoration:
//               const InputDecoration(

//                 labelText:
//                 "Occupation",

//               ),

//             ),

//             const SizedBox(height:25),

//             // ===============================
//             // FIELD OFFICER SEARCH
//             // ===============================

//             TextField(

//               controller:
//               officerSearchController,

//               decoration:
//               InputDecoration(

//                 labelText:
//                 "Search Field Officer",

//                 prefixIcon:
//                 const Icon(
//                     Icons.badge
//                 ),

//                 suffixIcon:
//                 selectedOfficer != null

//                 ?

//                 IconButton(

//                   icon:
//                   const Icon(
//                       Icons.clear
//                   ),

//                   onPressed:(){

//                     setState(() {

//                       selectedOfficer=null;

//                       officerSearchController
//                           .clear();

//                     });

//                   },

//                 )

//                 :

//                 null,

//                 border:
//                 const OutlineInputBorder(),

//               ),

//               onChanged:
//               searchOfficer,

//             ),

//             const SizedBox(height:10),

//             if(selectedOfficer != null)

//               Card(

//                 child:
//                 ListTile(

//                   leading:
//                   const CircleAvatar(

//                     child:
//                     Icon(
//                         Icons.person
//                     ),

//                   ),

//                   title:
//                   Text(
//                     selectedOfficer!.fullName,
//                   ),

//                   subtitle:
//                   Text(
//                     selectedOfficer!.phone ?? "",
//                   ),

//                 ),

//               ),

//             if(showOfficerResults)

//               Consumer<FieldOfficerProvider>(

//                 builder:
//                 (
//                     context,
//                     provider,
//                     _
//                     ){

//                   if(provider.loading){

//                     return const Padding(

//                       padding:
//                       EdgeInsets.all(20),

//                       child:
//                       CircularProgressIndicator(),

//                     );

//                   }

//                   if(provider.fieldOfficers.isEmpty){

//                     return const Padding(

//                       padding:
//                       EdgeInsets.all(15),

//                       child:
//                       Text(
//                           "No field officer found"
//                       ),

//                     );

//                   }

//                   return Container(

//                     decoration:
//                     BoxDecoration(

//                       color:
//                       Colors.white,

//                       borderRadius:
//                       BorderRadius.circular(12),

//                       boxShadow:[

//                         BoxShadow(

//                           blurRadius:5,

//                           color:
//                           Colors.grey.shade300,

//                         )

//                       ],

//                     ),

//                     child:
//                     ListView.builder(

//                       shrinkWrap:true,

//                       itemCount:
//                       provider.fieldOfficers.length,

//                       itemBuilder:
//                       (context,index){

//                         final officer =
//                         provider.fieldOfficers[index];

//                         return ListTile(

//                           leading:
//                           CircleAvatar(

//                             child:
//                             Text(
//                               officer.fullName[0]
//                                   .toUpperCase(),
//                             ),

//                           ),

//                           title:
//                           Text(
//                               officer.fullName
//                           ),

//                           subtitle:
//                           Text(
//                               officer.phone ?? ""
//                           ),

//                           onTap:(){

//                             selectOfficer(
//                                 officer
//                             );

//                           },

//                         );

//                       },

//                     ),

//                   );

//                 },

//               ),

//             const SizedBox(height:30),

//             SizedBox(

//               width:
//               double.infinity,

//               child:
//               ElevatedButton(

//                 onPressed:
//                 save,

//                 child:
//                 const Text(
//                     "SAVE BORROWER"
//                 ),

//               ),

//             )

//           ],

//         ),

//       ),

//     );

//   }

// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../models/field_officer.dart';
import '../../providers/borrower_provider.dart';
import '../../providers/field_officer_provider.dart';
import 'borrower.dart';

class AddBorrowerScreen extends StatefulWidget {
  const AddBorrowerScreen({super.key});

  @override
  State<AddBorrowerScreen> createState() => _AddBorrowerScreenState();
}

class _AddBorrowerScreenState extends State<AddBorrowerScreen> {
  final nameController = TextEditingController();

  final phoneController = TextEditingController();

  final nationalIdController = TextEditingController();

  final districtController = TextEditingController();

  final occupationController = TextEditingController();

  final officerSearchController = TextEditingController();

  FieldOfficer? selectedOfficer;

  bool showOfficerResults = false;

  bool saving = false;

  @override
  void dispose() {
    nameController.dispose();

    phoneController.dispose();

    nationalIdController.dispose();

    districtController.dispose();

    occupationController.dispose();

    officerSearchController.dispose();

    super.dispose();
  }

  void searchOfficer(String value) {
    if (value.trim().isEmpty) {
      setState(() {
        showOfficerResults = false;
      });

      return;
    }

    setState(() {
      showOfficerResults = true;
    });

    context.read<FieldOfficerProvider>().searchFieldOfficers(value);
  }

  void selectOfficer(FieldOfficer officer) {
    setState(() {
      selectedOfficer = officer;

      officerSearchController.text = officer.fullName;

      showOfficerResults = false;
    });
  }

  Future<void> save() async {
    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {
      _message("Please enter borrower name and phone");

      return;
    }

    if (selectedOfficer == null) {
      _message("Please assign a field officer");

      return;
    }

    setState(() {
      saving = true;
    });

    final borrower = Borrower(
      borrowerNumber: "CR${DateTime.now().millisecondsSinceEpoch}",

      fullName: nameController.text.trim(),

      phone: phoneController.text.trim(),

      nationalId: nationalIdController.text.trim(),

      district: districtController.text.trim(),

      occupation: occupationController.text.trim(),

      fieldOfficerId: selectedOfficer!.id,

      createdAt: DateTime.now().toIso8601String(),
    );

    await context.read<BorrowerProvider>().addBorrower(borrower);

    if (!mounted) return;

    setState(() {
      saving = false;
    });

    Navigator.pop(context);
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), backgroundColor: AppColors.danger),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Register Borrower"),

        backgroundColor: AppColors.primaryBlue,

        foregroundColor: Colors.white,

        elevation: 0,
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(35),

          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),

            padding: const EdgeInsets.all(35),

            decoration: BoxDecoration(
              color: AppColors.card,

              borderRadius: BorderRadius.circular(24),

              border: Border.all(color: AppColors.border),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),

                  blurRadius: 25,

                  offset: const Offset(0, 8),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                _header(),

                const SizedBox(height: 35),

                _sectionTitle("Borrower Information"),

                _borrowerForm(),

                const SizedBox(height: 35),

                _sectionTitle("Assign Field Officer"),

                _officerSection(),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,

                  height: 55,

                  child: ElevatedButton.icon(
                    onPressed: saving ? null : save,

                    icon: saving
                        ? const SizedBox(
                            width: 20,

                            height: 20,

                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save),

                    label: Text(
                      saving ? "SAVING..." : "SAVE BORROWER",

                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,

                      foregroundColor: Colors.white,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(15),

          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(.1),

            borderRadius: BorderRadius.circular(16),
          ),

          child: const Icon(
            Icons.person_add_alt_1,

            color: AppColors.primaryBlue,

            size: 32,
          ),
        ),

        const SizedBox(width: 15),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              "New Borrower",

              style: const TextStyle(
                fontSize: 26,

                fontWeight: FontWeight.bold,

                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Capture borrower details and assign responsible field officer",

              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),

      child: Text(
        title,

        style: const TextStyle(
          fontSize: 18,

          fontWeight: FontWeight.bold,

          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _borrowerForm() {
    return GridView.count(
      shrinkWrap: true,

      physics: const NeverScrollableScrollPhysics(),

      crossAxisCount: 2,

      crossAxisSpacing: 20,

      mainAxisSpacing: 20,

      childAspectRatio: 4,

      children: [
        _input("Full Name", nameController, Icons.person),

        _input("Phone Number", phoneController, Icons.phone),

        _input("National ID", nationalIdController, Icons.badge),

        _input("District", districtController, Icons.location_on),

        _input("Occupation", occupationController, Icons.work),
      ],
    );
  }

  Widget _input(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,

      style: const TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),

      decoration: InputDecoration(
        labelText: label,

        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),

        hintText: "Enter $label",

        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),

        prefixIcon: Icon(icon, size: 21, color: AppColors.primaryBlue),

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

          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),

          borderSide: const BorderSide(color: AppColors.danger),
        ),
      ),
    );
  }

  Widget _officerSection() {
    return Column(
      children: [
        TextField(
          controller: officerSearchController,

          onChanged: searchOfficer,

          // decoration: InputDecoration(
          //   labelText: "Search Field Officer",

          //   prefixIcon: const Icon(Icons.search),

          //   suffixIcon: selectedOfficer != null
          //       ? IconButton(
          //           icon: const Icon(Icons.clear),

          //           onPressed: () {
          //             setState(() {
          //               selectedOfficer = null;

          //               officerSearchController.clear();
          //             });
          //           },
          //         )
          //       : null,
          // ),
          decoration: InputDecoration(
            labelText: "Search Field Officer",

            hintText: "Type officer name or phone",

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

        const SizedBox(height: 15),

        if (selectedOfficer != null) _selectedOfficer(),

        if (showOfficerResults) _officerResults(),
      ],
    );
  }

  Widget _selectedOfficer() {
    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withOpacity(.08),

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: AppColors.primaryGreen),
      ),

      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),

        title: Text(selectedOfficer!.fullName),

        subtitle: Text(selectedOfficer!.phone ?? ""),
      ),
    );
  }

  Widget _officerResults() {
    return Consumer<FieldOfficerProvider>(
      builder: (context, provider, _) {
        if (provider.loading) {
          return const Padding(
            padding: EdgeInsets.all(20),

            child: CircularProgressIndicator(),
          );
        }

        if (provider.fieldOfficers.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(15),

            child: Text("No field officer found"),
          );
        }

        return Container(
          margin: const EdgeInsets.only(top: 10),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(16),

            border: Border.all(color: AppColors.border),
          ),

          child: ListView.builder(
            shrinkWrap: true,

            itemCount: provider.fieldOfficers.length,

            itemBuilder: (context, index) {
              final officer = provider.fieldOfficers[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primaryBlue.withOpacity(.1),

                  child: Text(
                    officer.fullName[0].toUpperCase(),

                    style: const TextStyle(color: AppColors.primaryBlue),
                  ),
                ),

                title: Text(officer.fullName),

                subtitle: Text(officer.phone ?? ""),

                onTap: () {
                  selectOfficer(officer);
                },
              );
            },
          ),
        );
      },
    );
  }
}
