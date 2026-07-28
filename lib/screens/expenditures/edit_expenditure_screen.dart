import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/expenditure.dart';
import '../../providers/expenditure_provider.dart';
import '../../providers/expenditure_category_provider.dart';


class EditExpenditureScreen extends StatefulWidget {

  final Expenditure expenditure;


  const EditExpenditureScreen({
    super.key,
    required this.expenditure,
  });


  @override
  State<EditExpenditureScreen> createState() =>
      _EditExpenditureScreenState();

}



class _EditExpenditureScreenState
    extends State<EditExpenditureScreen> {


  final formKey =
      GlobalKey<FormState>();


  late TextEditingController titleController;

  late TextEditingController amountController;

  late TextEditingController referenceController;

  late TextEditingController descriptionController;



  late int categoryId;


  String? paymentMethod;


  late DateTime expenseDate;


  bool saving=false;



  @override
  void initState(){

    super.initState();


    final expense =
        widget.expenditure;


    titleController =
        TextEditingController(
          text: expense.title,
        );


    amountController =
        TextEditingController(
          text: expense.amount.toStringAsFixed(0),
        );


    referenceController =
        TextEditingController(
          text: expense.referenceNumber ?? "",
        );


    descriptionController =
        TextEditingController(
          text: expense.description ?? "",
        );


    categoryId =
        expense.categoryId;


    paymentMethod =
        expense.paymentMethod;


    expenseDate =
        DateTime.parse(
          expense.expenseDate,
        );



    WidgetsBinding.instance
        .addPostFrameCallback((_){

      context
          .read<ExpenditureCategoryProvider>()
          .loadCategories();

    });


  }




  @override
  void dispose(){

    titleController.dispose();

    amountController.dispose();

    referenceController.dispose();

    descriptionController.dispose();

    super.dispose();

  }




  Future<void> update() async{


    if(!formKey.currentState!.validate()){
      return;
    }


    setState(() {

      saving=true;

    });



    try{


      final updated =
      widget.expenditure.copyWith(


        categoryId:
        categoryId,


        title:
        titleController.text.trim(),


        amount:
        double.parse(
          amountController.text.replaceAll(",", ""),
        ),


        paymentMethod:
        paymentMethod,


        referenceNumber:
        referenceController.text.trim(),


        description:
        descriptionController.text.trim(),


        expenseDate:
        expenseDate
            .toIso8601String()
            .substring(0,10),


      );



      final success =
      await context
          .read<ExpenditureProvider>()
          .updateExpenditure(
          updated
      );



      if(!mounted)return;



      if(success){


        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(

            content:
            Text(
                "Expenditure updated successfully"
            ),

          ),

        );


        Navigator.pop(context);


      }



    }
    catch(e){


      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content:
          Text(
              e.toString()
          ),
        ),

      );


    }
    finally{


      if(mounted){

        setState(() {

          saving=false;

        });

      }


    }



  }







  Widget inputField({

    required String label,

    required TextEditingController controller,

    required IconData icon,

    TextInputType type =
    TextInputType.text,


    int maxLines=1,

  }){


    return TextFormField(

      controller:
      controller,


      keyboardType:
      type,


      maxLines:
      maxLines,


      validator:(value){


        if(value==null ||
            value.trim().isEmpty){

          return "$label required";

        }


        return null;


      },


      decoration:
      InputDecoration(

        labelText:
        label,


        prefixIcon:
        Icon(icon),


        border:
        OutlineInputBorder(

          borderRadius:
          BorderRadius.circular(12),

        ),

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
            "Edit Expenditure"
        ),

      ),





      body:
      SingleChildScrollView(


        padding:
        const EdgeInsets.all(20),



        child:
        Form(


          key:
          formKey,



          child:
          Column(

            children:[



              Consumer<ExpenditureCategoryProvider>(

                builder:
                (context,provider,_){


                  return DropdownButtonFormField<int>(


                    value:
                    categoryId,


                    decoration:
                    InputDecoration(


                      labelText:
                      "Expense Category",


                      prefixIcon:
                      const Icon(
                          Icons.category
                      ),


                      border:
                      OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(12),

                      ),

                    ),



                    items:

                    provider.categories
                        .map(

                            (category)=>DropdownMenuItem<int>(

                          value:
                          category.id,


                          child:
                          Text(
                              category.name
                          ),


                        )

                    )
                        .toList(),



                    onChanged:(value){

                      setState(() {

                        categoryId=value!;

                      });

                    },

                  );


                },

              ),



              const SizedBox(height:18),




              inputField(

                label:
                "Expense Title",

                controller:
                titleController,

                icon:
                Icons.title,

              ),




              const SizedBox(height:18),





              inputField(

                label:
                "Amount (UGX)",

                controller:
                amountController,

                icon:
                Icons.money,

                type:
                TextInputType.number,

              ),




              const SizedBox(height:18),





              DropdownButtonFormField<String>(


                value:
                paymentMethod,



                decoration:
                InputDecoration(

                  labelText:
                  "Payment Method",


                  prefixIcon:
                  const Icon(
                      Icons.payment
                  ),


                  border:
                  OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(12),

                  ),

                ),



                items:
                const [


                  DropdownMenuItem(

                    value:
                    "Cash",

                    child:
                    Text(
                        "Cash"
                    ),

                  ),


                  DropdownMenuItem(

                    value:
                    "Mobile Money",

                    child:
                    Text(
                        "Mobile Money"
                    ),

                  ),


                  DropdownMenuItem(

                    value:
                    "Bank",

                    child:
                    Text(
                        "Bank"
                    ),

                  ),


                ],



                onChanged:(value){

                  setState(() {

                    paymentMethod=value;

                  });

                },


              ),




              const SizedBox(height:18),





              inputField(

                label:
                "Reference Number",

                controller:
                referenceController,

                icon:
                Icons.receipt_long,

              ),





              const SizedBox(height:18),




              Card(

                child:
                ListTile(


                  leading:
                  const Icon(
                      Icons.calendar_month
                  ),



                  title:
                  Text(

                    "Expense Date\n${expenseDate.toIso8601String().substring(0,10)}",

                  ),



                  trailing:
                  const Icon(
                      Icons.edit_calendar
                  ),



                  onTap:() async{


                    final date =
                    await showDatePicker(

                      context:
                      context,


                      firstDate:
                      DateTime(2020),


                      lastDate:
                      DateTime(2100),


                      initialDate:
                      expenseDate,

                    );



                    if(date!=null){

                      setState(() {

                        expenseDate=date;

                      });

                    }


                  },


                ),

              ),




              const SizedBox(height:18),




              inputField(

                label:
                "Description",

                controller:
                descriptionController,

                icon:
                Icons.description,

                maxLines:
                3,

              ),





              const SizedBox(height:30),





              SizedBox(

                width:
                double.infinity,


                height:
                55,



                child:
                ElevatedButton.icon(


                  icon:
                  saving

                      ?
                  const SizedBox(
                    height:20,
                    width:20,
                    child:
                    CircularProgressIndicator(
                      strokeWidth:2,
                    ),
                  )

                      :
                  const Icon(
                      Icons.save
                  ),



                  label:
                  Text(

                    saving
                        ?
                    "Updating..."
                        :
                    "UPDATE EXPENDITURE",

                  ),



                  onPressed:
                  saving
                      ?
                  null
                      :
                  update,


                ),

              )



            ],

          ),


        ),


      ),


    );


  }


}