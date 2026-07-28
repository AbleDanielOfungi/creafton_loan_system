// import 'package:flutter/material.dart';

// import '../../../models/field_officer.dart';
// import '../../../services/field_officer_service.dart';

// class EditFieldOfficerScreen extends StatefulWidget {

//   final FieldOfficer officer;

//   const EditFieldOfficerScreen({

//     super.key,

//     required this.officer,

//   });

//   @override
//   State<EditFieldOfficerScreen> createState() =>
//       _EditFieldOfficerScreenState();

// }

// class _EditFieldOfficerScreenState
//     extends State<EditFieldOfficerScreen> {

//   final _formKey =
//       GlobalKey<FormState>();

//   final FieldOfficerService _service =
//       FieldOfficerService();

//   late TextEditingController nameController;

//   late TextEditingController phoneController;

//   late TextEditingController nationalIdController;

//   late TextEditingController districtController;

//   late TextEditingController addressController;

//   late String status;

//   bool updating=false;

//   @override
//   void initState(){

//     super.initState();

//     final officer =
//     widget.officer;

//     nameController =
//         TextEditingController(
//           text: officer.fullName,
//         );

//     phoneController =
//         TextEditingController(
//           text: officer.phone,
//         );

//     nationalIdController =
//         TextEditingController(
//           text: officer.nationalId ?? "",
//         );

//     districtController =
//         TextEditingController(
//           text: officer.district ?? "",
//         );

//     addressController =
//         TextEditingController(
//           text: officer.address ?? "",
//         );

//     status =
//         officer.status;

//   }

//   Future<void> updateOfficer() async{

//     if(!_formKey.currentState!.validate()){
//       return;
//     }

//     setState(() {
//       updating=true;
//     });

//     try{

//       final updated =
//       widget.officer.copyWith(

//         fullName:
//         nameController.text.trim(),

//         phone:
//         phoneController.text.trim(),

//         nationalId:
//         nationalIdController.text.trim(),

//         district:
//         districtController.text.trim(),

//         address:
//         addressController.text.trim(),

//         status:
//         status,

//       );

//       await _service.updateFieldOfficer(
//           updated
//       );

//       if(!mounted)return;

//       Navigator.pop(context);

//     }
//     finally{

//       setState(() {
//         updating=false;
//       });

//     }

//   }

//   @override
//   Widget build(BuildContext context){

//     return Scaffold(

//       appBar:
//       AppBar(

//         title:
//         const Text(
//           "Edit Field Officer",
//         ),

//       ),

//       body:
//       Form(

//         key:_formKey,

//         child:
//         ListView(

//           padding:
//           const EdgeInsets.all(16),

//           children:[

//             TextFormField(

//               controller:
//               nameController,

//               decoration:
//               const InputDecoration(

//                 labelText:
//                 "Full Name",

//                 border:
//                 OutlineInputBorder(),

//               ),

//             ),

//             const SizedBox(height:15),

//             TextFormField(

//               controller:
//               phoneController,

//               decoration:
//               const InputDecoration(

//                 labelText:
//                 "Phone",

//                 border:
//                 OutlineInputBorder(),

//               ),

//             ),

//             const SizedBox(height:15),

//             TextFormField(

//               controller:
//               nationalIdController,

//               decoration:
//               const InputDecoration(

//                 labelText:
//                 "National ID",

//                 border:
//                 OutlineInputBorder(),

//               ),

//             ),

//             const SizedBox(height:15),

//             TextFormField(

//               controller:
//               districtController,

//               decoration:
//               const InputDecoration(

//                 labelText:
//                 "District",

//                 border:
//                 OutlineInputBorder(),

//               ),

//             ),

//             const SizedBox(height:15),

//             TextFormField(

//               controller:
//               addressController,

//               maxLines:3,

//               decoration:
//               const InputDecoration(

//                 labelText:
//                 "Address",

//                 border:
//                 OutlineInputBorder(),

//               ),

//             ),

//             const SizedBox(height:15),

//             DropdownButtonFormField<String>(

//               value:
//               status,

//               items:
//               const [

//                 DropdownMenuItem(

//                   value:"ACTIVE",

//                   child:
//                   Text("ACTIVE"),

//                 ),

//                 DropdownMenuItem(

//                   value:"INACTIVE",

//                   child:
//                   Text("INACTIVE"),

//                 ),

//               ],

//               onChanged:(value){

//                 setState(() {

//                   status=value!;

//                 });

//               },

//             ),

//             const SizedBox(height:30),

//             ElevatedButton(

//               onPressed:
//               updating
//               ?
//               null
//               :
//               updateOfficer,

//               child:
//               updating

//               ?

//               const CircularProgressIndicator()

//               :

//               const Text(
//                 "Update Officer",
//               ),

//             )

//           ],

//         ),

//       ),

//     );

//   }

// }

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/field_officer.dart';
import '../../../services/field_officer_service.dart';

class EditFieldOfficerScreen extends StatefulWidget {
  final FieldOfficer officer;

  const EditFieldOfficerScreen({super.key, required this.officer});

  @override
  State<EditFieldOfficerScreen> createState() => _EditFieldOfficerScreenState();
}

class _EditFieldOfficerScreenState extends State<EditFieldOfficerScreen> {
  final _formKey = GlobalKey<FormState>();

  final FieldOfficerService _service = FieldOfficerService();

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController nationalIdController;
  late TextEditingController districtController;
  late TextEditingController addressController;

  late String status;

  bool updating = false;

  @override
  void initState() {
    super.initState();

    final officer = widget.officer;

    nameController = TextEditingController(text: officer.fullName);

    phoneController = TextEditingController(text: officer.phone);

    nationalIdController = TextEditingController(
      text: officer.nationalId ?? "",
    );

    districtController = TextEditingController(text: officer.district ?? "");

    addressController = TextEditingController(text: officer.address ?? "");

    status = officer.status;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    nationalIdController.dispose();
    districtController.dispose();
    addressController.dispose();

    super.dispose();
  }

  Future<void> updateOfficer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      updating = true;
    });

    try {
      final updated = widget.officer.copyWith(
        fullName: nameController.text.trim(),

        phone: phoneController.text.trim(),

        nationalId: nationalIdController.text.trim(),

        district: districtController.text.trim(),

        address: addressController.text.trim(),

        status: status,
      );

      await _service.updateFieldOfficer(updated);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Field officer updated successfully"),

          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),

          backgroundColor: AppColors.danger,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          updating = false;
        });
      }
    }
  }

  Widget _inputField({
    required TextEditingController controller,

    required String label,

    required IconData icon,

    TextInputType keyboard = TextInputType.text,

    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: TextFormField(
        controller: controller,

        keyboardType: keyboard,

        maxLines: maxLines,

        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "$label is required";
          }

          return null;
        },

        decoration: InputDecoration(
          labelText: label,

          prefixIcon: Icon(icon, color: AppColors.primaryBlue),

          filled: true,

          fillColor: const Color(0xFFF8FAFC),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),

            borderSide: BorderSide(color: AppColors.border),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),

            borderSide: BorderSide(color: AppColors.border),
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

  Widget _sectionCard() {
    return Container(
      padding: const EdgeInsets.all(30),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),

            blurRadius: 25,

            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            "Officer Information",

            style: TextStyle(
              fontSize: 24,

              fontWeight: FontWeight.bold,

              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 25),

          _inputField(
            controller: nameController,

            label: "Full Name",

            icon: Icons.person_outline,
          ),

          _inputField(
            controller: phoneController,

            label: "Phone Number",

            icon: Icons.phone_outlined,

            keyboard: TextInputType.phone,
          ),

          _inputField(
            controller: nationalIdController,

            label: "National ID",

            icon: Icons.badge_outlined,
          ),

          _inputField(
            controller: districtController,

            label: "District",

            icon: Icons.location_city_outlined,
          ),

          _inputField(
            controller: addressController,

            label: "Address",

            icon: Icons.home_outlined,

            maxLines: 3,
          ),

          DropdownButtonFormField<String>(
            value: status,

            decoration: InputDecoration(
              labelText: "Status",

              prefixIcon: const Icon(
                Icons.verified_user_outlined,
                color: AppColors.primaryBlue,
              ),

              filled: true,

              fillColor: const Color(0xFFF8FAFC),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),

            items: const [
              DropdownMenuItem(value: "ACTIVE", child: Text("ACTIVE")),

              DropdownMenuItem(value: "INACTIVE", child: Text("INACTIVE")),
            ],

            onChanged: (value) {
              setState(() {
                status = value!;
              });
            },
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,

            height: 52,

            child: ElevatedButton.icon(
              onPressed: updating ? null : updateOfficer,

              icon: updating
                  ? const SizedBox(
                      height: 20,

                      width: 20,

                      child: CircularProgressIndicator(
                        strokeWidth: 2,

                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save_outlined),

              label: Text(
                updating ? "Updating..." : "UPDATE OFFICER",

                style: const TextStyle(
                  fontWeight: FontWeight.bold,

                  letterSpacing: 0.5,
                ),
              ),

              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,

                foregroundColor: Colors.white,

                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
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

        title: const Text("Edit Field Officer"),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(40),

          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),

            child: Form(key: _formKey, child: _sectionCard()),
          ),
        ),
      ),
    );
  }
}
