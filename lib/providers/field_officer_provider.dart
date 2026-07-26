// import 'package:flutter/material.dart';

// import '../models/field_officer.dart';
// import '../services/field_officer_service.dart';


// class FieldOfficerProvider extends ChangeNotifier {


//   final FieldOfficerService _service =
//       FieldOfficerService();



//   List<FieldOfficer> _officers = [];


//   List<FieldOfficer> get officers => _officers;



//   bool _loading = false;


//   bool get loading => _loading;




//   Future<void> loadOfficers() async {


//     _loading = true;

//     notifyListeners();



//     _officers =
//         await _service.getAllOfficers();



//     _loading = false;

//     notifyListeners();

//   }





//   Future<void> search(
//       String keyword) async {


//     _officers =
//         await _service.searchOfficer(keyword);


//     notifyListeners();

//   }






//   Future<void> addOfficer(
//       FieldOfficer officer) async {


//     await _service.createFieldOfficer(
//         officer
//     );


//     await loadOfficers();


//   }







//   Future<void> updateOfficer(
//       FieldOfficer officer) async {


//     await _service.updateFieldOfficer(
//         officer
//     );


//     await loadOfficers();


//   }





//   Future<void> deleteStatus(
//       int id,
//       String status) async {


//     if(status=="ACTIVE"){

//       await _service.deactivateOfficer(id);

//     }

//     else{

//       await _service.activateOfficer(id);

//     }


//     await loadOfficers();


//   }


// }



import 'package:flutter/material.dart';

import '../models/field_officer.dart';
import '../services/field_officer_service.dart';


class FieldOfficerProvider extends ChangeNotifier {


  final FieldOfficerService _service =
      FieldOfficerService();



  List<FieldOfficer> _officers = [];


  // =====================================================
  // GETTERS
  // =====================================================

  List<FieldOfficer> get officers => _officers;


  // Alias used by borrower assignment UI
  List<FieldOfficer> get fieldOfficers => _officers;



  bool _loading = false;


  bool get loading => _loading;




  // =====================================================
  // LOAD ALL FIELD OFFICERS
  // =====================================================

  Future<void> loadOfficers() async {


    try {

      _loading = true;

      notifyListeners();



      _officers =
          await _service.getAllOfficers();


    }

    catch(e){

      debugPrint(
          "Field officer load error: $e"
      );

    }


    finally{

      _loading = false;

      notifyListeners();

    }


  }








  // =====================================================
  // SEARCH FIELD OFFICERS
  // =====================================================

  Future<void> search(
      String keyword
      ) async {


    if(keyword.trim().isEmpty){


      await loadOfficers();

      return;

    }



    _officers =
        await _service.searchOfficer(
            keyword
        );



    notifyListeners();


  }





  // Alias used by borrower screen

  Future<void> searchFieldOfficers(
      String keyword
      ) async {


    await search(keyword);


  }









  // =====================================================
  // ADD
  // =====================================================

  Future<void> addOfficer(
      FieldOfficer officer
      ) async {


    await _service.createFieldOfficer(
        officer
    );


    await loadOfficers();


  }









  // =====================================================
  // UPDATE
  // =====================================================

  Future<void> updateOfficer(
      FieldOfficer officer
      ) async {


    await _service.updateFieldOfficer(
        officer
    );


    await loadOfficers();


  }









  // =====================================================
  // STATUS CHANGE
  // =====================================================

  Future<void> deleteStatus(
      int id,
      String status
      ) async {



    if(status=="ACTIVE"){


      await _service.deactivateOfficer(id);


    }

    else{


      await _service.activateOfficer(id);


    }



    await loadOfficers();


  }



}