// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../models/guarantor.dart';
// import '../../providers/guarantor_provider.dart';

// import 'add_guarantor_screen.dart';



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


//       /*
//        * Since this is a GLOBAL screen,
//        * we will load all guarantors.
//        */

//       Provider.of<GuarantorProvider>(
//           context,
//           listen:false
//       )
//           .loadAllGuarantors();



//     });


//   }







//   @override
//   void dispose(){

//     searchController.dispose();

//     super.dispose();

//   }








//   Future<void> addGuarantor() async{


//     await Navigator.push(

//       context,

//       MaterialPageRoute(

//         builder:(_)=>

//         const AddGuarantorScreen(

//           borrowerId: 0,

//         ),

//       ),

//     );



//     if(!mounted)return;



//     Provider.of<GuarantorProvider>(
//         context,
//         listen:false
//     )
//         .loadAllGuarantors();


//   }








//   @override
//   Widget build(BuildContext context){


//     return Scaffold(



//       appBar: AppBar(


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
//                   context,
//                   listen:false
//               )
//                   .loadAllGuarantors();


//             },

//           )

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
//                         value
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



//                       final Guarantor guarantor =
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
//                                   .substring(0,1)
//                                   .toUpperCase(),

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
//                                 "delete",

//                                 child:
//                                 Text(
//                                   "Delete",
//                                 ),

//                               )


//                             ],





//                             onSelected:
//                             (value)async{


//                               if(value=="delete"){



//                                 await provider
//                                     .deleteGuarantor(
//                                     guarantor.id!
//                                 );



//                               }


//                             },


//                           ),





//                         ),


//                       );



//                     },


//                   ),


//                 ),



//               )



//             ],


//           );


//         },

//       ),



//     );

//   }


// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/guarantor.dart';
import '../../providers/guarantor_provider.dart';

import 'add_guarantor_screen.dart';
import 'edit_guarantor_screen.dart';



class GuarantorsScreen extends StatefulWidget {

  const GuarantorsScreen({
    super.key,
  });


  @override
  State<GuarantorsScreen> createState() =>
      _GuarantorsScreenState();

}




class _GuarantorsScreenState
    extends State<GuarantorsScreen> {


  final TextEditingController searchController =
      TextEditingController();





  @override
  void initState() {

    super.initState();


    WidgetsBinding.instance
        .addPostFrameCallback((_) {


      Provider.of<GuarantorProvider>(
        context,
        listen:false,
      )
      .loadAllGuarantors();


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

      MaterialPageRoute(

        builder: (_) =>
        const AddGuarantorScreen(),

      ),

    );



    if(!mounted) return;



    Provider.of<GuarantorProvider>(
      context,
      listen:false,
    )
    .loadAllGuarantors();


  }









  Future<void> deleteGuarantor(
      Guarantor guarantor
      ) async {


    final confirm =
    await showDialog<bool>(

      context: context,

      builder:(context){


        return AlertDialog(


          title:
          const Text(
            "Delete Guarantor",
          ),



          content:
          Text(
            "Delete ${guarantor.fullName}?",
          ),




          actions:[


            TextButton(

              onPressed:(){

                Navigator.pop(
                    context,
                    false
                );

              },

              child:
              const Text(
                "Cancel",
              ),

            ),




            ElevatedButton(

              onPressed:(){

                Navigator.pop(
                    context,
                    true
                );

              },

              child:
              const Text(
                "Delete",
              ),

            ),


          ],


        );


      },

    );




    if(confirm != true){
      return;
    }




    await Provider.of<GuarantorProvider>(
      context,
      listen:false,
    )
    .deleteGuarantor(
      guarantor.id!,
    );



  }









  @override
  Widget build(BuildContext context) {


    return Scaffold(



      appBar:
      AppBar(


        title:
        const Text(
          "Guarantors",
        ),



        actions:[


          IconButton(

            icon:
            const Icon(
              Icons.refresh,
            ),



            onPressed:(){


              Provider.of<GuarantorProvider>(
                context,
                listen:false,
              )
              .loadAllGuarantors();


            },

          ),


        ],


      ),






      floatingActionButton:
      FloatingActionButton(


        onPressed:
        addGuarantor,


        child:
        const Icon(
          Icons.add,
        ),


      ),







      body:
      Consumer<GuarantorProvider>(


        builder:
        (
            context,
            provider,
            child
            ){



          if(provider.loading){


            return const Center(

              child:
              CircularProgressIndicator(),

            );


          }







          if(provider.error != null){


            return Center(

              child:
              Text(

                provider.error!,

                style:
                const TextStyle(

                  color:
                  Colors.red,

                ),

              ),

            );


          }







          return Column(



            children:[





              Padding(

                padding:
                const EdgeInsets.all(12),


                child:
                TextField(


                  controller:
                  searchController,



                  decoration:
                  const InputDecoration(


                    labelText:
                    "Search guarantor",


                    prefixIcon:
                    Icon(
                      Icons.search,
                    ),


                    border:
                    OutlineInputBorder(),


                  ),



                  onChanged:
                  (value){


                    provider.searchGuarantors(
                      value,
                    );


                  },


                ),

              ),








              Expanded(



                child:

                provider.guarantors.isEmpty


                    ?


                const Center(

                  child:
                  Text(
                    "No guarantors found",
                  ),

                )



                    :



                RefreshIndicator(


                  onRefresh:
                  provider.loadAllGuarantors,



                  child:
                  ListView.builder(



                    itemCount:
                    provider.guarantors.length,



                    itemBuilder:
                    (context,index){



                      final guarantor =
                      provider.guarantors[index];





                      return Card(


                        margin:
                        const EdgeInsets.symmetric(

                          horizontal:12,

                          vertical:6,

                        ),




                        child:
                        ListTile(





                          leading:
                          CircleAvatar(


                            child:
                            Text(

                              guarantor.fullName
                                  .isNotEmpty

                                  ?

                              guarantor.fullName
                                  .substring(0,1)
                                  .toUpperCase()

                                  :

                              "G",

                            ),


                          ),





                          title:
                          Text(

                            guarantor.fullName,

                            style:
                            const TextStyle(

                              fontWeight:
                              FontWeight.bold,

                            ),

                          ),





                          subtitle:
                          Column(

                            crossAxisAlignment:
                            CrossAxisAlignment.start,


                            children:[



                              Text(

                                guarantor.relationship ??
                                    "Relationship not set",

                              ),



                              Text(

                                guarantor.phone ??
                                    "No phone",

                              ),




                              Text(

                                "Borrower ID: ${guarantor.borrowerId}",

                              ),



                            ],


                          ),







                          trailing:
                          PopupMenuButton(



                            itemBuilder:
                            (context)=>[




                              const PopupMenuItem(

                                value:
                                "edit",

                                child:
                                Text(
                                  "Edit",
                                ),

                              ),





                              const PopupMenuItem(

                                value:
                                "delete",

                                child:
                                Text(
                                  "Delete",
                                ),

                              ),



                            ],





                            onSelected:
                            (value) async {



                              if(value == "edit"){



                                await Navigator.push(

                                  context,

                                  MaterialPageRoute(

                                    builder:(_)=>

                                    EditGuarantorScreen(

                                      guarantor:
                                      guarantor,

                                    ),

                                  ),

                                );



                                provider
                                    .loadAllGuarantors();


                              }







                              if(value == "delete"){


                                deleteGuarantor(
                                  guarantor,
                                );


                              }



                            },


                          ),





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