import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screens/borrowers/borrower.dart';

import '../../models/field_officer.dart';
import '../../models/guarantor.dart';

import '../../providers/field_officer_provider.dart';
import '../../providers/guarantor_provider.dart';



class BorrowerProfileScreen extends StatefulWidget {

  final Borrower borrower;


  const BorrowerProfileScreen({
    super.key,
    required this.borrower,
  });



  @override
  State<BorrowerProfileScreen> createState() =>
      _BorrowerProfileScreenState();

}







class _BorrowerProfileScreenState
    extends State<BorrowerProfileScreen> {



  @override
  void initState(){

    super.initState();



    WidgetsBinding.instance
        .addPostFrameCallback((_){


      final officerProvider =
      Provider.of<FieldOfficerProvider>(
          context,
          listen:false
      );


      final guarantorProvider =
      Provider.of<GuarantorProvider>(
          context,
          listen:false
      );



      officerProvider.loadOfficers();



      if(widget.borrower.id != null){

        guarantorProvider.loadGuarantors(
            widget.borrower.id!
        );

      }


    });


  }







  @override
  Widget build(BuildContext context){


    return Scaffold(


      appBar: AppBar(

        title:
        Text(
          widget.borrower.fullName,
        ),

      ),




      body:
      SingleChildScrollView(


        padding:
        const EdgeInsets.all(20),



        child:
        Column(


          crossAxisAlignment:
          CrossAxisAlignment.start,



          children:[





            _sectionTitle(
                "Borrower Information"
            ),




            _infoCard([


              _item(
                "Borrower Number",
                widget.borrower.borrowerNumber,
              ),


              _item(
                "Full Name",
                widget.borrower.fullName,
              ),


              _item(
                "Phone",
                widget.borrower.phone,
              ),


              _item(
                "National ID",
                widget.borrower.nationalId ??
                    "Not provided",
              ),



              _item(
                "Gender",
                widget.borrower.gender ??
                    "Not provided",
              ),



              _item(
                "District",
                widget.borrower.district ??
                    "Not provided",
              ),



              _item(
                "Village",
                widget.borrower.village ??
                    "Not provided",
              ),



              _item(
                "Occupation",
                widget.borrower.occupation ??
                    "Not provided",
              ),



              _item(
                "Business Details",
                widget.borrower.businessDetails ??
                    "Not provided",
              ),



              _item(
                "Status",
                widget.borrower.status,
              ),


            ]),







            const SizedBox(height:25),








            _sectionTitle(
                "Assigned Field Officer"
            ),





            Consumer<FieldOfficerProvider>(


              builder:
              (
                  context,
                  provider,
                  _
                  ){



                if(provider.loading){


                  return const Center(

                    child:
                    CircularProgressIndicator(),

                  );


                }





                FieldOfficer? officer;



                try{


                  officer =
                      provider.officers.firstWhere(

                            (item)=>

                        item.id ==
                            widget.borrower.fieldOfficerId,

                      );


                }
                catch(e){

                  officer=null;

                }





                if(officer == null){


                  return _emptyCard(
                      "No field officer assigned"
                  );


                }





                return _infoCard([


                  _item(
                      "Officer Number",
                      officer.officerNumber
                  ),


                  _item(
                      "Name",
                      officer.fullName
                  ),


                  _item(
                      "Phone",
                      officer.phone
                  ),


                  _item(
                      "District",
                      officer.district ??
                          "Not provided"
                  ),


                  _item(
                      "Status",
                      officer.status
                  ),


                ]);



              },

            ),







            const SizedBox(height:25),







            _sectionTitle(
                "Guarantors"
            ),







            Consumer<GuarantorProvider>(


              builder:
              (
                  context,
                  provider,
                  _
                  ){



                if(provider.loading){


                  return const Center(

                    child:
                    CircularProgressIndicator(),

                  );


                }





                if(provider.guarantors.isEmpty){


                  return _emptyCard(
                      "No guarantors registered"
                  );


                }






                return Column(


                  children:

                  provider.guarantors
                      .map(

                          (Guarantor guarantor){


                        return Card(


                          margin:
                          const EdgeInsets.only(
                              bottom:12
                          ),



                          child:
                          ListTile(



                            leading:
                            CircleAvatar(

                              child:
                              Text(

                                guarantor.fullName
                                    .substring(0,1)
                                    .toUpperCase(),

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

                                  guarantor.nationalId ??
                                      "No National ID",

                                ),


                              ],

                            ),



                          ),

                        );


                      }

                  )
                      .toList(),


                );



              },


            ),





          ],


        ),


      ),


    );


  }









  Widget _sectionTitle(String title){


    return Padding(

      padding:
      const EdgeInsets.only(
          bottom:10
      ),


      child:
      Text(

        title,


        style:
        const TextStyle(

          fontSize:20,

          fontWeight:
          FontWeight.bold,

        ),

      ),

    );


  }








  Widget _infoCard(
      List<Widget> children
      ){


    return Card(


      elevation:2,


      shape:
      RoundedRectangleBorder(

        borderRadius:
        BorderRadius.circular(15),

      ),


      child:
      Padding(

        padding:
        const EdgeInsets.all(16),


        child:
        Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,


          children:children,

        ),


      ),


    );


  }









  Widget _item(
      String title,
      String value
      ){


    return Padding(

      padding:
      const EdgeInsets.only(
          bottom:10
      ),


      child:
      Row(

        crossAxisAlignment:
        CrossAxisAlignment.start,


        children:[


          SizedBox(

            width:140,

            child:
            Text(

              title,

              style:
              const TextStyle(

                fontWeight:
                FontWeight.bold,

              ),

            ),

          ),




          Expanded(

            child:
            Text(value),

          ),



        ],

      ),


    );


  }








  Widget _emptyCard(String message){


    return Card(


      child:
      Padding(

        padding:
        const EdgeInsets.all(20),


        child:
        Center(

          child:
          Text(message),

        ),


      ),


    );


  }



}