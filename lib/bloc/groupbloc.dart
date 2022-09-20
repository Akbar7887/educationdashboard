import 'package:educationdashboard/bloc/edu_event.dart';
import 'package:educationdashboard/bloc/edu_state.dart';
import 'package:educationdashboard/models/GroupEdu.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/repository.dart';

class GroupBloc extends Bloc<EduEvent, EduState> {
  final Repository repository;

  GroupBloc({required this.repository}) : super(EduEmtyState()) {
    on<EduLoadEvent>((event, emit) async {
      emit(EduLoadingState());
      try {
        final json = await repository.getall("groupedu/get");

        final loadedGroupEdu = json.map((e) => GroupEdu.fromJson(e)).toList();
        emit(GroupEduLoadedSatet(loadedGroupEdu: loadedGroupEdu));
      } catch (_) {
        throw Exception(EduErrorState());
      }
    });

    on<EduClearEvent>((event, emit) => emit(EduEmtyState()));
  }
}
