import 'package:educationdashboard/api/repository.dart';
import 'package:educationdashboard/bloc/edu_state.dart';
import 'package:educationdashboard/models/Level.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LevelBloc extends Cubit<EduState> {
  final Repository repository;

  LevelBloc({required this.repository}) : super(EduEmtyState());

  Future<List<dynamic>> getAllByParam(
      String url, String course_id, String subject_id) {
    return repository.getAllByParam(url, course_id, subject_id);
  }

  Future<dynamic> remove(String id){
    return repository.remove("level/remove", id);
  }
  Future<dynamic> save(Level level){
    return repository.save("level/save", level);
  }

}
