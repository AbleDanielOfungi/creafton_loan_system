// class ExpenditureCategory {


// final int? id;

// final String name;

// final String? description;

// final String createdAt;



// ExpenditureCategory({

// this.id,

// required this.name,

// this.description,

// required this.createdAt,

// });



// factory ExpenditureCategory.fromMap(
// Map<String,dynamic> map){

// return ExpenditureCategory(

// id:map['id'],

// name:map['name'],

// description:map['description'],

// createdAt:map['created_at'],

// );

// }



// Map<String,dynamic> toMap(){

// return {

// 'id':id,

// 'name':name,

// 'description':description,

// 'created_at':createdAt,

// };

// }


// }


class ExpenditureCategory {


  final int? id;


  final String name;


  final String? description;


  final String createdAt;



  ExpenditureCategory({

    this.id,

    required this.name,

    this.description,

    required this.createdAt,

  });





  factory ExpenditureCategory.fromMap(
      Map<String,dynamic> map){

    return ExpenditureCategory(

      id: map['id'],

      name: map['name'],

      description: map['description'],

      createdAt: map['created_at'],

    );

  }







  Map<String,dynamic> toMap(){

    return {


      'id':id,


      'name':name,


      'description':description,


      'created_at':createdAt,


    };

  }







  ExpenditureCategory copyWith({

    int? id,

    String? name,

    String? description,

    String? createdAt,


  }){


    return ExpenditureCategory(


      id:id ?? this.id,


      name:name ?? this.name,


      description:
      description ?? this.description,


      createdAt:
      createdAt ?? this.createdAt,


    );


  }



}