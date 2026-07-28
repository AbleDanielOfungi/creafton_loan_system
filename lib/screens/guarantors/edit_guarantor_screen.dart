// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../database/database_helper.dart';
// import '../../../models/guarantor.dart';
// import '../../../providers/guarantor_provider.dart';

// class EditGuarantorScreen extends StatefulWidget {

//   final Guarantor guarantor;

//   const EditGuarantorScreen({

//     super.key,

//     required this.guarantor,

//   });

//   @override
//   State<EditGuarantorScreen> createState() =>
//       _EditGuarantorScreenState();

// }

// class _EditGuarantorScreenState
//     extends State<EditGuarantorScreen> {

//   final _formKey =
//       GlobalKey<FormState>();

//   late TextEditingController borrowerController;

//   late TextEditingController fullNameController;

//   late TextEditingController relationshipController;

//   late TextEditingController phoneController;

//   late TextEditingController nationalIdController;

//   late TextEditingController addressController;

//   List<Map<String,dynamic>> borrowers = [];

//   int? selectedBorrowerId;

//   bool saving = false;

//   @override
//   void initState(){

//     super.initState();

//     final guarantor =
//         widget.guarantor;

//     selectedBorrowerId =
//         guarantor.borrowerId;

//     borrowerController =
//         TextEditingController();

//     fullNameController =
//         TextEditingController(
//           text: guarantor.fullName,
//         );

//     relationshipController =
//         TextEditingController(
//           text: guarantor.relationship ?? "",
//         );

//     phoneController =
//         TextEditingController(
//           text: guarantor.phone ?? "",
//         );

//     nationalIdController =
//         TextEditingController(
//           text: guarantor.nationalId ?? "",
//         );

//     addressController =
//         TextEditingController(
//           text: guarantor.address ?? "",
//         );

//     loadCurrentBorrower();

//   }

//   Future<void> loadCurrentBorrower() async{

//     final db =
//         await DatabaseHelper.database;

//     final result =
//     await db.query(

//       "borrowers",

//       where:
//       "id = ?",

//       whereArgs:[
//         selectedBorrowerId
//       ],

//     );

//     if(result.isNotEmpty){

//       setState((){

//         borrowerController.text =
//             result.first['full_name']
//                 .toString();

//       });

//     }

//   }

//   Future<void> searchBorrower(
//       String value
//       ) async{

//     value =
//         value.trim();

//     if(value.isEmpty){

//       setState((){

//         borrowers=[];

//       });

//       return;

//     }

//     final db =
//         await DatabaseHelper.database;

//     final result =
//     await db.rawQuery(

//       '''
//       SELECT
//       id,
//       full_name,
//       phone,
//       borrower_number

//       FROM borrowers

//       WHERE LOWER(TRIM(full_name))
//       LIKE ?

//       ORDER BY full_name

//       LIMIT 20

//       ''',

//       [
//         "${value.toLowerCase()}%"
//       ],

//     );

//     setState((){

//       borrowers=result;

//     });

//   }

//   void selectBorrower(
//       Map<String,dynamic> borrower
//       ){

//     setState((){

//       selectedBorrowerId =
//           borrower['id'];

//       borrowerController.text =
//           borrower['full_name'];

//       borrowers=[];

//     });

//   }

//   Future<void> updateGuarantor() async{

//     if(!_formKey.currentState!.validate()){

//       return;

//     }

//     if(selectedBorrowerId == null){

//       ScaffoldMessenger.of(context)
//           .showSnackBar(

//         const SnackBar(

//           content:
//           Text(
//               "Please select borrower"
//           ),

//         ),

//       );

//       return;

//     }

//     setState((){

//       saving=true;

//     });

//     final updated =
//     widget.guarantor.copyWith(

//       borrowerId:
//       selectedBorrowerId,

//       fullName:
//       fullNameController.text.trim(),

//       relationship:
//       relationshipController.text.trim(),

//       phone:
//       phoneController.text.trim(),

//       nationalId:
//       nationalIdController.text.trim(),

//       address:
//       addressController.text.trim(),

//     );

//     final success =
//     await Provider.of<GuarantorProvider>(

//       context,

//       listen:false,

//     )
//         .updateGuarantor(
//         updated
//     );

//     if(!mounted)return;

//     setState((){

//       saving=false;

//     });

//     if(success){

//       Navigator.pop(context);

//     }

//     else{

//       ScaffoldMessenger.of(context)
//           .showSnackBar(

//         const SnackBar(

//           content:
//           Text(
//               "Update failed"
//           ),

//         ),

//       );

//     }

//   }

//   Widget field(
//       String label,
//       TextEditingController controller,
//       IconData icon,
//       {
//         bool required=false,
//         int maxLines=1,
//       }
//       ){

//     return TextFormField(

//       controller: controller,

//       maxLines:maxLines,

//       validator:(value){

//         if(required &&
//             (value==null ||
//                 value.trim().isEmpty)){

//           return "$label required";

//         }

//         return null;

//       },

//       decoration:
//       InputDecoration(

//         labelText:label,

//         prefixIcon:
//         Icon(icon),

//         border:
//         const OutlineInputBorder(),

//       ),

//     );

//   }

//   @override
//   Widget build(BuildContext context){

//     return Scaffold(

//       appBar:
//       AppBar(

//         title:
//         const Text(
//             "Edit Guarantor"
//         ),

//       ),

//       body:
//       SingleChildScrollView(

//         padding:
//         const EdgeInsets.all(16),

//         child:
//         Form(

//           key:_formKey,

//           child:
//           Column(

//             children:[

//               TextFormField(

//                 controller:
//                 borrowerController,

//                 decoration:
//                 const InputDecoration(

//                   labelText:
//                   "Search / Replace Borrower",

//                   prefixIcon:
//                   Icon(
//                       Icons.person_search
//                   ),

//                   border:
//                   OutlineInputBorder(),

//                 ),

//                 onChanged:
//                 searchBorrower,

//               ),

//               if(borrowers.isNotEmpty)

//                 Card(

//                   child:
//                   Column(

//                     children:

//                     borrowers.map((borrower){

//                       return ListTile(

//                         title:
//                         Text(
//                             borrower['full_name']
//                         ),

//                         subtitle:
//                         Text(
//                             borrower['phone'] ?? ""
//                         ),

//                         onTap:(){

//                           selectBorrower(
//                               borrower
//                           );

//                         },

//                       );

//                     }).toList(),

//                   ),

//                 ),

//               const SizedBox(height:20),
//               field(
//                   "Guarantor Name",
//                   fullNameController,
//                   Icons.person,
//                   required:true
//               ),

//               const SizedBox(height:16),

//               field(
//                   "Relationship",
//                   relationshipController,
//                   Icons.people
//               ),

//               const SizedBox(height:16),

//               field(
//                   "Phone",
//                   phoneController,
//                   Icons.phone
//               ),

//               const SizedBox(height:16),

//               field(
//                   "National ID",
//                   nationalIdController,
//                   Icons.badge
//               ),

//               const SizedBox(height:16),

//               field(
//                   "Address",
//                   addressController,
//                   Icons.location_on,
//                   maxLines:3
//               ),

//               const SizedBox(height:30),

//               SizedBox(

//                 width:
//                 double.infinity,

//                 height:50,

//                 child:
//                 ElevatedButton(

//                   onPressed:
//                   saving
//                       ?
//                   null
//                       :
//                   updateGuarantor,

//                   child:
//                   saving

//                       ?

//                   const CircularProgressIndicator()

//                       :

//                   const Text(
//                       "Update Guarantor"
//                   ),

//                 ),

//               )

//             ],

//           ),

//         ),

//       ),

//     );

//   }

// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../database/database_helper.dart';
import '../../../models/guarantor.dart';
import '../../../providers/guarantor_provider.dart';

class EditGuarantorScreen extends StatefulWidget {
  final Guarantor guarantor;

  const EditGuarantorScreen({super.key, required this.guarantor});

  @override
  State<EditGuarantorScreen> createState() => _EditGuarantorScreenState();
}

class _EditGuarantorScreenState extends State<EditGuarantorScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController borrowerController;
  late TextEditingController fullNameController;
  late TextEditingController relationshipController;
  late TextEditingController phoneController;
  late TextEditingController nationalIdController;
  late TextEditingController addressController;

  List<Map<String, dynamic>> borrowers = [];

  int? selectedBorrowerId;

  bool saving = false;

  @override
  void initState() {
    super.initState();

    final guarantor = widget.guarantor;

    selectedBorrowerId = guarantor.borrowerId;

    borrowerController = TextEditingController();

    fullNameController = TextEditingController(text: guarantor.fullName);

    relationshipController = TextEditingController(
      text: guarantor.relationship ?? "",
    );

    phoneController = TextEditingController(text: guarantor.phone ?? "");

    nationalIdController = TextEditingController(
      text: guarantor.nationalId ?? "",
    );

    addressController = TextEditingController(text: guarantor.address ?? "");

    loadCurrentBorrower();
  }

  @override
  void dispose() {
    borrowerController.dispose();
    fullNameController.dispose();
    relationshipController.dispose();
    phoneController.dispose();
    nationalIdController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> searchBorrower(String value) async {
    value = value.trim();

    if (value.isEmpty) {
      setState(() {
        // borrowers.clear();
        borrowers = [];
      });
      return;
    }

    final db = await DatabaseHelper.database;

    final result = await db.rawQuery(
      '''
SELECT
id,
full_name,
phone,
borrower_number

FROM borrowers

WHERE
LOWER(full_name) LIKE ?
OR LOWER(phone) LIKE ?
OR LOWER(borrower_number) LIKE ?

ORDER BY full_name

LIMIT 20
''',
      [
        '%${value.toLowerCase()}%',
        '%${value.toLowerCase()}%',
        '%${value.toLowerCase()}%',
      ],
    );

    if (!mounted) return;

    setState(() {
      borrowers = result;
    });
  }

  Future<void> loadCurrentBorrower() async {
    final db = await DatabaseHelper.database;

    final result = await db.query(
      "borrowers",
      where: "id=?",
      whereArgs: [selectedBorrowerId],
    );

    if (result.isEmpty) return;

    borrowerController.text = result.first["full_name"].toString();
  }

  void selectBorrower(Map<String, dynamic> borrower) {
    setState(() {
      selectedBorrowerId = borrower["id"];

      borrowerController.text = borrower["full_name"];

      // borrowers.clear();
      borrowers = [];
    });
  }

  Future<void> updateGuarantor() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedBorrowerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a borrower."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      saving = true;
    });

    final updated = widget.guarantor.copyWith(
      borrowerId: selectedBorrowerId,
      fullName: fullNameController.text.trim(),
      relationship: relationshipController.text.trim(),
      phone: phoneController.text.trim(),
      nationalId: nationalIdController.text.trim(),
      address: addressController.text.trim(),
    );

    final success = await context.read<GuarantorProvider>().updateGuarantor(
      updated,
    );

    if (!mounted) return;

    setState(() {
      saving = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Guarantor updated successfully"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to update guarantor"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool requiredField = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Color(0xFF475569),
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: (value) {
            if (requiredField && (value == null || value.trim().isEmpty)) {
              return "$label is required";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Enter $label",

            prefixIcon: Icon(icon),

            filled: true,

            fillColor: const Color(0xFFF8FAFC),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.primaryBlue,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        title: const Text(
          "Edit Guarantor",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),

          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),

            child: Form(
              key: _formKey,

              child: Container(
                padding: const EdgeInsets.all(35),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(24),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    //----------------------------------
                    // HEADER
                    //----------------------------------
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),

                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withOpacity(.10),
                            borderRadius: BorderRadius.circular(16),
                          ),

                          child: const Icon(
                            Icons.people_alt_outlined,
                            color: AppColors.primaryBlue,
                            size: 34,
                          ),
                        ),

                        const SizedBox(width: 18),

                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              "Edit Guarantor",

                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 4),

                            Text(
                              "Update guarantor information",

                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    //----------------------------------
                    // BORROWER SEARCH
                    //----------------------------------
                    const Text(
                      "Borrower",

                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Color(0xFF475569),
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller: borrowerController,

                      decoration: InputDecoration(
                        hintText: "Search borrower...",

                        prefixIcon: const Icon(Icons.person_search),

                        filled: true,

                        fillColor: const Color(0xFFF8FAFC),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: AppColors.primaryBlue,
                            width: 1.5,
                          ),
                        ),
                      ),

                      onChanged: searchBorrower,
                    ),

                    const SizedBox(height: 12),

                    //----------------------------------
                    // SEARCH RESULTS
                    //----------------------------------
                    if (borrowers.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(16),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.06),
                              blurRadius: 15,
                            ),
                          ],
                        ),

                        child: ListView.separated(
                          shrinkWrap: true,

                          physics: const NeverScrollableScrollPhysics(),

                          itemCount: borrowers.length,

                          separatorBuilder: (_, __) =>
                              Divider(height: 1, color: Colors.grey.shade200),

                          itemBuilder: (_, index) {
                            final borrower = borrowers[index];

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.primaryBlue
                                    .withOpacity(.15),

                                child: Text(
                                  borrower["full_name"]
                                      .toString()[0]
                                      .toUpperCase(),

                                  style: const TextStyle(
                                    color: AppColors.primaryBlue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              title: Text(borrower["full_name"]),

                              subtitle: Text(borrower["phone"] ?? ""),

                              trailing: Text(
                                borrower["borrower_number"] ?? "",
                                style: const TextStyle(color: Colors.grey),
                              ),

                              onTap: () => selectBorrower(borrower),
                            );
                          },
                        ),
                      ),

                    if (selectedBorrowerId != null)
                      Container(
                        margin: const EdgeInsets.only(top: 16),

                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(.08),

                          borderRadius: BorderRadius.circular(14),
                        ),

                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Text(
                                borrowerController.text,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 30),

                    //----------------------------------
                    // DETAILS
                    //----------------------------------
                    Row(
                      children: [
                        Expanded(
                          child: buildInputField(
                            controller: fullNameController,
                            label: "Full Name",
                            icon: Icons.person_outline,
                            requiredField: true,
                          ),
                        ),

                        const SizedBox(width: 20),

                        Expanded(
                          child: buildInputField(
                            controller: relationshipController,
                            label: "Relationship",
                            icon: Icons.people_outline,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    Row(
                      children: [
                        Expanded(
                          child: buildInputField(
                            controller: phoneController,
                            label: "Phone Number",
                            icon: Icons.phone_outlined,
                          ),
                        ),

                        const SizedBox(width: 20),

                        Expanded(
                          child: buildInputField(
                            controller: nationalIdController,
                            label: "National ID",
                            icon: Icons.badge_outlined,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    buildInputField(
                      controller: addressController,
                      label: "Address",
                      icon: Icons.home_outlined,
                      maxLines: 3,
                    ),

                    const SizedBox(height: 35),

                    //----------------------------------
                    // SAVE BUTTON
                    //----------------------------------
                    SizedBox(
                      width: double.infinity,
                      height: 54,

                      child: ElevatedButton.icon(
                        icon: saving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.save),

                        label: Text(
                          saving ? "Updating..." : "UPDATE GUARANTOR",

                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .8,
                          ),
                        ),

                        style: ElevatedButton.styleFrom(
                          elevation: 0,

                          backgroundColor: AppColors.primaryBlue,

                          foregroundColor: Colors.white,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),

                        onPressed: saving ? null : updateGuarantor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
