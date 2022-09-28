import 'package:educationdashboard/api/repository.dart';
import 'package:educationdashboard/bloc/edu_state.dart';
import 'package:educationdashboard/models/Task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskBloc extends Cubit<EduState> {
  final Repository repository;

  TaskBloc({required this.repository}) : super(EduEmtyState());

  Future<List<dynamic>> get() async {
    return await repository.getall("task/get");
  }

  Future<List<dynamic>> getBylevelId(String id) async {
    return await repository.getByleveId("task/getbylevel", id);
  }

  Future<dynamic> save(Task task, String id) {
    return repository.saveId("task/save", task, "id", id);
  }

  Future<dynamic> remove(String id) {
    return repository.remove("task/remove", id);
  }

  Future<dynamic> saveShow(String url, String id, bool show) =>
      repository.saveShow(url, id, show);
}
