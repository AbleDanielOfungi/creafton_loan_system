


import 'package:flutter/material.dart';

import '../models/expenditure_category.dart';
import '../services/expenditure_category_service.dart';



class ExpenditureCategoryProvider extends ChangeNotifier {


  final ExpenditureCategoryService service =
      ExpenditureCategoryService();




  // =====================================================
  // STATE
  // =====================================================


  List<ExpenditureCategory> categories = [];


  bool loading = false;


  String? error;






  // =====================================================
  // LOAD CATEGORIES
  // =====================================================


  Future<void> loadCategories() async {


    try{


      loading = true;

      error = null;


      notifyListeners();




      categories =
          await service.getAll();



    }


    catch(e){


      error =
          e.toString();


    }


    finally{


      loading = false;

      notifyListeners();


    }


  }







  // =====================================================
  // ADD CATEGORY
  // =====================================================


  Future<bool> addCategory(
      ExpenditureCategory category
      ) async {


    try{


      await service.createCategory(
          category
      );



      await loadCategories();



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
  // UPDATE CATEGORY
  // =====================================================


  Future<bool> updateCategory(
      ExpenditureCategory category
      ) async {


    try{


      await service.updateCategory(
          category
      );



      await loadCategories();



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
  // DELETE CATEGORY
  // =====================================================


  Future<bool> deleteCategory(
      int id
      ) async {


    try{


      await service.deleteCategory(
          id
      );



      await loadCategories();



      return true;


    }


    catch(e){


      error =
          e.toString();


      notifyListeners();


      return false;


    }


  }






}