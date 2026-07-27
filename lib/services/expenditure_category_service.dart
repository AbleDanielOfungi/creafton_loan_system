import '../models/expenditure_category.dart';
import '../repositories/expenditure_category_repository.dart';



// class ExpenditureCategoryService {



// final ExpenditureCategoryRepository repository =
// ExpenditureCategoryRepository();






// Future<List<ExpenditureCategory>>
// getAllCategories() async{


// return await repository.getAll();


// }








// Future<int> createCategory(
// ExpenditureCategory category
// ) async{


// if(category.name.trim().isEmpty){

// throw Exception(
// "Category name required"
// );

// }


// return await repository.insert(category);


// }








// Future<int> updateCategory(
// ExpenditureCategory category
// ) async{


// return await repository.update(category);


// }








// Future<int> deleteCategory(
// int id
// ) async{


// return await repository.delete(id);


// }



// }


class ExpenditureCategoryService {


final ExpenditureCategoryRepository repository =
    ExpenditureCategoryRepository();



Future<List<ExpenditureCategory>> getAll() async {

  return await repository.getAll();

}



Future<int> createCategory(
    ExpenditureCategory category
) async {

  return await repository.insert(category);

}



Future<int> updateCategory(
    ExpenditureCategory category
) async {

  return await repository.update(category);

}



Future<int> deleteCategory(
    int id
) async {

  return await repository.delete(id);

}


}