import 'package:date_field/date_field.dart';
import 'package:educationdashboard/bloc/course_bloc.dart';
import 'package:educationdashboard/bloc/region_bloc.dart';
import 'package:educationdashboard/models/Course.dart';
import 'package:educationdashboard/models/GroupSet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/student_bloc.dart';
import '../models/Region.dart';
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
  List<Region> _listRegion = [];
  Region? _region;
  Course? _course;
  GroupSet? _groupSet;
  Student? student;
  StudentBloc? studentBloc;
  CourseBloc? courseBloc;
  var formatter = DateFormat('dd-MM-yyyy');
  final _globalKey = GlobalKey<FormState>();
  RegionBloc? regionBloc;
  TextEditingController _name = TextEditingController();
  TextEditingController _adress = TextEditingController();
  TextEditingController _passportid = TextEditingController();
  DateFormat dateformat = DateFormat("yyyy-MM-ddThh:mm:ss.000+00:00");
  DateTime? _createDate;
  DateTime? _exitDate;
  DateTime? _birthday;

  void getStudent() {
    studentBloc!.get().then((value) {
      _listStudent = value.map((e) => Student.fromJson(e)).toList();
      if (_groupSet != null) {
        _listStudent = _listStudent
            .where((element) => element.groupSet!.id == _groupSet!.id)
            .toList();
      }
    });
  }

  void getRegion() {
    regionBloc!.get().then((value) {
      _listRegion = value.map((e) => Region.fromJson(e)).toList();
      _listRegion.sort((a, b) => a.id!.compareTo(b.id!));
    });
  }

  @override
  void initState() {
    super.initState();
    studentBloc = BlocProvider.of<StudentBloc>(context);
    courseBloc = BlocProvider.of<CourseBloc>(context);
    regionBloc = BlocProvider.of(context);
    getStudent();
    getRegion();
    _createDate = DateTime.now();
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
                        height: 70,
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                width: 120,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _course = null;
                                    _groupSet = null;
                                    // _subject = null;
                                    showDialogWidget();
                                  },
                                  child: Text("Добавить"),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.indigoAccent)),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
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
                                    getStudent();
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
      border: TableBorder.all(
        width: 0.1,
        // color:AppColors.secondaryColor,
      ),
      showBottomBorder: true,
      headingTextStyle: TextStyle(color: Colors.white),
      sortColumnIndex: 1,
      columnSpacing: MediaQuery.of(context).size.width > 800 ? 120 : 0,
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
        DataColumn(label: Text("ФИО", style: TextStyle(fontSize: 10))),
        DataColumn(label: Text("Курс", style: TextStyle(fontSize: 10))),
        DataColumn(label: Text("Группа", style: TextStyle(fontSize: 10))),
        DataColumn(label: Text("Регион", style: TextStyle(fontSize: 10))),
        DataColumn(label: Text("Дата ухода", style: TextStyle(fontSize: 10))),
        DataColumn(label: Text("Изменить", style: TextStyle(fontSize: 10))),
        DataColumn(label: Text("Удалить", style: TextStyle(fontSize: 10))),
      ],
      rows: _listStudent.map((e) {
        return DataRow(
          cells: [
            DataCell(Text(e.id.toString())),
            DataCell(Text(e.createdate == null
                ? ""
                : formatter.format(DateTime.parse(e.createdate!)))),
            DataCell(Text(e.name!)),
            DataCell(Text(e.course!.level!)),
            DataCell(Text(e.groupSet!.name!)),
            DataCell(Text(e.region!.name!)),
            DataCell(Text(e.exitdate == null
                ? ""
                : formatter.format(DateTime.parse(e.exitdate!)))),
            DataCell(Icon(Icons.edit), onTap: () {
              // _course = e.course;
              // _groupSet = e.groupSet;
              student = e;
              showDialogWidget();
            }),
            DataCell(Icon(Icons.delete), onTap: () {
              studentBloc!.remove(e.id.toString()).then((value) {
                setState(() {
                  studentBloc!.get().then((value) {
                    _listStudent =
                        value.map((e) => Student.fromJson(e)).toList();
                    if (_groupSet != null) {
                      _listStudent = _listStudent
                          .where((element) =>
                      element.groupSet!.id == _groupSet!.id)
                          .toList();
                    }
                  });
                });
              });
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
    if (student != null) {
      _course = _listCourse
          .where((element) => element.id == student!.course!.id!)
          .first;
      _adress.text = student!.adress!;
      _region = _listRegion
          .where((element) => element.id == student!.region!.id)
          .first;
      _name.text = student!.name!;
      _passportid.text = student!.passportId!;
      _listGroup = _course!.groupSet!;
      _groupSet = _listGroup
          .where((element) => element.id == student!.groupSet!.id)
          .first;
    }
    //TextEditingController _se = TextEditingController();

    return await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Студент'),
            content: Form(
              key: _globalKey,
              child: SizedBox(
                width: 800,
                height: 1000,
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
                            validator: (value) {
                              if (value == null) {
                                return "Просим заполнить Группу!";
                              }
                            },
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
                                _listGroup = _course!.groupSet!;
                                _groupSet = null;
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
                            validator: (value) {
                              if (value == null) {
                                return "Просим заполнить Группу!";
                              }
                            },
                            value: _groupSet,
                            isExpanded: true,
                            hint: Text("Группы"),
                            onChanged: (GroupSet? newValue) {
                              setState(() {
                                _groupSet = newValue;
                                getStudent();
                              });
                            },
                          ),
                        )),
                      ],
                    )),
                    SizedBox(
                      height: 20,
                    ),
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
                        decoration:
                            InputDecoration(labelText: "Паспортные данные"),
                        controller: _passportid,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Просим заполнить Паспортные данные!";
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: DateTimeField(
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Colors.black45),
                          errorStyle: TextStyle(color: Colors.redAccent),
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.event_note),
                          labelText: 'День рождения',
                        ),
                        mode: DateTimeFieldPickerMode.date,
                        selectedDate: _birthday,
                        onDateSelected: (DateTime value) {
                          setState(() {
                            _birthday = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: DateTimeField(
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Colors.black45),
                                errorStyle: TextStyle(color: Colors.redAccent),
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.event_note),
                                labelText: 'Дата создание',
                              ),
                              mode: DateTimeFieldPickerMode.date,
                              selectedDate: _createDate,
                              onDateSelected: (DateTime value) {
                                setState(() {
                                  _createDate = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: DateTimeField(
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Colors.black45),
                                errorStyle: TextStyle(color: Colors.redAccent),
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.event_note),
                                labelText: 'Дата окончание',
                              ),
                              mode: DateTimeFieldPickerMode.date,
                              selectedDate: _exitDate,
                              onDateSelected: (DateTime value) {
                                setState(() {
                                  _exitDate = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<Region>(
                              validator: (value) {
                                if (value == null) {
                                  return "Просим выбирать Регион!";
                                }
                              },
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                              ),
                              items: _listRegion
                                  .map<DropdownMenuItem<Region>>((e) {
                                return DropdownMenuItem(
                                    child: Text(e.name!), value: e);
                              }).toList(),
                              value: _region,
                              isExpanded: true,
                              hint: Text("Регион"),
                              onChanged: (Region? newValue) {
                                setState(() {
                                  _region = newValue;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
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
                    )
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
                  if (student == null) {
                    student = Student();
                  }
                  student!.groupSet = _groupSet;
                  if (_createDate != null) {
                    student!.createdate = dateformat.format(_createDate!);
                  }
                  if (_birthday != null) {
                    student!.birthday = dateformat.format(_birthday!);
                  }
                  if (_exitDate != null) {
                    student!.exitdate = dateformat.format(_exitDate!);
                  }
                  student!.name = _name.text.trim();
                  student!.passportId = _passportid.text.trim();
                  student!.adress = _adress.text.trim();
                  student!.region = _region;
                  student!.course = _course;

                  studentBloc!.save(student!).then((value) {
                    setState(() {
                      studentBloc!.get().then((value) {
                        _listStudent =
                            value.map((e) => Student.fromJson(e)).toList();
                        if (_groupSet != null) {
                          _listStudent = _listStudent
                              .where((element) =>
                                  element.groupSet!.id == _groupSet!.id)
                              .toList();
                        }
                      });
                    });
                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  });
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
