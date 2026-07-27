import '../models/expenditure.dart';
import '../repositories/expenditure_repository.dart';



class ExpenditureService {


  final ExpenditureRepository repository =
      ExpenditureRepository();





  // =====================================================
  // GET ALL
  // =====================================================

  Future<List<Expenditure>> getAll() async {


    return await repository.getAll();


  }


  Future<List<Expenditure>>
getByDateRange(
String start,
String end
) async {


final data =
await repository.getByDateRange(
start,
end
);



return data
.map(
(e)=>Expenditure.fromMap(e)
)
.toList();


}

Future<List<Map<String,dynamic>>>
categoryReport() async {


return await repository
.getByCategory();


}






  // =====================================================
  // CREATE
  // =====================================================

  Future<int> create(
      Expenditure expenditure
      ) async {



    if(expenditure.title.trim().isEmpty){


      throw Exception(
          "Expenditure title required"
      );


    }



    return await repository.insert(
        expenditure
    );


  }








  // =====================================================
  // UPDATE
  // =====================================================

  Future<int> update(
      Expenditure expenditure
      ) async {


    if(expenditure.id == null){


      throw Exception(
          "Invalid expenditure ID"
      );


    }



    return await repository.update(
        expenditure
    );


  }








  // =====================================================
  // DELETE
  // =====================================================

  Future<int> delete(
      int id
      ) async {


    return await repository.delete(
        id
    );


  }



}