import 'package:educationdashboard/bloc/course_bloc.dart';
import 'package:educationdashboard/bloc/level_bloc.dart';
import 'package:educationdashboard/bloc/subject_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/Course.dart';
import '../models/Level.dart';
import '../models/Subject.dart';
import '../models/ui.dart';

class LevelPage extends StatefulWidget {
  const LevelPage({Key? key}) : super(key: key);

  @override
  State<LevelPage> createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  List<Level> _listLevel = [];
  List<Course> _listCourse = [];
  Course? _course;
  List<Subject> _listSubject = [];
  Subject? _subject;
  late CourseBloc courseBloc;
  late SubjectBloc subjectBloc;
  late LevelBloc levelBloc;

  void getSubject() {
    subjectBloc.getall().then((value) {
      setState(() {
        _listSubject = value.map((e) => Subject.fromJson(e)).toList();
        _listSubject.sort((a, b) => a.id!.compareTo(b.id!));
      });
    });
  }

  void getLevel(String course_id, String subject_id) {
    levelBloc
        .getAllByParam("level/getcs/", course_id, subject_id)
        .then((value) {
      setState(() {
        _listLevel = value.map((e) => Level.fromJson(e)).toList();
        _listLevel.sort((a, b) => a.level_id!.compareTo(b.level_id!));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    courseBloc = BlocProvider.of<CourseBloc>(context);
    subjectBloc = BlocProvider.of<SubjectBloc>(context);
    levelBloc = BlocProvider.of<LevelBloc>(context);
    getSubject();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: courseBloc.get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (_listCourse.isEmpty) {
            _listCourse =
                snapshot.data!.map((e) => Course.fromJson(e)).toList();
            _listCourse.sort((a, b) => a.id!.compareTo(b.id!));
          }
          return Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Предметы и Темы",
                      style: TextStyle(fontSize: 25, fontFamily: Ui.font),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                      // color: Colors.black,
                      ),
                  Container(
                      child: Row(
                    children: [
                      SizedBox(
                          width: 300,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder()),
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                              ),
                              items: _listCourse
                                  .map<DropdownMenuItem<Course>>((e) {
                                return DropdownMenuItem(
                                    child: Text(e.level!), value: e);
                              }).toList(),
                              value: _course,
                              isExpanded: true,
                              hint: Text("Классы"),
                              onChanged: (Course? newValue) {
                                setState(() {
                                  _course = newValue;
                                  if (_course != null && _subject != null) {
                                    getLevel(_course!.id.toString(),
                                        _subject!.id.toString());
                                  }
                                });
                              },
                            ),
                          )),
                      SizedBox(
                        width: 30,
                      ),
                      SizedBox(
                          width: 300,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder()),
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                              ),
                              items: _listSubject
                                  .map<DropdownMenuItem<Subject>>((e) {
                                return DropdownMenuItem(
                                    child: Text(e.name!), value: e);
                              }).toList(),
                              value: _subject,
                              isExpanded: true,
                              hint: Text("Предметы"),
                              onChanged: (Subject? newValue) {
                                setState(() {
                                  _subject = newValue;
                                  if (_course != null && _subject != null) {
                                    getLevel(_course!.id.toString(),
                                        _subject!.id.toString());
                                  }
                                });
                              },
                            ),
                          )),
                    ],
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: DataTable(
                    headingRowColor: MaterialStateProperty.all(Colors.grey),
                    columnSpacing:
                        MediaQuery.of(context).size.width > 800 ? 170 : 0,
                    headingTextStyle: TextStyle(color: Colors.white),
                    border: TableBorder.all(
                      width: 0.1,
                      // color:AppColors.secondaryColor,
                    ),
                    columns: [
                      DataColumn(label: Text("№")),
                      DataColumn(label: Text("Тема")),
                      DataColumn(label: Text("Курс")),
                      DataColumn(label: Text("Предмет")),
                      DataColumn(
                          label:
                              Text("Изменить", style: TextStyle(fontSize: 10))),
                      DataColumn(
                          label:
                              Text("Удалить", style: TextStyle(fontSize: 10))),
                    ],
                    rows: _listLevel.map((e) {
                      return DataRow(cells: [
                        DataCell(Text(e.level_id.toString())),
                        DataCell(Text(e.levelname!)),
                        DataCell(Text(e.course!.level!)),
                        DataCell(Text(e.subject!.name!)),
                        DataCell(Icon(Icons.edit), onTap: () {
                          // _groupEdu = e;
                          // showDialogWidget();
                        }),
                        DataCell(Icon(Icons.delete), onTap: () {
                          levelBloc.remove(e.level_id.toString()).then((value) {
                            setState(() {
                              if (_course != null && _subject != null) {
                                getLevel(_course!.id.toString(),
                                    _subject!.id.toString());
                              }
                            });
                          });
                        }),
                      ]);
                    }).toList(),
                  ))
                ],
              ));
        }
      },
    );
  }
}
