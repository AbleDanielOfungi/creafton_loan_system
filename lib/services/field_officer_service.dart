import '../models/field_officer.dart';
import '../repositories/field_officer_repository.dart';



class FieldOfficerService {


  final FieldOfficerRepository _repository =
      FieldOfficerRepository();




  // =====================================================
  // CREATE FIELD OFFICER
  // =====================================================

  Future<int> createFieldOfficer(
      FieldOfficer officer) async {


    // Validate name

    if(officer.fullName.trim().isEmpty){

      throw Exception(
          "Field officer name is required"
      );

    }




    // Validate phone

    if(officer.phone.trim().isEmpty){

      throw Exception(
          "Phone number is required"
      );

    }




    // Generate officer number

    final officerNumber =
    await _generateOfficerNumber();





    final newOfficer =
    officer.copyWith(

      officerNumber:
      officerNumber,


      status:
      "ACTIVE",


      createdAt:
      DateTime.now()
          .toIso8601String(),

    );





    final id =
    await _repository.insert(
        newOfficer
    );





    // Create performance record

    await _repository
        .initializePerformance(id);





    return id;


  }







  // =====================================================
  // GENERATE OFFICER NUMBER
  // =====================================================

  Future<String>
  _generateOfficerNumber() async {


    final count =
    await _repository.count();



    final next =
    count + 1;



    return
    "FO-${next.toString()
        .padLeft(4,'0')}";


  }







  // =====================================================
  // UPDATE FIELD OFFICER
  // =====================================================

  Future<int> updateFieldOfficer(
      FieldOfficer officer) async {



    if(officer.id == null){

      throw Exception(
          "Invalid field officer"
      );

    }





    return await _repository.update(
        officer
    );


  }








  // =====================================================
  // GET ALL OFFICERS
  // =====================================================

  Future<List<FieldOfficer>>
  getAllOfficers() async {


    return await _repository.getAll();


  }







  // =====================================================
  // GET ACTIVE OFFICERS
  // =====================================================

  Future<List<FieldOfficer>>
  getActiveOfficers() async {


    return await _repository.getActive();


  }








  // =====================================================
  // SEARCH OFFICERS
  // =====================================================

  Future<List<FieldOfficer>>
  searchOfficer(
      String keyword) async {


    return await _repository.search(
        keyword
    );


  }







  // =====================================================
  // GET SINGLE OFFICER
  // =====================================================

  Future<FieldOfficer?>
  getOfficer(int id) async {


    return await _repository.getById(
        id
    );


  }








  // =====================================================
  // ACTIVATE OFFICER
  // =====================================================

  Future<int>
  activateOfficer(int id) async {


    return await _repository.updateStatus(

      id,

      "ACTIVE",

    );


  }








  // =====================================================
  // DEACTIVATE OFFICER
  // =====================================================

  Future<int>
  deactivateOfficer(int id) async {


    return await _repository.updateStatus(

      id,

      "INACTIVE",

    );


  }








  // =====================================================
  // ASSIGN BORROWER TO OFFICER
  // =====================================================

  Future<int>
  assignBorrower(

      int borrowerId,

      int officerId

      ) async {


    return await _repository
        .assignBorrower(

        borrowerId,

        officerId

    );


  }








  // =====================================================
  // REMOVE BORROWER ASSIGNMENT
  // =====================================================

  Future<int>
  removeBorrowerAssignment(
      int borrowerId
      ) async {


    return await _repository
        .removeBorrower(

        borrowerId

    );


  }








  // =====================================================
  // GET PERFORMANCE
  // =====================================================

  Future<Map<String,dynamic>>
  getOfficerPerformance(
      int officerId
      ) async {


    return await _repository
        .getPerformance(

        officerId

    );


  }



}