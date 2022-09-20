import 'package:educationdashboard/bloc/edu_state.dart';

import '../models/GroupEdu.dart';

abstract class EduEvent{}

class EduLoadEvent extends EduEvent{}

class EduClearEvent extends EduEvent{}

