
import 'package:educationdashboard/bloc/course_bloc.dart';
import 'package:educationdashboard/bloc/subject_bloc.dart';
import 'package:educationdashboard/pages/groupedu_page.dart';
import 'package:educationdashboard/pages/student_page.dart';
import 'package:educationdashboard/pages/widgets/menu.dart';
import 'package:educationdashboard/providers/simple_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/repository.dart';
import '../bloc/groupbloc.dart';
import '../bloc/edu_event.dart';
import '../bloc/student_bloc.dart';
import '../models/ui.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
        create: (context) => Repository(),
        child: MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) =>
                      GroupBloc(repository: context.read<Repository>())),
              BlocProvider(
                  create: (context) =>
                      SubjectBloc(repository: context.read<Repository>())),
              BlocProvider(
                  create: (context) =>
                      CourseBloc(repository: context.read<Repository>())
                        ..add(EduLoadEvent())),
              BlocProvider(
                  create: (context) =>
                      StudentBloc(repository: context.read<Repository>())),
            ],
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.black54,
                  elevation: 1,
                  title: Text(
                    Ui.name,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                body: Row(
                  children: [
                    Container(child: Menu()),
                    Expanded(
                        child: selectPage(
                            context.watch<SimpleProvider>().getindexpage)),
                  ],
                ))));
  }

  selectPage(int page) {
    switch (page) {
      case 1:
        return GroupEduPage();
      case 2:
        return StudentPage();
    }
  }
}
