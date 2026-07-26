// import 'package:creafton_financial_services/repositories/guarantor_repository.dart';

// import '../models/guarantor.dart';




// class GuarantorService {


//   final GuarantorRepository _repository =
//       GuarantorRepository();




//   // =====================================================
//   // CREATE GUARANTOR
//   // =====================================================

//   Future<int> createGuarantor(
//       Guarantor guarantor) async {


//     if(guarantor.fullName.trim().isEmpty){

//       throw Exception(
//         "Guarantor full name is required",
//       );

//     }



//     final newGuarantor =
//     guarantor.copyWith(

//       createdAt:
//       DateTime.now()
//           .toIso8601String(),

//     );



//     return await _repository.insert(
//         newGuarantor
//     );


//   }







//   // =====================================================
//   // UPDATE GUARANTOR
//   // =====================================================

//   Future<int> updateGuarantor(
//       Guarantor guarantor) async {


//     if(guarantor.id == null){

//       throw Exception(
//         "Invalid guarantor ID",
//       );

//     }



//     return await _repository.update(
//         guarantor
//     );


//   }







//   // =====================================================
//   // GET BORROWER GUARANTORS
//   // =====================================================

//   Future<List<Guarantor>>
//   getBorrowerGuarantors(
//       int borrowerId
//       ) async {


//     return await _repository
//         .getByBorrower(
//         borrowerId
//     );


//   }







//   // =====================================================
//   // GET SINGLE GUARANTOR
//   // =====================================================

//   Future<Guarantor?>
//   getGuarantor(
//       int id
//       ) async {


//     return await _repository
//         .getById(
//         id
//     );


//   }







//   // =====================================================
//   // DELETE GUARANTOR
//   // =====================================================

//   Future<int> deleteGuarantor(
//       int id
//       ) async {


//     return await _repository
//         .delete(
//         id
//     );


//   }


// }



import 'package:creafton_financial_services/repositories/guarantor_repository.dart';

import '../models/guarantor.dart';



class GuarantorService {


  final GuarantorRepository _repository =
      GuarantorRepository();





  // =====================================================
  // CREATE GUARANTOR
  // =====================================================

  Future<int> createGuarantor(
      Guarantor guarantor) async {


    if(guarantor.fullName.trim().isEmpty){

      throw Exception(
        "Guarantor full name is required",
      );

    }



    final newGuarantor =
    guarantor.copyWith(

      createdAt:
      DateTime.now()
          .toIso8601String(),

    );



    return await _repository.insert(
        newGuarantor
    );


  }








  // =====================================================
  // UPDATE GUARANTOR
  // =====================================================

  Future<int> updateGuarantor(
      Guarantor guarantor) async {


    if(guarantor.id == null){

      throw Exception(
        "Invalid guarantor ID",
      );

    }



    return await _repository.update(
        guarantor
    );


  }








  // =====================================================
  // GET BORROWER GUARANTORS
  // =====================================================

  Future<List<Guarantor>>
  getBorrowerGuarantors(
      int borrowerId
      ) async {


    return await _repository
        .getByBorrower(
        borrowerId
    );


  }








  // =====================================================
  // GET ALL GUARANTORS
  // Used by Global Guarantors Screen
  // =====================================================

  Future<List<Guarantor>>
  getAllGuarantors() async {


    return await _repository
        .getAll();


  }








  // =====================================================
  // SEARCH GUARANTORS
  // Used by Global Guarantors Screen
  // =====================================================

  Future<List<Guarantor>>
  searchGuarantors(
      String keyword
      ) async {


    return await _repository
        .search(
        keyword
    );


  }








  // =====================================================
  // GET SINGLE GUARANTOR
  // =====================================================

  Future<Guarantor?>
  getGuarantor(
      int id
      ) async {


    return await _repository
        .getById(
        id
    );


  }








  // =====================================================
  // DELETE GUARANTOR
  // =====================================================

  Future<int>
  deleteGuarantor(
      int id
      ) async {


    return await _repository
        .delete(
        id
    );


  }


}