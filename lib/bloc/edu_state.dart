import 'package:educationdashboard/models/GroupSet.dart';

import '../models/Course.dart';


abstract class EduState {}

class EduEmtyState extends EduState {}

class EduLoadingState extends EduState {}

class EduErrorState extends EduState {}

class GroupEduLoadedSatet extends EduState{

  List<GroupSet> loadedGroupEdu;
  GroupEduLoadedSatet({required this.loadedGroupEdu});
}

class CourseEduLoadedState extends EduState{
  List<Course> loadedCourse;
  CourseEduLoadedState({required this.loadedCourse});
}