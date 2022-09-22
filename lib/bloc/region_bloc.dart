import 'package:educationdashboard/api/repository.dart';
import 'package:educationdashboard/bloc/edu_state.dart';
import 'package:educationdashboard/models/Region.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

class RegionBloc extends Cubit<EduState>{
  
  final Repository repository;

  RegionBloc({ required this.repository}): super(EduEmtyState());
  
  Future<List<dynamic>> get() async{
    return await repository.getall("region/get");
  }
}