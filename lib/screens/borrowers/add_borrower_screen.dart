

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


//   final name =
//       TextEditingController();

//   final phone =
//       TextEditingController();

//   final nationalId =
//       TextEditingController();

//   final district =
//       TextEditingController();

//   final occupation =
//       TextEditingController();



//   final officerSearch =
//       TextEditingController();



//   FieldOfficer? selectedOfficer;



//   bool saving = false;




//   @override
//   void dispose(){

//     name.dispose();

//     phone.dispose();

//     nationalId.dispose();

//     district.dispose();

//     occupation.dispose();

//     officerSearch.dispose();


//     super.dispose();

//   }






//   void save() async {


//     if(selectedOfficer == null){

//       ScaffoldMessenger.of(context)
//           .showSnackBar(

//         const SnackBar(
//           content:
//           Text(
//             "Please assign a field officer",
//           ),
//         ),

//       );

//       return;

//     }



//     final borrower = Borrower(


//       borrowerNumber:
//       "CR${DateTime.now().millisecondsSinceEpoch}",



//       fullName:
//       name.text.trim(),



//       phone:
//       phone.text.trim(),



//       nationalId:
//       nationalId.text.trim(),



//       district:
//       district.text.trim(),



//       occupation:
//       occupation.text.trim(),



//       fieldOfficerId:
//       selectedOfficer!.id,



//       createdAt:
//       DateTime.now()
//           .toIso8601String(),


//     );




//     setState(() {

//       saving = true;

//     });



//     await context
//         .read<BorrowerProvider>()
//         .addBorrower(
//         borrower
//     );



//     if(!mounted)return;



//     setState(() {

//       saving=false;

//     });



//     Navigator.pop(context);


//   }









//   Widget officerSelector(){


//     return Consumer<FieldOfficerProvider>(

//       builder:
//       (
//           context,
//           provider,
//           _
//           ){


//         return Column(

//           crossAxisAlignment:
//           CrossAxisAlignment.start,


//           children:[



//             const Text(
//               "Assign Field Officer",
//               style:
//               TextStyle(
//                 fontWeight:
//                 FontWeight.bold,
//                 fontSize:16,
//               ),
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
//                       Icons.badge,
//                     ),

//                   ),



//                   title:
//                   Text(
//                     selectedOfficer!.fullName,
//                   ),



//                   subtitle:
//                   Text(
//                     "${selectedOfficer!.officerNumber} | ${selectedOfficer!.phone}",
//                   ),



//                   trailing:
//                   IconButton(

//                     icon:
//                     const Icon(
//                       Icons.close,
//                     ),


//                     onPressed:(){

//                       setState(() {

//                         selectedOfficer=null;

//                         officerSearch.clear();

//                       });


//                     },

//                   ),


//                 ),

//               )

//             else


//               TextField(


//                 controller:
//                 officerSearch,



//                 decoration:
//                 const InputDecoration(

//                   hintText:
//                   "Search field officer by name or number",

//                   prefixIcon:
//                   Icon(
//                     Icons.search,
//                   ),

//                   border:
//                   OutlineInputBorder(),

//                 ),



//                 onChanged:(value){


//                   if(value.trim().isNotEmpty){


//                     provider.searchFieldOfficers(
//                         value
//                     );


//                   }


//                 },


//               ),






//             if(selectedOfficer == null &&
//                 provider.fieldOfficers.isNotEmpty)


//               Container(

//                 margin:
//                 const EdgeInsets.only(
//                   top:5,
//                 ),


//                 decoration:
//                 BoxDecoration(

//                   color:
//                   Colors.white,

//                   border:
//                   Border.all(
//                     color:
//                     Colors.grey.shade300,
//                   ),

//                   borderRadius:
//                   BorderRadius.circular(8),

//                 ),



//                 child:
//                 ListView.builder(

//                   shrinkWrap:true,

//                   itemCount:
//                   provider.fieldOfficers.length,



//                   itemBuilder:
//                   (context,index){


//                     final officer =
//                     provider.fieldOfficers[index];



//                     return ListTile(


//                       title:
//                       Text(
//                         officer.fullName,
//                       ),



//                       subtitle:
//                       Text(
//                         "${officer.officerNumber} - ${officer.phone}",
//                       ),



//                       onTap:(){


//                         setState(() {

//                           selectedOfficer =
//                               officer;


//                           officerSearch.clear();


//                         });


//                       },


//                     );


//                   },


//                 ),


//               ),


//           ],


//         );


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
//           "Register Borrower",
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

//               controller:name,

//               decoration:
//               const InputDecoration(
//                 labelText:"Full Name",
//               ),

//             ),



//             TextField(

//               controller:phone,

//               decoration:
//               const InputDecoration(
//                 labelText:"Phone Number",
//               ),

//             ),




//             TextField(

//               controller:nationalId,

//               decoration:
//               const InputDecoration(
//                 labelText:"National ID",
//               ),

//             ),




//             TextField(

//               controller:district,

//               decoration:
//               const InputDecoration(
//                 labelText:"District",
//               ),

//             ),




//             TextField(

//               controller:occupation,

//               decoration:
//               const InputDecoration(
//                 labelText:"Occupation",
//               ),

//             ),



//             const SizedBox(height:25),



//             officerSelector(),




//             const SizedBox(height:30),





//             SizedBox(

//               width:
//               double.infinity,


//               child:
//               ElevatedButton(

//                 onPressed:
//                 saving
//                     ?
//                 null
//                     :
//                 save,


//                 child:
//                 saving
//                     ?
//                 const CircularProgressIndicator()
//                     :
//                 const Text(
//                   "SAVE BORROWER",
//                 ),

//               ),

//             ),



//           ],


//         ),


//       ),


//     );


//   }


// }





import 'package:creafton_financial_services/screens/borrowers/borrower.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/field_officer.dart';

import '../../providers/borrower_provider.dart';
import '../../providers/field_officer_provider.dart';


class AddBorrowerScreen extends StatefulWidget {

  const AddBorrowerScreen({
    super.key,
  });


  @override
  State<AddBorrowerScreen> createState() =>
      _AddBorrowerScreenState();

}



class _AddBorrowerScreenState
    extends State<AddBorrowerScreen> {


  final nameController =
      TextEditingController();


  final phoneController =
      TextEditingController();


  final nationalIdController =
      TextEditingController();


  final districtController =
      TextEditingController();


  final occupationController =
      TextEditingController();



  final officerSearchController =
      TextEditingController();



  FieldOfficer? selectedOfficer;



  bool showOfficerResults = false;



  @override
  void dispose(){

    nameController.dispose();

    phoneController.dispose();

    nationalIdController.dispose();

    districtController.dispose();

    occupationController.dispose();

    officerSearchController.dispose();

    super.dispose();

  }






  void searchOfficer(String value){


    if(value.trim().isEmpty){


      setState(() {

        showOfficerResults = false;

      });


      return;

    }



    setState(() {

      showOfficerResults = true;

    });



    context
        .read<FieldOfficerProvider>()
        .searchFieldOfficers(value);



  }








  void selectOfficer(FieldOfficer officer){


    setState(() {


      selectedOfficer = officer;


      officerSearchController.text =
          officer.fullName;


      showOfficerResults = false;


    });


  }









  Future<void> save() async{


    if(selectedOfficer == null){


      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
          Text(
              "Please assign a field officer"
          ),
        ),

      );


      return;

    }




    final borrower = Borrower(


      borrowerNumber:
      "CR${DateTime.now().millisecondsSinceEpoch}",



      fullName:
      nameController.text.trim(),



      phone:
      phoneController.text.trim(),



      nationalId:
      nationalIdController.text.trim(),



      district:
      districtController.text.trim(),



      occupation:
      occupationController.text.trim(),



      fieldOfficerId:
      selectedOfficer!.id,



      createdAt:
      DateTime.now()
          .toIso8601String(),


    );





    await context
        .read<BorrowerProvider>()
        .addBorrower(
        borrower
    );




    if(!mounted)return;


    Navigator.pop(context);


  }










  @override
  Widget build(BuildContext context){


    return Scaffold(


      appBar:
      AppBar(

        title:
        const Text(
            "Register Borrower"
        ),

      ),





      body:
      SingleChildScrollView(


        padding:
        const EdgeInsets.all(30),



        child:
        Column(


          children:[





            TextField(

              controller:
              nameController,

              decoration:
              const InputDecoration(

                labelText:
                "Full Name",

              ),

            ),




            TextField(

              controller:
              phoneController,

              decoration:
              const InputDecoration(

                labelText:
                "Phone Number",

              ),

            ),




            TextField(

              controller:
              nationalIdController,

              decoration:
              const InputDecoration(

                labelText:
                "National ID",

              ),

            ),





            TextField(

              controller:
              districtController,

              decoration:
              const InputDecoration(

                labelText:
                "District",

              ),

            ),





            TextField(

              controller:
              occupationController,

              decoration:
              const InputDecoration(

                labelText:
                "Occupation",

              ),

            ),





            const SizedBox(height:25),




            // ===============================
            // FIELD OFFICER SEARCH
            // ===============================


            TextField(


              controller:
              officerSearchController,


              decoration:
              InputDecoration(

                labelText:
                "Search Field Officer",


                prefixIcon:
                const Icon(
                    Icons.badge
                ),


                suffixIcon:
                selectedOfficer != null

                ?

                IconButton(

                  icon:
                  const Icon(
                      Icons.clear
                  ),


                  onPressed:(){

                    setState(() {


                      selectedOfficer=null;


                      officerSearchController
                          .clear();


                    });

                  },

                )

                :

                null,



                border:
                const OutlineInputBorder(),

              ),




              onChanged:
              searchOfficer,


            ),






            const SizedBox(height:10),





            if(selectedOfficer != null)

              Card(

                child:
                ListTile(


                  leading:
                  const CircleAvatar(

                    child:
                    Icon(
                        Icons.person
                    ),

                  ),


                  title:
                  Text(
                    selectedOfficer!.fullName,
                  ),


                  subtitle:
                  Text(
                    selectedOfficer!.phone ?? "",
                  ),


                ),

              ),







            if(showOfficerResults)

              Consumer<FieldOfficerProvider>(


                builder:
                (
                    context,
                    provider,
                    _
                    ){



                  if(provider.loading){

                    return const Padding(

                      padding:
                      EdgeInsets.all(20),

                      child:
                      CircularProgressIndicator(),

                    );

                  }



                  if(provider.fieldOfficers.isEmpty){

                    return const Padding(

                      padding:
                      EdgeInsets.all(15),

                      child:
                      Text(
                          "No field officer found"
                      ),

                    );

                  }



                  return Container(


                    decoration:
                    BoxDecoration(

                      color:
                      Colors.white,

                      borderRadius:
                      BorderRadius.circular(12),

                      boxShadow:[

                        BoxShadow(

                          blurRadius:5,

                          color:
                          Colors.grey.shade300,

                        )

                      ],

                    ),



                    child:
                    ListView.builder(


                      shrinkWrap:true,


                      itemCount:
                      provider.fieldOfficers.length,


                      itemBuilder:
                      (context,index){



                        final officer =
                        provider.fieldOfficers[index];



                        return ListTile(


                          leading:
                          CircleAvatar(

                            child:
                            Text(
                              officer.fullName[0]
                                  .toUpperCase(),
                            ),

                          ),



                          title:
                          Text(
                              officer.fullName
                          ),



                          subtitle:
                          Text(
                              officer.phone ?? ""
                          ),



                          onTap:(){

                            selectOfficer(
                                officer
                            );

                          },



                        );


                      },


                    ),


                  );



                },

              ),








            const SizedBox(height:30),





            SizedBox(

              width:
              double.infinity,


              child:
              ElevatedButton(


                onPressed:
                save,


                child:
                const Text(
                    "SAVE BORROWER"
                ),


              ),

            )



          ],


        ),


      ),


    );


  }


}