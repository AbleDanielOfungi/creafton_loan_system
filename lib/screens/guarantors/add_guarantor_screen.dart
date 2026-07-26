import 'package:flutter/material.dart';
import 'package:creafton_financial_services/database/database_helper.dart';
import 'package:creafton_financial_services/models/guarantor.dart';
import 'package:creafton_financial_services/providers/guarantor_provider.dart';
import 'package:provider/provider.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';


class AddGuarantorScreen extends StatefulWidget {

  const AddGuarantorScreen({
    super.key,
  });


  @override
  State<AddGuarantorScreen> createState() =>
      _AddGuarantorScreenState();

}




class _AddGuarantorScreenState 
extends State<AddGuarantorScreen> {


  final borrowerController =
      TextEditingController();


  final nameController =
      TextEditingController();


  final relationshipController =
      TextEditingController();


  final phoneController =
      TextEditingController();


  final nationalIdController =
      TextEditingController();


  final addressController =
      TextEditingController();



  int? selectedBorrowerId;


  String? selectedBorrowerName;


  List<Map<String,dynamic>> borrowers = [];



  // Future<void> searchBorrower(String value) async {


  //   if(value.trim().isEmpty){

  //     setState(() {

  //       borrowers=[];

  //     });

  //     return;

  //   }



  //   final db =
  //   await DatabaseHelper.database;



  //   final result =
  //   await db.query(

  //     "borrowers",

  //     columns: [
  //       "id",
  //       "full_name",
  //       "phone",
  //       "borrower_number"
  //     ],


  //     where:
  //     "LOWER(full_name)=?",


  //     whereArgs:[
  //       value.trim().toLowerCase()
  //     ],

  //   );



  //   setState(() {

  //     borrowers=result;

  //   });


  // }



Future<void> searchBorrower(String value) async {

  value = value.trim();


  if(value.isEmpty){

    setState(() {

      borrowers = [];

    });

    return;

  }



  final db =
      await DatabaseHelper.database;



  final result = await db.rawQuery(

    '''
    SELECT 
      id,
      full_name,
      phone,
      borrower_number

    FROM borrowers

    WHERE LOWER(TRIM(full_name))
    LIKE ?

    ORDER BY full_name ASC

    LIMIT 20

    ''',

    [
      "${value.toLowerCase()}%"
    ],

  );



  setState(() {

    borrowers = result;

  });


}




  void selectBorrower(
      Map<String,dynamic> borrower
      ){


    setState(() {


      selectedBorrowerId =
          borrower['id'];


      selectedBorrowerName =
          borrower['full_name'];


      borrowerController.text =
          borrower['full_name'];


      borrowers=[];


    });


  }








  Future<void> save() async{


    if(selectedBorrowerId==null){

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
          Text(
              "Please select borrower first"
          ),
        ),

      );

      return;

    }




    final guarantor =
    Guarantor(


      borrowerId:
      selectedBorrowerId!,


      fullName:
      nameController.text.trim(),


      relationship:
      relationshipController.text.trim(),


      phone:
      phoneController.text.trim(),


      nationalId:
      nationalIdController.text.trim(),


      address:
      addressController.text.trim(),


      createdAt:
      DateTime.now()
          .toIso8601String(),

    );




    final success =
    await Provider.of<GuarantorProvider>(
        context,
        listen:false
    )
        .addGuarantor(
        guarantor
    );



    if(success && mounted){


      Navigator.pop(context);


    }


  }









  @override
  Widget build(BuildContext context){


    return Scaffold(

      appBar:
      AppBar(

        title:
        const Text(
            "Add Guarantor"
        ),

      ),



      body:
      ListView(

        padding:
        const EdgeInsets.all(16),


        children:[



          // BORROWER SEARCH

          TextField(

            controller:
            borrowerController,


            decoration:
            const InputDecoration(

              labelText:
              "Search Borrower Name",

              prefixIcon:
              Icon(
                  Icons.person_search
              ),

              border:
              OutlineInputBorder(),

            ),



            onChanged:
            searchBorrower,


          ),





          const SizedBox(height:10),





          if(borrowers.isNotEmpty)

            Card(

              child:
              Column(

                children:

                borrowers.map((borrower){

                  return ListTile(


                    title:
                    Text(
                        borrower['full_name']
                    ),


                    subtitle:
                    Text(
                        borrower['phone'] ?? ""
                    ),


                    onTap:(){

                      selectBorrower(
                          borrower
                      );

                    },


                  );


                }).toList(),

              ),

            ),






          if(selectedBorrowerName!=null)

            ListTile(

              leading:
              const Icon(
                  Icons.check_circle,
                  color: Colors.green
              ),


              title:
              Text(
                  selectedBorrowerName!
              ),


              subtitle:
              Text(
                  "Borrower ID: $selectedBorrowerId"
              ),

            ),





          const SizedBox(height:20),




          TextField(

            controller:
            nameController,


            decoration:
            const InputDecoration(

              labelText:
              "Guarantor Full Name",

              border:
              OutlineInputBorder(),

            ),

          ),





          TextField(

            controller:
            relationshipController,


            decoration:
            const InputDecoration(

              labelText:
              "Relationship",

              border:
              OutlineInputBorder(),

            ),

          ),






          TextField(

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





          TextField(

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





          TextField(

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






          const SizedBox(height:25),





          ElevatedButton(

            onPressed:
            save,


            child:
            const Text(
                "Save Guarantor"
            ),

          )


        ],

      ),

    );

  }


}