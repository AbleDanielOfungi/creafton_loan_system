import 'package:flutter/material.dart';

import '../../../models/field_officer.dart';
import '../../../services/field_officer_service.dart';



class EditFieldOfficerScreen extends StatefulWidget {


  final FieldOfficer officer;


  const EditFieldOfficerScreen({

    super.key,

    required this.officer,

  });



  @override
  State<EditFieldOfficerScreen> createState() =>
      _EditFieldOfficerScreenState();

}





class _EditFieldOfficerScreenState
    extends State<EditFieldOfficerScreen> {



  final _formKey =
      GlobalKey<FormState>();


  final FieldOfficerService _service =
      FieldOfficerService();



  late TextEditingController nameController;

  late TextEditingController phoneController;

  late TextEditingController nationalIdController;

  late TextEditingController districtController;

  late TextEditingController addressController;



  late String status;



  bool updating=false;



  @override
  void initState(){

    super.initState();


    final officer =
    widget.officer;



    nameController =
        TextEditingController(
          text: officer.fullName,
        );


    phoneController =
        TextEditingController(
          text: officer.phone,
        );


    nationalIdController =
        TextEditingController(
          text: officer.nationalId ?? "",
        );


    districtController =
        TextEditingController(
          text: officer.district ?? "",
        );


    addressController =
        TextEditingController(
          text: officer.address ?? "",
        );


    status =
        officer.status;


  }







  Future<void> updateOfficer() async{


    if(!_formKey.currentState!.validate()){
      return;
    }



    setState(() {
      updating=true;
    });



    try{


      final updated =
      widget.officer.copyWith(

        fullName:
        nameController.text.trim(),

        phone:
        phoneController.text.trim(),

        nationalId:
        nationalIdController.text.trim(),

        district:
        districtController.text.trim(),

        address:
        addressController.text.trim(),

        status:
        status,

      );



      await _service.updateFieldOfficer(
          updated
      );



      if(!mounted)return;


      Navigator.pop(context);



    }
    finally{


      setState(() {
        updating=false;
      });


    }


  }







  @override
  Widget build(BuildContext context){


    return Scaffold(

      appBar:
      AppBar(

        title:
        const Text(
          "Edit Field Officer",
        ),

      ),



      body:
      Form(

        key:_formKey,


        child:
        ListView(

          padding:
          const EdgeInsets.all(16),


          children:[



            TextFormField(

              controller:
              nameController,


              decoration:
              const InputDecoration(

                labelText:
                "Full Name",

                border:
                OutlineInputBorder(),

              ),


            ),



            const SizedBox(height:15),



            TextFormField(

              controller:
              phoneController,


              decoration:
              const InputDecoration(

                labelText:
                "Phone",

                border:
                OutlineInputBorder(),

              ),

            ),



            const SizedBox(height:15),




            TextFormField(

              controller:
              nationalIdController,


              decoration:
              const InputDecoration(

                labelText:
                "National ID",

                border:
                OutlineInputBorder(),

              ),

            ),




            const SizedBox(height:15),





            TextFormField(

              controller:
              districtController,


              decoration:
              const InputDecoration(

                labelText:
                "District",

                border:
                OutlineInputBorder(),

              ),

            ),




            const SizedBox(height:15),




            TextFormField(

              controller:
              addressController,


              maxLines:3,


              decoration:
              const InputDecoration(

                labelText:
                "Address",

                border:
                OutlineInputBorder(),

              ),

            ),




            const SizedBox(height:15),





            DropdownButtonFormField<String>(

              value:
              status,


              items:
              const [

                DropdownMenuItem(

                  value:"ACTIVE",

                  child:
                  Text("ACTIVE"),

                ),


                DropdownMenuItem(

                  value:"INACTIVE",

                  child:
                  Text("INACTIVE"),

                ),


              ],


              onChanged:(value){

                setState(() {

                  status=value!;

                });

              },

            ),





            const SizedBox(height:30),





            ElevatedButton(

              onPressed:
              updating
              ?
              null
              :
              updateOfficer,


              child:
              updating

              ?

              const CircularProgressIndicator()

              :

              const Text(
                "Update Officer",
              ),

            )

          ],

        ),

      ),

    );


  }


}