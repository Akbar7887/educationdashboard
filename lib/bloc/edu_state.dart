import 'package:educationdashboard/models/GroupSet.dart';


abstract class EduState {}

class EduEmtyState extends EduState {}

class EduLoadingState extends EduState {}

class EduErrorState extends EduState {}

class GroupEduLoadedSatet extends EduState{

  List<GroupSet> loadedGroupEdu;
  GroupEduLoadedSatet({required this.loadedGroupEdu});
}