import 'package:educationdashboard/bloc/course_bloc.dart';
import 'package:educationdashboard/models/Course.dart';
import 'package:educationdashboard/models/GroupSet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';


import '../bloc/student_bloc.dart';
import '../models/Student.dart';
import '../models/ui.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({Key? key}) : super(key: key);

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  List<Student> _listStudent = [];
  List<Course> _listCourse = [];
  List<GroupSet> _listGroup = [];
  Course? _course;
  GroupSet? _groupSet;
  StudentBloc? studentBloc;
  CourseBloc? courseBloc;
  var formatter = DateFormat('dd-MM-yyyy');
  final _globalKey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _adress = TextEditingController();

  void getAll() {
    // courseBloc!.get().then((value) {
    //   _listCourse = value.map((e) => Course.fromJson(e)).toList();
    // });
    studentBloc!.get().then((value) {
      _listStudent = value.map((e) => Student.fromJson(e)).toList();
      if (_groupSet != null) {
        _listStudent = _listStudent
            .where((element) => element.groupSet!.id == _groupSet!.id)
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    studentBloc = BlocProvider.of<StudentBloc>(context);
    courseBloc = BlocProvider.of<CourseBloc>(context);
    getAll();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: courseBloc!.get(),
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
              _listGroup = _listCourse.first.groupSet!;
            }

            // if(_groupSet != null){
            //
            // }

            return Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Студенты",
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
                        Container(
                          width: 200,
                          height: 50,
                          // alignment: Alignment.topLeft,
                          child: ElevatedButton(
                            onPressed: () {
                              _course = null;
                              _groupSet = null;
                              // _subject = null;
                              showDialogWidget();
                            },
                            child: Text("Добавить"),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.indigoAccent)),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                        ),
                        Container(
                            width: 400,
                            height: 70,
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
                                    _listGroup = newValue!.groupSet!;
                                    _groupSet = null;
                                    // _list.clear();
                                    // _list = newValue!.groupSet!;
                                  });
                                },
                              ),
                            )),
                        SizedBox(
                          width: 100,
                        ),
                        Container(
                            width: 400,
                            height: 70,
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
                                items: _listGroup
                                    .map<DropdownMenuItem<GroupSet>>((e) {
                                  return DropdownMenuItem(
                                      child: Text(e.name!), value: e);
                                }).toList(),
                                value: _groupSet,
                                isExpanded: true,
                                hint: Text("Группы"),
                                onChanged: (GroupSet? newValue) {
                                  setState(() {
                                    _groupSet = newValue;
                                    getAll();
                                  });
                                },
                              ),
                            )),

                        // Container(child: ,),
                      ],
                    )),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(child: dateTable()),
                  ],
                ));
          }
        });
  }

  Widget dateTable() {
    return DataTable(
      headingRowColor: MaterialStateProperty.all(Colors.grey),
      //columnSpacing: 80,

      headingTextStyle: TextStyle(color: Colors.white),
      sortColumnIndex: 1,
      columns: [
        DataColumn(label: Text("id")),
        DataColumn(
            label: Text("Дата принятие"),
            onSort: (columnidx, sortAscending) {
              setState(() {
                _listStudent
                    .sort((a, b) => a.createdate!.compareTo(b.createdate!));
              });
            }),

        DataColumn(label: Text("ФИО")),

        DataColumn(label: Text("Паспорт")),
        DataColumn(label: Text("Дата рождение")),
        DataColumn(label: Text("Курс")),
        DataColumn(label: Text("Группа")),
        DataColumn(label: Text("Регион")),
        DataColumn(label: Text("Адрес")),
        // DataColumn(label: Text("Предмет")),
        DataColumn(label: Text("Изменить", style: TextStyle(fontSize: 10))),
        DataColumn(label: Text("Удалить", style: TextStyle(fontSize: 10))),
      ],
      rows: _listStudent.map((e) {
        return DataRow(
          cells: [
            DataCell(Text(e.id.toString())),
            DataCell(Text(formatter.format(DateTime.parse(e.createdate!)))),
            DataCell(Text(e.name!)),
            DataCell(Text(e.passportId!)),
            DataCell(Text(e.birthday!)),
            DataCell(Text(e.course!.level!)),
            DataCell(Text(e.groupSet!.name!)),
            DataCell(Text(e.region!.name!)),
            DataCell(Text(e.adress!)),
            DataCell(Icon(Icons.edit), onTap: () {
              // _groupEdu = e;
              // showDialogWidget();
            }),
            DataCell(Icon(Icons.delete), onTap: () {
              // groupBloc!.remove(e.id.toString()).then((value) {
              //   courseBloc!.add(EduLoadEvent());
              // });
            }),
          ],
        );
      }).toList(),
    );
  }

  Future<void> showDialogWidget() async {
    //TextEditingController _se = TextEditingController();

    return await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Группа'),
            content: Form(
              key: _globalKey,
              child: SizedBox(
                width: 800,
                height: 400,
                child: Column(
                  children: [
                    Container(
                        child: Row(
                      children: [
                        Expanded(
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
                            items:
                                _listCourse.map<DropdownMenuItem<Course>>((e) {
                              return DropdownMenuItem(
                                  child: Text(e.level!), value: e);
                            }).toList(),
                            value: _course,
                            isExpanded: true,
                            hint: Text("Классы"),
                            onChanged: (Course? newValue) {
                              setState(() {
                                _course = newValue;
                                // _list.clear();
                                // _list = newValue!.groupSet!;
                              });
                            },
                          ),
                        )),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
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
                            items:
                                _listGroup.map<DropdownMenuItem<GroupSet>>((e) {
                              return DropdownMenuItem(
                                  child: Text(e.name!), value: e);
                            }).toList(),
                            value: _groupSet,
                            isExpanded: true,
                            hint: Text("Группы"),
                            onChanged: (GroupSet? newValue) {
                              setState(() {
                                _groupSet = newValue;
                                getAll();
                              });
                            },
                          ),
                        )),
                      ],
                    )),
                    Container(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "ФИО студента"),
                        controller: _name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Просим заполнить ФИО!";
                          }
                        },
                      ),
                    ),

                    Container(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Адрес"),
                        controller: _adress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Просим заполнить Адрес!";
                          }
                        },
                      ),
                    ),

                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Сохранить'),
                onPressed: () {

                  if (_globalKey.currentState!.validate() == false) {
                    return;
                  }
                },
              ),
              TextButton(
                child: Text('Отмена'),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),
            ],
          );
        });
      },
    );
  }
}
