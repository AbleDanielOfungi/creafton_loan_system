import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/borrower_provider.dart';
import 'borrower.dart';

class EditBorrowerScreen extends StatefulWidget {
  final Borrower borrower;

  const EditBorrowerScreen({super.key, required this.borrower});

  @override
  State<EditBorrowerScreen> createState() => _EditBorrowerScreenState();
}

class _EditBorrowerScreenState extends State<EditBorrowerScreen> {
  final _formKey = GlobalKey<FormState>();

  bool saving = false;

  late TextEditingController borrowerNumberController;
  late TextEditingController fullNameController;
  late TextEditingController phoneController;
  late TextEditingController alternativePhoneController;
  late TextEditingController emailController;
  late TextEditingController nationalIdController;
  late TextEditingController districtController;
  late TextEditingController villageController;
  late TextEditingController addressController;
  late TextEditingController occupationController;
  late TextEditingController businessController;
  late TextEditingController notesController;

  // late TextEditingController nameController;
  late TextEditingController alternativePhone;
  late TextEditingController dateOfBirth;

  String gender = "Male";

  String status = "ACTIVE";

  @override
  void initState() {
    super.initState();

    borrowerNumberController = TextEditingController(
      text: widget.borrower.borrowerNumber,
    );

    fullNameController = TextEditingController(text: widget.borrower.fullName);

    phoneController = TextEditingController(text: widget.borrower.phone);

    alternativePhoneController = TextEditingController(
      text: widget.borrower.alternativePhone ?? "",
    );

    emailController = TextEditingController(text: widget.borrower.email ?? "");

    nationalIdController = TextEditingController(
      text: widget.borrower.nationalId ?? "",
    );

    districtController = TextEditingController(
      text: widget.borrower.district ?? "",
    );

    villageController = TextEditingController(
      text: widget.borrower.village ?? "",
    );

    addressController = TextEditingController(
      text: widget.borrower.address ?? "",
    );

    occupationController = TextEditingController(
      text: widget.borrower.occupation ?? "",
    );

    businessController = TextEditingController(
      text: widget.borrower.businessDetails ?? "",
    );

    notesController = TextEditingController(text: widget.borrower.notes ?? "");

    // nameController = TextEditingController(text: widget.borrower.notes ?? "");

    alternativePhone = TextEditingController(text: widget.borrower.notes ?? "");

    dateOfBirth = TextEditingController(text: widget.borrower.notes ?? "");

    gender = widget.borrower.gender ?? "Male";

    status = widget.borrower.status;
  }

  @override
  void dispose() {
    borrowerNumberController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    alternativePhoneController.dispose();
    emailController.dispose();
    nationalIdController.dispose();
    districtController.dispose();
    villageController.dispose();
    addressController.dispose();
    occupationController.dispose();
    businessController.dispose();
    notesController.dispose();

    // nameController.dispose();
    alternativePhone.dispose();
    dateOfBirth.dispose();

    super.dispose();
  }

  Future<void> saveBorrower() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      saving = true;
    });

    final borrower = Borrower(
      id: widget.borrower.id,
      borrowerNumber: borrowerNumberController.text.trim(),
      fullName: fullNameController.text.trim(),
      phone: phoneController.text.trim(),
      alternativePhone: alternativePhoneController.text.trim(),
      email: emailController.text.trim(),
      gender: gender,
      dateOfBirth: widget.borrower.dateOfBirth,
      nationalId: nationalIdController.text.trim(),
      district: districtController.text.trim(),
      village: villageController.text.trim(),
      address: addressController.text.trim(),
      occupation: occupationController.text.trim(),
      businessDetails: businessController.text.trim(),
      photo: widget.borrower.photo,
      fieldOfficerId: widget.borrower.fieldOfficerId,
      nextPaymentDate: widget.borrower.nextPaymentDate,
      notes: notesController.text.trim(),
      status: status,
      createdAt: widget.borrower.createdAt,
    );

    final provider = context.read<BorrowerProvider>();

    final success = await provider.updateBorrower(borrower);

    setState(() {
      saving = false;
    });

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Borrower updated successfully"),
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(provider.error ?? "Failed to update borrower"),
        ),
      );
    }
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }

  // Widget input({
  //   required String label,
  //   required TextEditingController controller,
  //   TextInputType keyboard = TextInputType.text,
  //   int maxLines = 1,
  //   bool requiredField = false,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 16),
  //     child: TextFormField(
  //       controller: controller,
  //       keyboardType: keyboard,
  //       maxLines: maxLines,
  //       validator: (value) {
  //         if (requiredField && (value == null || value.trim().isEmpty)) {
  //           return "$label is required";
  //         }

  //         return null;
  //       },
  //       decoration: InputDecoration(
  //         labelText: label,
  //         filled: true,
  //         fillColor: Colors.white,
  //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  //       ),
  //     ),
  //   );
  // }

  Widget input({
    required String label,
    required TextEditingController controller,
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
    bool requiredField = false,
    IconData? icon,
  }) {
    return TextFormField(
      controller: controller,

      keyboardType: keyboard,

      maxLines: maxLines,

      validator: (value) {
        if (requiredField && (value == null || value.trim().isEmpty)) {
          return "$label is required";
        }

        return null;
      },

      style: const TextStyle(
        color: AppColors.textPrimary,

        fontWeight: FontWeight.w500,
      ),

      decoration: InputDecoration(
        labelText: label,

        hintText: "Enter $label",

        labelStyle: const TextStyle(
          color: AppColors.textSecondary,

          fontSize: 14,
        ),

        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),

        prefixIcon: Icon(
          icon ?? Icons.edit_outlined,

          color: AppColors.primaryBlue,
        ),

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
      ),
    );
  }

  // Widget buildCard({required String title, required List<Widget> children}) {
  //   return Card(
  //     elevation: 3,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //     child: Padding(
  //       padding: const EdgeInsets.all(20),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [sectionTitle(title), ...children],
  //       ),
  //     ),
  //   );
  // }

  Widget buildCard({
    required String title,

    required List<Widget> children,

    IconData icon = Icons.person_outline,
  }) {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(bottom: 25),

      padding: const EdgeInsets.all(25),

      decoration: BoxDecoration(
        color: AppColors.card,

        borderRadius: BorderRadius.circular(22),

        border: Border.all(color: AppColors.border),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),

            blurRadius: 20,

            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(.1),

                  borderRadius: BorderRadius.circular(12),
                ),

                child: Icon(icon, color: AppColors.primaryBlue),
              ),

              const SizedBox(width: 12),

              Text(
                title,

                style: const TextStyle(
                  fontSize: 18,

                  fontWeight: FontWeight.bold,

                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          ...children,
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

        title: const Text("Edit Borrower"),
      ),

      body: Form(
        key: _formKey,

        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              buildCard(
                title: "Personal Information",

                children: [
                  input(
                    label: "Borrower Number",
                    controller: borrowerNumberController,
                    requiredField: true,
                  ),
                  const SizedBox(height: 15),

                  input(
                    label: "Full Name",
                    controller: fullNameController,
                    requiredField: true,
                  ),

                  DropdownButtonFormField<String>(
                    initialValue: gender,
                    decoration: const InputDecoration(labelText: "Gender"),
                    items: const [
                      DropdownMenuItem(value: "Male", child: Text("Male")),
                      DropdownMenuItem(value: "Female", child: Text("Female")),
                    ],
                    onChanged: (v) {
                      setState(() {
                        gender = v!;
                      });
                    },
                  ),

                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: occupationController,
                    label: "Occupation",
                    icon: Icons.work_outline,
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: businessController,
                    label: "Business Details",
                    icon: Icons.business_center_outlined,
                    maxLines: 3,
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: notesController,
                    label: "Notes",
                    icon: Icons.notes_outlined,
                    maxLines: 4,
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    initialValue: status,
                    decoration: InputDecoration(
                      labelText: "Status",
                      prefixIcon: const Icon(Icons.verified_user),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: "ACTIVE", child: Text("ACTIVE")),
                      DropdownMenuItem(
                        value: "INACTIVE",
                        child: Text("INACTIVE"),
                      ),
                      DropdownMenuItem(
                        value: "BLACKLISTED",
                        child: Text("BLACKLISTED"),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          status = value;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: saving ? null : _saveBorrower,
                      icon: saving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.save),
                      label: Text(
                        saving ? "Saving..." : "UPDATE BORROWER",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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

                  const SizedBox(height: 40),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //---------------------------------------------------------
  // SAVE
  //---------------------------------------------------------

  Future<void> _saveBorrower() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      saving = true;
    });

    final borrower = Borrower(
      id: widget.borrower.id,
      borrowerNumber: widget.borrower.borrowerNumber,
      fullName: fullNameController.text.trim(),
      phone: phoneController.text.trim(),
      // alternativePhone: altPhoneController.text.trim(),
      email: emailController.text.trim(),
      gender: gender,
      //dateOfBirth: dobController.text.trim(),
      nationalId: nationalIdController.text.trim(),
      district: districtController.text.trim(),
      village: villageController.text.trim(),
      address: addressController.text.trim(),
      occupation: occupationController.text.trim(),
      businessDetails: businessController.text.trim(),
      notes: notesController.text.trim(),
      status: status,
      createdAt: widget.borrower.createdAt,
      photo: widget.borrower.photo,
      fieldOfficerId: widget.borrower.fieldOfficerId,
      nextPaymentDate: widget.borrower.nextPaymentDate,
    );

    final provider = context.read<BorrowerProvider>();

    final success = await provider.updateBorrower(borrower);

    setState(() {
      saving = false;
    });

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Borrower updated successfully"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? "Failed to update borrower"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  //---------------------------------------------------------
  // TEXT FIELD
  //---------------------------------------------------------

  // Widget _buildTextField({
  //   required TextEditingController controller,
  //   required String label,
  //   required IconData icon,
  //   int maxLines = 1,
  // }) {
  //   return TextFormField(
  //     controller: controller,
  //     maxLines: maxLines,
  //     validator: (value) {
  //       if (label == "Full Name" && (value == null || value.trim().isEmpty)) {
  //         return "Full Name is required";
  //       }

  //       if (label == "Phone" && (value == null || value.trim().isEmpty)) {
  //         return "Phone Number is required";
  //       }

  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       labelText: label,
  //       prefixIcon: Icon(icon),
  //       filled: true,
  //       fillColor: Colors.grey.shade50,
  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
  //     ),
  //   );
  // }

  Widget _buildTextField({
    required TextEditingController controller,

    required String label,

    required IconData icon,

    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,

      maxLines: maxLines,

      validator: (value) {
        if (label == "Full Name" && (value == null || value.trim().isEmpty)) {
          return "Full Name is required";
        }

        if (label == "Phone" && (value == null || value.trim().isEmpty)) {
          return "Phone Number is required";
        }

        return null;
      },

      style: const TextStyle(
        color: AppColors.textPrimary,

        fontWeight: FontWeight.w500,
      ),

      decoration: InputDecoration(
        labelText: label,

        hintText: "Enter $label",

        prefixIcon: Icon(icon, color: AppColors.primaryBlue),

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
      ),
    );
  }
}
