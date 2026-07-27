import 'package:creafton_financial_services/services/expenditure_service.dart';
import 'package:flutter/material.dart';

import '../models/expenditure.dart';





class ExpenditureProvider extends ChangeNotifier {


  final ExpenditureService service =
      ExpenditureService();



  // =====================================================
  // DATA
  // =====================================================


  List<Expenditure> expenditures = [];


  List<Expenditure> filtered = [];



  bool loading = false;



  String? error;

DateTime? customStartDate;

DateTime? customEndDate;


List<Expenditure> customReportData = [];


  // =====================================================
  // STATISTICS
  // =====================================================


  double total = 0;


  double todayTotal = 0;


  double monthlyTotal = 0;


  double yearlyTotal = 0;




  // =====================================================
  // LOAD EXPENDITURES
  // =====================================================


  Future<void> loadExpenditures() async {


    try{


      loading = true;

      error = null;


      notifyListeners();




      expenditures =
          await service.getAll();




      filtered =
          List.from(expenditures);




      calculateStatistics();



    }

    catch(e){


      error = e.toString();


    }


    finally{


      loading = false;

      notifyListeners();


    }


  }


// =====================================================
// CUSTOM DATE REPORT
// =====================================================

void generateCustomReport(
    DateTime start,
    DateTime end
){

  customStartDate = start;

  customEndDate = end;


  customReportData =
      expenditures.where((e){


        final date =
        DateTime.parse(
            e.expenseDate
        );


        return date.isAfter(
            start.subtract(
              const Duration(days:1),
            )
        )

        &&

        date.isBefore(
            end.add(
              const Duration(days:1),
            )
        );


      }).toList();



  filtered =
      List.from(
          customReportData
      );


  notifyListeners();

}

void clearCustomReport(){

  customStartDate=null;

  customEndDate=null;

  filtered =
      List.from(expenditures);


  notifyListeners();

}

List<Expenditure> reports=[];


double reportTotal=0;



Future<void> generateDailyReport() async {


final today =
DateTime.now()
.toIso8601String()
.substring(0,10);



reports =
await service.getByDateRange(
today,
today
);


calculateReportTotal();


notifyListeners();

}



Future<void> generateWeeklyReport() async {


final now =
DateTime.now();



final start =
now.subtract(
const Duration(days:7)
);



reports =
await service.getByDateRange(

start.toIso8601String()
.substring(0,10),

now.toIso8601String()
.substring(0,10)

);



calculateReportTotal();


notifyListeners();


}


Future<void> generateYearlyReport() async {


final year =
DateTime.now().year;



reports =
await service.getByDateRange(

"$year-01-01",

"$year-12-31"

);



calculateReportTotal();


notifyListeners();


}


Future<List<Map<String,dynamic>>>
generateCategoryReport() async {


return await service.categoryReport();


}


void calculateReportTotal(){


reportTotal =
reports.fold(

0,

(sum,e)=>
sum+e.amount

);


}







  // =====================================================
  // SEARCH EXPENDITURES
  // =====================================================


  // void search(String value){


  //   if(value.trim().isEmpty){


  //     filtered =
  //         List.from(expenditures);


  //   }


  //   else{


  //     final keyword =
  //         value.toLowerCase();



  //     filtered =
  //         expenditures.where((e){


  //           return

  //           e.title
  //               .toLowerCase()
  //               .contains(keyword)

  //               ||

  //           e.category
  //               .toLowerCase()
  //               .contains(keyword)

  //               ||

  //           (e.paymentMethod ?? "")
  //               .toLowerCase()
  //               .contains(keyword);


  //         }).toList();



  //   }



  //   notifyListeners();


  // }


void search(String value) {


  if(value.trim().isEmpty){

    filtered =
        List.from(expenditures);

  }

  else{


    final keyword =
        value.toLowerCase();



    filtered =
        expenditures.where((e){


          return e.title
              .toLowerCase()
              .contains(keyword)

              ||

              (e.paymentMethod ?? "")
                  .toLowerCase()
                  .contains(keyword)

              ||

              (e.referenceNumber ?? "")
                  .toLowerCase()
                  .contains(keyword)

              ||

              (e.description ?? "")
                  .toLowerCase()
                  .contains(keyword);



        }).toList();


  }


  notifyListeners();

}








  // =====================================================
  // ADD EXPENDITURE
  // =====================================================


  Future<bool> add(
      Expenditure expenditure
      ) async{


    try{


      await service.create(
          expenditure
      );


      await loadExpenditures();


      return true;


    }

    catch(e){


      error =
          e.toString();


      notifyListeners();


      return false;


    }


  }









  // =====================================================
  // UPDATE
  // =====================================================


  Future<bool> updateExpenditure(
      Expenditure expenditure
      ) async {


    try{


      await service.update(
          expenditure
      );



      await loadExpenditures();



      return true;


    }


    catch(e){


      error =
          e.toString();


      notifyListeners();


      return false;


    }


  }









  // =====================================================
  // DELETE
  // =====================================================


  Future<void> delete(
      int id
      ) async{


    try{


      await service.delete(
          id
      );



      await loadExpenditures();



    }


    catch(e){


      error =
          e.toString();



      notifyListeners();


    }


  }









  // =====================================================
  // STATISTICS
  // =====================================================


  void calculateStatistics(){



    total =
        expenditures.fold(

          0,

          (sum,e)=>
              sum + e.amount,

        );





    final now =
        DateTime.now();




    final today =
        now.toIso8601String()
            .substring(0,10);




    todayTotal =
        expenditures
            .where(
                (e)=>
            e.expenseDate ==
                today
        )
            .fold(
            0,
                (sum,e)=>
            sum + e.amount
        );






    monthlyTotal =
        expenditures
            .where(
                (e){


              final date =
              DateTime.parse(
                  e.expenseDate
              );


              return date.month ==
                  now.month
                  &&
                  date.year ==
                      now.year;


            })
            .fold(
            0,
                (sum,e)=>
            sum+e.amount
        );







    yearlyTotal =
        expenditures
            .where(
                (e){


              final date =
              DateTime.parse(
                  e.expenseDate
              );


              return date.year ==
                  now.year;


            })
            .fold(
            0,
                (sum,e)=>
            sum+e.amount
        );



  }







  // =====================================================
  // REFRESH
  // =====================================================


  Future<void> refresh() async{


    await loadExpenditures();


  }


}