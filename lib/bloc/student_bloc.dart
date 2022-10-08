import 'package:educationdashboard/bloc/edu_state.dart';
import 'package:educationdashboard/models/Student.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/repository.dart';

class StudentBloc extends Cubit<EduState>{

  late final Repository repository;

  StudentBloc({required this.repository}): super(EduEmtyState());

  Future<List<dynamic>> get() async{
    return await repository.getall("student/get");
  }

  Future<List<dynamic>> getbyid(String id) async{
    return await repository.getById("student/getbygroup", id);
  }

  Future<dynamic> save(Student student){
    return repository.save("student/save", student);
  }
  Future<dynamic> remove(String id){
    return repository.remove("student/remove", id);
  }

}