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

  // List<Course> _listCourse = [];
  // List<GroupSet> _listGroup = [];
  List<Region> _listRegion = [];
  Region? _region;

  // Course? _course;
  // GroupSet? _groupSet;
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

  Future<void> getStudent() async {
    await studentBloc!.get().then((value) {
      setState(() {
        _listStudent = value.map((e) => Student.fromJson(e)).toList();
      });
      // if (_groupSet != null) {
      //   // _listStudent = _listStudent
      //   //     .where((element) => element.groupSet!.id == _groupSet!.id)
      //   //     .toList();
      // }
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
    // getStudent();
    getRegion();
    _createDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: studentBloc!.get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // if (_listStudent.isEmpty) {
            _listStudent =
                snapshot.data!.map((e) => Student.fromJson(e)).toList();

            // }

            return Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "????????????????",
                        style: TextStyle(fontSize: 25, fontFamily: Ui.font),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                        // color: Colors.black,
                        ),
                    SizedBox(
                      height: 30,
                      width: 120,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialogWidget();
                        },
                        child: Text("????????????????"),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.indigoAccent)),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                        child: _listStudent.length == 0
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : dateTable()),
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
      // columnSpacing: MediaQuery.of(context).size.width > 800 ? 120 : 0,
      columns: [
        DataColumn(label: Text("id")),
        DataColumn(
            label: Text("???????? ????????????????", style: TextStyle(fontSize: 10)),
            onSort: (columnidx, sortAscending) {
              setState(() {
                _listStudent
                    .sort((a, b) => a.createdate!.compareTo(b.createdate!));
              });
            }),
        DataColumn(label: Text("??????", style: TextStyle(fontSize: 10))),
        // DataColumn(label: Text("????????", style: TextStyle(fontSize: 10))),
        // DataColumn(label: Text("????????????", style: TextStyle(fontSize: 10))),
        DataColumn(label: Text("????????????", style: TextStyle(fontSize: 10))),
        DataColumn(label: Text("???????? ??????????", style: TextStyle(fontSize: 10))),
        DataColumn(label: Text("????????????????", style: TextStyle(fontSize: 10))),
        DataColumn(label: Text("??????????????", style: TextStyle(fontSize: 10))),
      ],
      rows: _listStudent.map((e) {
        return DataRow(
          cells: [
            DataCell(Text(e.id.toString())),
            DataCell(Text(e.createdate == null
                ? ""
                : formatter.format(DateTime.parse(e.createdate!)))),
            DataCell(Text(e.name!)),
            // DataCell(Text(e.course!.level!)),
            // DataCell(Text(e.groupSet!.name!)),
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
                    getStudent();
                    // if (_groupSet != null) {
                    //   _listStudent = _listStudent
                    //       .where((element) =>
                    //           element.groupSet!.id == _groupSet!.id)
                    //       .toList();
                    // }
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
      _adress.text = student!.adress!;
      _region = _listRegion
          .where((element) => element.id == student!.region!.id)
          .first;
      _name.text = student!.name!;
      _passportid.text = student!.passportId!;
      // _groupSet = _listGroup
      //     .where((element) => element.id == student!.groupSet!.id)
      //     .first;
    }
    //TextEditingController _se = TextEditingController();

    return await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('??????????????'),
            content: Form(
              key: _globalKey,
              child: SizedBox(
                width: 800,
                height: 1000,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "?????? ????????????????"),
                        controller: _name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "???????????? ?????????????????? ??????!";
                          }
                        },
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        decoration:
                            InputDecoration(labelText: "???????????????????? ????????????"),
                        controller: _passportid,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "???????????? ?????????????????? ???????????????????? ????????????!";
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
                          labelText: '???????? ????????????????',
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
                                labelText: '???????? ????????????????',
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
                                labelText: '???????? ??????????????????',
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
                                  return "???????????? ???????????????? ????????????!";
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
                              hint: Text("????????????"),
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
                              decoration: InputDecoration(labelText: "??????????"),
                              controller: _adress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "???????????? ?????????????????? ??????????!";
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
                child: Text('??????????????????'),
                onPressed: () {
                  if (_globalKey.currentState!.validate() == false) {
                    return;
                  }
                  if (student == null) {
                    student = Student();
                  }
                  // student!.groupSet = _groupSet;
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

                  studentBloc!.save(student!).then((value) {
                    setState(() {
                      getStudent();
                    });
                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  });
                },
              ),
              TextButton(
                child: Text('????????????'),
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
