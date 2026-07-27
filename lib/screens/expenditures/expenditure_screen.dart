import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:data_table_2/data_table_2.dart';


import '../../providers/expenditure_provider.dart';
import '../../models/expenditure.dart';

import 'add_expenditure_screen.dart';
import 'edit_expenditure_screen.dart';



class ExpendituresScreen extends StatefulWidget {


  const ExpendituresScreen({
    super.key,
  });



  @override
  State<ExpendituresScreen> createState() =>
      _ExpendituresScreenState();


}




class _ExpendituresScreenState
    extends State<ExpendituresScreen> {


  final TextEditingController searchController =
      TextEditingController();





  @override
  void initState(){


    super.initState();


    WidgetsBinding.instance
        .addPostFrameCallback((_) {


      context
          .read<ExpenditureProvider>()
          .loadExpenditures();


    });


  }







  @override
  void dispose(){


    searchController.dispose();


    super.dispose();

  }







  String money(double value){


    return "UGX ${value.toStringAsFixed(0)}";


  }









  void openAdd() async{


    await Navigator.push(

      context,

      MaterialPageRoute(

        builder:(_)=>
        const AddExpenditureScreen(),

      ),

    );


    if(!mounted)return;


    context
        .read<ExpenditureProvider>()
        .loadExpenditures();


  }









  @override
  Widget build(BuildContext context){


    return Scaffold(



      appBar: AppBar(

        title:
        const Text(
          "Expenditures",
        ),



        actions:[


          IconButton(

            icon:
            const Icon(
              Icons.refresh,
            ),


            onPressed:(){

              context
                  .read<ExpenditureProvider>()
                  .loadExpenditures();

            },

          )


        ],


      ),







      floatingActionButton:

      FloatingActionButton.extended(

        onPressed:
        openAdd,


        icon:
        const Icon(
          Icons.add,
        ),


        label:
        const Text(
          "Add Expense",
        ),


      ),







      body:

      Consumer<ExpenditureProvider>(


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






          return Padding(

            padding:
            const EdgeInsets.all(16),



            child:
            Column(

              children:[



                _statistics(provider),



                const SizedBox(
                  height:20,
                ),






                _search(provider),





                const SizedBox(
                  height:20,
                ),







                Expanded(

                  child:
                  _table(provider),


                )



              ],


            ),


          );


        },


      ),


    );


  }













  Widget _statistics(
      ExpenditureProvider provider
      ){



    return Row(


      children:[



        Expanded(

          child:
          _card(

              "Total Expenses",

              money(
                  provider.total
              ),

              Icons.money

          ),

        ),





        const SizedBox(
          width:12,
        ),





        Expanded(

          child:
          _card(

              "This Month",

              money(
                  provider.monthlyTotal
              ),

              Icons.calendar_month

          ),

        ),






        const SizedBox(
          width:12,
        ),




        Expanded(

          child:
          _card(

              "Today",

              money(
                  provider.todayTotal
              ),

              Icons.today

          ),

        ),



      ],


    );


  }










  Widget _card(
      String title,
      String value,
      IconData icon
      ){



    return Card(


      elevation:3,


      child:
      Padding(

        padding:
        const EdgeInsets.all(18),



        child:
        Column(


          crossAxisAlignment:
          CrossAxisAlignment.start,



          children:[


            Icon(icon),



            const SizedBox(
              height:10,
            ),



            Text(

              title,

              style:
              const TextStyle(

                fontSize:14,

              ),

            ),



            const SizedBox(
              height:5,
            ),




            Text(

              value,

              style:
              const TextStyle(

                fontWeight:
                FontWeight.bold,

                fontSize:18,

              ),

            )



          ],


        ),


      ),


    );


  }









  Widget _search(
      ExpenditureProvider provider
      ){



    return TextField(


      controller:
      searchController,



      decoration:
      InputDecoration(


        hintText:
        "Search expenditure",



        prefixIcon:
        const Icon(
          Icons.search,
        ),



        border:
        OutlineInputBorder(

          borderRadius:
          BorderRadius.circular(12),

        ),


      ),



      onChanged:
      (value){


        provider.search(value);


      },


    );


  }













  Widget _table(
      ExpenditureProvider provider
      ){



    if(provider.filtered.isEmpty){


      return const Center(

        child:
        Text(
          "No expenditures found",
        ),

      );


    }






    return Container(


      decoration:
      BoxDecoration(

        color:
        Colors.white,


        borderRadius:
        BorderRadius.circular(15),


      ),





      child:
      DataTable2(



        columnSpacing:
        25,



        headingRowColor:

        WidgetStateProperty.all(
            Colors.grey.shade200
        ),






        columns:[


          const DataColumn(
              label:
              Text("Title")
          ),



          const DataColumn(
              label:
              Text("Amount")
          ),



          const DataColumn(
              label:
              Text("Payment")
          ),



          const DataColumn(
              label:
              Text("Date")
          ),



          const DataColumn(
              label:
              Text("Actions")
          ),


        ],







        rows:

        provider.filtered
            .map(

                (Expenditure expense){


              return DataRow(

                cells:[



                  DataCell(

                    Text(
                      expense.title,
                    ),

                  ),





                  DataCell(

                    Text(

                      money(
                          expense.amount
                      ),

                    ),

                  ),






                  DataCell(

                    Text(

                      expense.paymentMethod ??
                          "-",

                    ),

                  ),





                  DataCell(

                    Text(

                      expense.expenseDate,

                    ),

                  ),






                  DataCell(

                    Row(

                      children:[



                        IconButton(

                          icon:
                          const Icon(
                              Icons.edit
                          ),


                          onPressed:(){


                            Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder:(_)=>

                                EditExpenditureScreen(

                                  expenditure:
                                  expense,

                                ),

                              ),

                            );


                          },


                        ),





                        IconButton(

                          icon:
                          const Icon(
                            Icons.delete,
                          ),



                          onPressed:()async{


                            await provider
                                .delete(
                                expense.id!
                            );


                          },


                        )



                      ],


                    ),


                  )




                ],


              );


            })

            .toList(),



      ),


    );


  }




}