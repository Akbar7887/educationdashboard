import 'package:educationdashboard/bloc/edu_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/repository.dart';

class StudentBloc extends Cubit<EduState>{

  late final Repository repository;

  StudentBloc({required this.repository}): super(EduEmtyState());

  Future<List<dynamic>> get() async{
    return await repository.getall("course/get");
  }
}