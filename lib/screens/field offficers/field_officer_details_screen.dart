import 'package:flutter/material.dart';

import '../../../models/field_officer.dart';
import '../../../services/field_officer_service.dart';

import 'edit_field_officer_screen.dart';



class FieldOfficerDetailsScreen extends StatefulWidget {


  final FieldOfficer officer;


  const FieldOfficerDetailsScreen({

    super.key,

    required this.officer,

  });



  @override
  State<FieldOfficerDetailsScreen> createState() =>
      _FieldOfficerDetailsScreenState();

}





class _FieldOfficerDetailsScreenState
    extends State<FieldOfficerDetailsScreen>{



  final FieldOfficerService _service =
      FieldOfficerService();



  Map<String,dynamic> performance={};



  bool loading=true;




  @override
  void initState(){

    super.initState();

    loadPerformance();

  }






  Future<void> loadPerformance() async{


    final result =
    await _service.getOfficerPerformance(
        widget.officer.id!
    );


    setState(() {

      performance=result;

      loading=false;

    });


  }







  @override
  Widget build(BuildContext context){


    final officer =
    widget.officer;



    return Scaffold(


      appBar:
      AppBar(

        title:
        Text(
          officer.fullName,
        ),



        actions:[


          IconButton(

            icon:
            const Icon(Icons.edit),


            onPressed:() async{


              await Navigator.push(

                context,

                MaterialPageRoute(

                  builder:(_)=>
                  EditFieldOfficerScreen(

                    officer:officer,

                  ),

                ),

              );

              Navigator.pop(context);

            },


          )


        ],

      ),




      body:
      ListView(

        padding:
        const EdgeInsets.all(16),


        children:[


          CircleAvatar(

            radius:40,

            child:
            Text(
              officer.fullName[0],
              style:
              const TextStyle(
                fontSize:30,
              ),
            ),

          ),



          const SizedBox(height:20),



          Text(
            "Officer Number: ${officer.officerNumber}",
          ),


          Text(
            "Phone: ${officer.phone}",
          ),


          Text(
            "National ID: ${officer.nationalId ?? ''}",
          ),


          Text(
            "District: ${officer.district ?? ''}",
          ),


          Text(
            "Address: ${officer.address ?? ''}",
          ),


          Text(
            "Status: ${officer.status}",
          ),



          const Divider(),




          const Text(
            "Performance",
            style:
            TextStyle(
              fontSize:20,
              fontWeight:
              FontWeight.bold,
            ),
          ),




          loading

          ?

          const CircularProgressIndicator()

          :

          Column(

            children:[


              Text(
                "Assigned Borrowers: ${performance['total_assigned'] ?? 0}",
              ),


              Text(
                "Active Loans: ${performance['active_loans'] ?? 0}",
              ),


              Text(
                "Collected: ${performance['total_collected'] ?? 0}",
              ),


              Text(
                "Recovery Rate: ${performance['recovery_rate'] ?? 0}%",
              ),


            ],

          )

        ],

      ),

    );


  }


}