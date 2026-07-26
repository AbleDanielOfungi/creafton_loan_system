// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

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



//   late TextEditingController fullNameController;

//   late TextEditingController relationshipController;

//   late TextEditingController phoneController;

//   late TextEditingController nationalIdController;

//   late TextEditingController addressController;



//   bool saving = false;







//   @override
//   void initState(){

//     super.initState();


//     final guarantor =
//         widget.guarantor;



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


//   }







//   @override
//   void dispose(){


//     fullNameController.dispose();

//     relationshipController.dispose();

//     phoneController.dispose();

//     nationalIdController.dispose();

//     addressController.dispose();



//     super.dispose();

//   }









//   Future<void> updateGuarantor() async {



//     if(!_formKey.currentState!.validate()){

//       return;

//     }



//     setState(() {

//       saving = true;

//     });





//     final updatedGuarantor =
//     widget.guarantor.copyWith(


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





//     try{



//       final success =
//       await Provider.of<GuarantorProvider>(

//         context,

//         listen:false,

//       )
//           .updateGuarantor(
//           updatedGuarantor
//       );






//       if(!mounted){

//         return;

//       }






//       if(success){


//         ScaffoldMessenger.of(context)
//             .showSnackBar(

//           const SnackBar(

//             content:
//             Text(
//               "Guarantor updated successfully",
//             ),

//           ),

//         );



//         Navigator.pop(context);



//       }



//       else{


//         ScaffoldMessenger.of(context)
//             .showSnackBar(

//           const SnackBar(

//             content:
//             Text(
//               "Failed to update guarantor",
//             ),

//           ),

//         );


//       }




//     }

//     catch(e){


//       if(!mounted)return;



//       ScaffoldMessenger.of(context)
//           .showSnackBar(

//         SnackBar(

//           content:
//           Text(
//             e.toString(),
//           ),

//         ),

//       );


//     }


//     finally{


//       if(mounted){

//         setState(() {

//           saving=false;

//         });

//       }


//     }



//   }









//   Widget inputField({

//     required String label,

//     required TextEditingController controller,

//     IconData? icon,

//     int maxLines = 1,

//     bool requiredField = false,


//   }){


//     return TextFormField(


//       controller:
//       controller,


//       maxLines:
//       maxLines,



//       decoration:
//       InputDecoration(


//         labelText:
//         label,


//         prefixIcon:
//         icon == null
//             ?
//         null
//             :
//         Icon(icon),



//         border:
//         const OutlineInputBorder(),


//       ),




//       validator:(value){


//         if(requiredField &&

//             (value == null ||
//                 value.trim().isEmpty)){


//           return
//           "$label is required";


//         }


//         return null;


//       },


//     );


//   }








//   @override
//   Widget build(BuildContext context){


//     return Scaffold(



//       appBar:
//       AppBar(

//         title:
//         const Text(
//           "Edit Guarantor",
//         ),

//       ),





//       body:
//       SingleChildScrollView(



//         padding:
//         const EdgeInsets.all(16),




//         child:
//         Form(



//           key:
//           _formKey,



//           child:
//           Column(



//             children:[



//               inputField(

//                 label:
//                 "Full Name",

//                 controller:
//                 fullNameController,

//                 icon:
//                 Icons.person,

//                 requiredField:
//                 true,

//               ),




//               const SizedBox(height:16),





//               inputField(

//                 label:
//                 "Relationship",

//                 controller:
//                 relationshipController,

//                 icon:
//                 Icons.people,

//               ),




//               const SizedBox(height:16),





//               inputField(

//                 label:
//                 "Phone Number",

//                 controller:
//                 phoneController,

//                 icon:
//                 Icons.phone,

//               ),




//               const SizedBox(height:16),





//               inputField(

//                 label:
//                 "National ID",

//                 controller:
//                 nationalIdController,

//                 icon:
//                 Icons.badge,

//               ),




//               const SizedBox(height:16),





//               inputField(

//                 label:
//                 "Address",

//                 controller:
//                 addressController,

//                 icon:
//                 Icons.location_on,

//                 maxLines:
//                 3,

//               ),




//               const SizedBox(height:30),





//               SizedBox(


//                 width:
//                 double.infinity,



//                 height:
//                 50,



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

//                   ?

//                   const SizedBox(

//                     width:22,

//                     height:22,

//                     child:
//                     CircularProgressIndicator(),

//                   )

//                   :

//                   const Text(
//                     "Update Guarantor",
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

import '../../../database/database_helper.dart';
import '../../../models/guarantor.dart';
import '../../../providers/guarantor_provider.dart';



class EditGuarantorScreen extends StatefulWidget {


  final Guarantor guarantor;


  const EditGuarantorScreen({

    super.key,

    required this.guarantor,

  });



  @override
  State<EditGuarantorScreen> createState() =>
      _EditGuarantorScreenState();

}





class _EditGuarantorScreenState
    extends State<EditGuarantorScreen> {



  final _formKey =
      GlobalKey<FormState>();


  late TextEditingController borrowerController;


  late TextEditingController fullNameController;


  late TextEditingController relationshipController;


  late TextEditingController phoneController;


  late TextEditingController nationalIdController;


  late TextEditingController addressController;



  List<Map<String,dynamic>> borrowers = [];


  int? selectedBorrowerId;



  bool saving = false;






  @override
  void initState(){

    super.initState();


    final guarantor =
        widget.guarantor;



    selectedBorrowerId =
        guarantor.borrowerId;



    borrowerController =
        TextEditingController();



    fullNameController =
        TextEditingController(
          text: guarantor.fullName,
        );



    relationshipController =
        TextEditingController(
          text: guarantor.relationship ?? "",
        );



    phoneController =
        TextEditingController(
          text: guarantor.phone ?? "",
        );



    nationalIdController =
        TextEditingController(
          text: guarantor.nationalId ?? "",
        );



    addressController =
        TextEditingController(
          text: guarantor.address ?? "",
        );


    loadCurrentBorrower();


  }








  Future<void> loadCurrentBorrower() async{


    final db =
        await DatabaseHelper.database;



    final result =
    await db.query(

      "borrowers",

      where:
      "id = ?",


      whereArgs:[
        selectedBorrowerId
      ],

    );



    if(result.isNotEmpty){


      setState((){


        borrowerController.text =
            result.first['full_name']
                .toString();


      });


    }


  }










  Future<void> searchBorrower(
      String value
      ) async{


    value =
        value.trim();



    if(value.isEmpty){


      setState((){

        borrowers=[];

      });


      return;


    }



    final db =
        await DatabaseHelper.database;




    final result =
    await db.rawQuery(

      '''
      SELECT 
      id,
      full_name,
      phone,
      borrower_number

      FROM borrowers

      WHERE LOWER(TRIM(full_name))
      LIKE ?

      ORDER BY full_name

      LIMIT 20

      ''',


      [
        "${value.toLowerCase()}%"
      ],

    );




    setState((){


      borrowers=result;


    });


  }








  void selectBorrower(
      Map<String,dynamic> borrower
      ){


    setState((){


      selectedBorrowerId =
          borrower['id'];



      borrowerController.text =
          borrower['full_name'];



      borrowers=[];



    });


  }









  Future<void> updateGuarantor() async{


    if(!_formKey.currentState!.validate()){

      return;

    }



    if(selectedBorrowerId == null){


      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content:
          Text(
              "Please select borrower"
          ),

        ),

      );


      return;

    }




    setState((){


      saving=true;


    });






    final updated =
    widget.guarantor.copyWith(



      borrowerId:
      selectedBorrowerId,



      fullName:
      fullNameController.text.trim(),



      relationship:
      relationshipController.text.trim(),



      phone:
      phoneController.text.trim(),



      nationalId:
      nationalIdController.text.trim(),



      address:
      addressController.text.trim(),



    );







    final success =
    await Provider.of<GuarantorProvider>(

      context,

      listen:false,

    )
        .updateGuarantor(
        updated
    );







    if(!mounted)return;






    setState((){


      saving=false;


    });






    if(success){


      Navigator.pop(context);


    }

    else{


      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content:
          Text(
              "Update failed"
          ),

        ),

      );


    }


  }









  Widget field(
      String label,
      TextEditingController controller,
      IconData icon,
      {
        bool required=false,
        int maxLines=1,
      }
      ){


    return TextFormField(


      controller: controller,


      maxLines:maxLines,


      validator:(value){


        if(required &&
            (value==null ||
                value.trim().isEmpty)){


          return "$label required";


        }


        return null;


      },



      decoration:
      InputDecoration(

        labelText:label,


        prefixIcon:
        Icon(icon),


        border:
        const OutlineInputBorder(),


      ),


    );


  }









  @override
  Widget build(BuildContext context){


    return Scaffold(

      appBar:
      AppBar(

        title:
        const Text(
            "Edit Guarantor"
        ),

      ),




      body:
      SingleChildScrollView(


        padding:
        const EdgeInsets.all(16),



        child:
        Form(


          key:_formKey,


          child:
          Column(


            children:[





              TextFormField(

                controller:
                borrowerController,


                decoration:
                const InputDecoration(

                  labelText:
                  "Search / Replace Borrower",

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







              const SizedBox(height:20),





              field(
                  "Guarantor Name",
                  fullNameController,
                  Icons.person,
                  required:true
              ),



              const SizedBox(height:16),



              field(
                  "Relationship",
                  relationshipController,
                  Icons.people
              ),



              const SizedBox(height:16),



              field(
                  "Phone",
                  phoneController,
                  Icons.phone
              ),



              const SizedBox(height:16),



              field(
                  "National ID",
                  nationalIdController,
                  Icons.badge
              ),



              const SizedBox(height:16),



              field(
                  "Address",
                  addressController,
                  Icons.location_on,
                  maxLines:3
              ),




              const SizedBox(height:30),





              SizedBox(

                width:
                double.infinity,


                height:50,


                child:
                ElevatedButton(


                  onPressed:
                  saving
                      ?
                  null
                      :
                  updateGuarantor,


                  child:
                  saving

                      ?

                  const CircularProgressIndicator()

                      :

                  const Text(
                      "Update Guarantor"
                  ),


                ),

              )



            ],

          ),

        ),

      ),

    );


  }


}