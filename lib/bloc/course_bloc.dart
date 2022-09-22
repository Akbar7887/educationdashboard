import 'package:educationdashboard/api/repository.dart';
import 'package:educationdashboard/bloc/edu_state.dart';
import 'package:educationdashboard/models/Course.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'edu_event.dart';

class CourseBloc extends Bloc<EduEvent, EduState>{

  final Repository repository;


  CourseBloc({required this.repository}) : super(EduEmtyState()) {
    on<EduLoadEvent>((event, emit) async {
      emit(EduLoadingState());
      try {
        final json = await repository.getall("course/get");

        final loadedCourse = json.map((e) => Course.fromJson(e)).toList();
        emit(CourseEduLoadedState(loadedCourse: loadedCourse));
      } catch (_) {
        throw Exception(EduErrorState());
      }
    });

    on<EduClearEvent>((event, emit) => emit(EduEmtyState()));
  }
  // Future<List<dynamic>> getall() async {
  //   return await repository.getall("course/get");
  // }
}