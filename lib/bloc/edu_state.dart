import '../models/GroupEdu.dart';

abstract class EduState {}

class EduEmtyState extends EduState {}

class EduLoadingState extends EduState {}

class EduErrorState extends EduState {}

class GroupEduLoadedSatet extends EduState{

  List<GroupEdu> loadedGroupEdu;
  GroupEduLoadedSatet({required this.loadedGroupEdu});
}