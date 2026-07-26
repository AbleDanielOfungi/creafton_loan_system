// import 'package:flutter/material.dart';

// import '../models/guarantor.dart';
// import '../services/guarantor_service.dart';



// class GuarantorProvider extends ChangeNotifier {


//   final GuarantorService _service =
//       GuarantorService();



//   List<Guarantor> _guarantors = [];


//   List<Guarantor> get guarantors =>
//       _guarantors;




//   bool _loading = false;


//   bool get loading =>
//       _loading;




//   String? _error;


//   String? get error =>
//       _error;





//   int? _currentBorrowerId;





//   // =====================================================
//   // LOAD GUARANTORS BY BORROWER
//   // =====================================================

//   Future<void> loadGuarantors(
//       int borrowerId
//       ) async {


//     try {


//       _loading = true;

//       _error = null;

//       _currentBorrowerId = borrowerId;


//       notifyListeners();




//       _guarantors =
//           await _service.getBorrowerGuarantors(
//               borrowerId
//           );



//     }

//     catch(e){


//       _error =
//           e.toString();


//     }


//     finally{


//       _loading = false;

//       notifyListeners();


//     }


//   }







//   // =====================================================
//   // ADD GUARANTOR
//   // =====================================================

//   Future<bool> addGuarantor(
//       Guarantor guarantor
//       ) async {


//     try{


//       _loading = true;

//       _error = null;

//       notifyListeners();




//       await _service.createGuarantor(
//           guarantor
//       );




//       await loadGuarantors(
//           guarantor.borrowerId
//       );



//       return true;


//     }

//     catch(e){


//       _error =
//           e.toString();


//       notifyListeners();


//       return false;


//     }

//     finally{


//       _loading = false;

//       notifyListeners();


//     }


//   }








//   // =====================================================
//   // UPDATE GUARANTOR
//   // =====================================================

//   Future<bool> updateGuarantor(
//       Guarantor guarantor
//       ) async {



//     try{


//       _loading = true;

//       _error = null;


//       notifyListeners();




//       await _service.updateGuarantor(
//           guarantor
//       );




//       if(_currentBorrowerId != null){


//         await loadGuarantors(
//             _currentBorrowerId!
//         );


//       }



//       return true;


//     }

//     catch(e){


//       _error =
//           e.toString();


//       notifyListeners();


//       return false;


//     }

//     finally{


//       _loading = false;

//       notifyListeners();


//     }


//   }








//   // =====================================================
//   // DELETE GUARANTOR
//   // =====================================================

//   Future<bool> deleteGuarantor(
//       int id
//       ) async {



//     try{


//       _loading = true;

//       _error = null;


//       notifyListeners();




//       await _service.deleteGuarantor(
//           id
//       );




//       _guarantors.removeWhere(
//               (g)=>g.id == id
//       );



//       notifyListeners();



//       return true;


//     }


//     catch(e){


//       _error =
//           e.toString();


//       notifyListeners();


//       return false;


//     }


//     finally{


//       _loading=false;

//       notifyListeners();


//     }


//   }








//   // =====================================================
//   // CLEAR DATA
//   // =====================================================

//   void clear(){


//     _guarantors = [];

//     _currentBorrowerId = null;

//     _error = null;


//     notifyListeners();


//   }



// }



import 'package:flutter/material.dart';

import '../models/guarantor.dart';
import '../services/guarantor_service.dart';



class GuarantorProvider extends ChangeNotifier {


  final GuarantorService _service =
      GuarantorService();



  List<Guarantor> _guarantors = [];

  List<Guarantor> get guarantors =>
      _guarantors;




  bool _loading = false;

  bool get loading =>
      _loading;




  String? _error;

  String? get error =>
      _error;




  int? _currentBorrowerId;





  // =====================================================
  // LOAD GUARANTORS BY BORROWER
  // Used in Borrower Details
  // =====================================================

  Future<void> loadGuarantors(
      int borrowerId
      ) async {


    try {


      _loading = true;

      _error = null;

      _currentBorrowerId = borrowerId;


      notifyListeners();



      _guarantors =
          await _service.getBorrowerGuarantors(
              borrowerId
          );



    }

    catch(e){

      _error = e.toString();

    }

    finally{

      _loading = false;

      notifyListeners();

    }


  }








  // =====================================================
  // LOAD ALL GUARANTORS
  // Used in Sidebar Guarantors Module
  // =====================================================

  Future<void> loadAllGuarantors() async {


    try {


      _loading = true;

      _error = null;


      notifyListeners();



      _guarantors =
          await _service.getAllGuarantors();



    }

    catch(e){


      _error = e.toString();


    }

    finally{


      _loading = false;

      notifyListeners();


    }


  }









  // =====================================================
  // SEARCH ALL GUARANTORS
  // =====================================================

  Future<void> searchGuarantors(
      String keyword
      ) async {


    try {


      if(keyword.trim().isEmpty){

        await loadAllGuarantors();

        return;

      }




      _loading = true;

      notifyListeners();




      _guarantors =
          await _service.searchGuarantors(
              keyword
          );



    }

    catch(e){


      _error = e.toString();


    }

    finally{


      _loading = false;

      notifyListeners();


    }


  }








  // =====================================================
  // ADD GUARANTOR
  // =====================================================

  Future<bool> addGuarantor(
      Guarantor guarantor
      ) async {


    try{


      _loading = true;

      _error = null;


      notifyListeners();



      await _service.createGuarantor(
          guarantor
      );



      if(_currentBorrowerId != null){


        await loadGuarantors(
            _currentBorrowerId!
        );


      }
      else{


        await loadAllGuarantors();


      }



      return true;


    }

    catch(e){


      _error = e.toString();


      notifyListeners();


      return false;


    }

    finally{


      _loading = false;

      notifyListeners();


    }


  }








  // =====================================================
  // UPDATE GUARANTOR
  // =====================================================

  Future<bool> updateGuarantor(
      Guarantor guarantor
      ) async {


    try{


      _loading = true;

      _error = null;


      notifyListeners();




      await _service.updateGuarantor(
          guarantor
      );




      if(_currentBorrowerId != null){


        await loadGuarantors(
            _currentBorrowerId!
        );


      }
      else{


        await loadAllGuarantors();


      }



      return true;


    }

    catch(e){


      _error = e.toString();


      notifyListeners();


      return false;


    }

    finally{


      _loading = false;

      notifyListeners();


    }


  }









  // =====================================================
  // DELETE GUARANTOR
  // =====================================================

  Future<bool> deleteGuarantor(
      int id
      ) async {


    try{


      _loading = true;

      _error = null;


      notifyListeners();




      await _service.deleteGuarantor(
          id
      );



      _guarantors.removeWhere(
              (g)=>g.id == id
      );



      notifyListeners();



      return true;


    }

    catch(e){


      _error = e.toString();


      notifyListeners();


      return false;


    }

    finally{


      _loading = false;

      notifyListeners();


    }


  }








  // =====================================================
  // CLEAR DATA
  // =====================================================

  void clear(){


    _guarantors = [];

    _currentBorrowerId = null;

    _error = null;


    notifyListeners();


  }



}