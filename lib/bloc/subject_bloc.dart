import 'package:educationdashboard/api/repository.dart';
import 'package:educationdashboard/bloc/edu_state.dart';
import 'package:educationdashboard/models/Subject.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubjectBloc extends Cubit<EduState> {
  late final Repository repository;

  SubjectBloc({required this.repository}) : super(EduEmtyState());

  Future<List<dynamic>> getall() async {
    return await repository.getall("subject/get");
  }
}
