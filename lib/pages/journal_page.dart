import 'package:educationdashboard/bloc/course_bloc.dart';
import 'package:educationdashboard/bloc/edu_event.dart';
import 'package:educationdashboard/bloc/groupbloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/edu_state.dart';
import '../bloc/student_bloc.dart';
import '../models/Course.dart';
import '../models/GroupSet.dart';
import '../models/Student.dart';
import '../models/ui.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({Key? key}) : super(key: key);

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  List<GroupSet> _listGroup = [];
  GroupSet? _group;
  List<Student> _listStudent = [];

  Student? _student;
  List<Course> _listCourse = [];
  Course? _course;
  final _globalkeyjournal = GlobalKey<FormState>();
  GroupBloc? _groupBloc;
  StudentBloc? _studentBloc;
  CourseBloc? _courseBloc;
  List<GroupSet> _listGroupDialog = [];
  GroupSet? _groupDialog;
  List<Course> _listCourseDialog = [];
  Course? _courseDialog;
  Student? _studentDialog;
  List<Student> _listStudentdialog = [];


  void getstudentbygroup(String id) {
    _studentBloc!.getbyid(id.toString()).then((value1) {
      setState(() {
        _listStudent = value1.map((e) => Student.fromJson(e)).toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _groupBloc = BlocProvider.of<GroupBloc>(context);
    _studentBloc = BlocProvider.of<StudentBloc>(context);
    _courseBloc = BlocProvider.of<CourseBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CourseBloc, EduState>(
        builder: (context, state) {
          if (state is EduEmtyState) {
            return Center(child: Text("No data!"));
          }
          if (state is EduLoadingState) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is CourseEduLoadedState) {
            _listCourse = state.loadedCourse;
            _listCourse.sort((a, b) => a.id!.compareTo(b.id!));

            if (_course != null) {
              _course = _listCourse
                  .firstWhere((element) => element.id == _course!.id);
            }

            return Container(
                alignment: Alignment.center,
                // padding: EdgeInsets.only(left: 20, right: 20),
                child: Card(
                    child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        width: double.maxFinite,
                        child: mainpage())));
          }

          if (state is EduErrorState) {
            return Center(
              child: Text("Сервер не работает!"),
            );
          }
          return SizedBox.shrink();
        },
        listener: (context, state) {});
  }

  Widget mainpage() {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(top: 10, left: 10),
              child: Text(
                "Журнал студентов",
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
                Expanded(
                    child: InputDecorator(
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                    items: _listCourse.map<DropdownMenuItem<Course>>((e) {
                      return DropdownMenuItem(child: Text(e.level!), value: e);
                    }).toList(),
                    value: _course,
                    isExpanded: true,
                    hint: Text("Классы"),
                    onChanged: (Course? newValue) {
                      setState(() {
                        _course = newValue;
                        if (_course != null) {
                          _listGroup = _course!.groupSet!;
                        }
                      });
                      if (_group != null && _listGroup.length != 0) {
                        _group = _listGroup
                            .firstWhere((element) => element.id == _group!.id);
                      }
                    },
                  ),
                )),
                SizedBox(
                  width: 50,
                ),
                Expanded(
                    child: InputDecorator(
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                    items: _listGroup.map<DropdownMenuItem<GroupSet>>((e) {
                      return DropdownMenuItem(child: Text(e.name!), value: e);
                    }).toList(),
                    value: _group,
                    isExpanded: true,
                    hint: Text("Группы"),
                    onChanged: (GroupSet? newValue) {
                      setState(() {
                        _group = newValue;
                        // _list.clear();
                      });
                      _studentBloc!
                          .getbyid(newValue!.id.toString())
                          .then((value1) {
                        setState(() {
                          _listStudent =
                              value1.map((e) => Student.fromJson(e)).toList();
                        });

                        if (_student != null && _listStudent.length != 0) {
                          _student = _listStudent.firstWhere(
                              (element) => element.id == _student!.id);
                        }
                      });
                    },
                  ),
                )),
                SizedBox(
                  width: 50,
                ),
                _group == null
                    ? Container()
                    : Expanded(
                        child: RichText(
                        text: TextSpan(
                            text: "Предмет:  ",
                            style: TextStyle(
                                fontSize: 20, fontFamily: Ui.textstyle),
                            children: [
                              TextSpan(
                                  text: _group!.subject!.name!,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: Ui.textstyle,
                                      fontWeight: FontWeight.bold))
                            ]),
                      ))
                // Container(child: ,),
              ],
            )),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.topLeft,
              child: ElevatedButton(
                onPressed: () {
                  // _groupDialog = null;
                  // _studentDialog = null;
                  // _courseDialog = null;
                  showDialogWidget(true);
                },
                child: Text("Добавить"),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.indigoAccent)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: _listStudent.length == 0
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        alignment: Alignment.topLeft,
                        child: DataTable(
                          headingRowColor:
                              MaterialStateProperty.all(Colors.grey),
                          headingTextStyle: TextStyle(color: Colors.white),
                          sortColumnIndex: 0,
                          border: TableBorder.all(
                            width: 0.1,
                            // color:AppColors.secondaryColor,
                          ),
                          columns: [
                            DataColumn(label: Text("id")),
                            DataColumn(label: Text("Студент")),
                            // DataColumn(
                            //     label: Text(
                            //   "Изменить",
                            // )),
                            DataColumn(
                                label: Text(
                              "Удалить",
                            )),
                          ],
                          rows: _listStudent.map((e) {
                            return DataRow(
                              cells: [
                                DataCell(Text(e.id.toString())),
                                DataCell(Text(e.name!)),
                                // DataCell(Icon(Icons.edit), onTap: () {
                                //   _student = e;
                                //   showDialogWidget(false);
                                // }),
                                DataCell(Icon(Icons.delete), onTap: () {
                                  _groupBloc!
                                      .addOrRemoveStudent(
                                          "groupedu/removestudent",
                                          _group!.id.toString(),
                                          e.id.toString())
                                      .then((value) {
                                    getstudentbygroup(_group!.id.toString());
                                  });
                                }),
                              ],
                            );
                          }).toList(),
                        )))
          ],
        ));
  }

  Future<void> showDialogWidget(bool newform) async {

    if (newform) {
      _groupDialog = null;
      _courseDialog = null;
      _studentDialog = null;
    } else {
      if (_listGroup.isNotEmpty) {
        _listGroupDialog = _listGroup;
        _groupDialog = _group;
      }
      if (_listCourse.isNotEmpty) {
        _listCourseDialog = _listCourse;
        _courseDialog = _course;
      }
    }
    _listGroupDialog = _listGroup;
    _listCourseDialog = _listCourse;
    // void getstudent() {
    //   _studentBloc!.get().then((value) {
    //     _listStudentdialog = value.map((e) => Student.fromJson(e)).toList();
    //   });
    // }

    return await showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Добавление студента к группе!'),
            content: FutureBuilder(
                future: _studentBloc!.get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (_listStudentdialog.isEmpty) {
                      _listStudentdialog = snapshot.data!
                          .map((e) => Student.fromJson(e))
                          .toList();
                    }
                    if (!newform) {
                      // setState((){
                      _studentDialog = _listStudentdialog
                          .firstWhere((element) => element.id == _student!.id);
                      // });

                    }
                    return SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height / 2,
                        child: Form(
                          key: _globalkeyjournal,
                          child: Column(
                            children: [
                              Container(
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
                                  items: _listCourseDialog
                                      .map<DropdownMenuItem<Course>>((e) {
                                    return DropdownMenuItem(
                                        child: Text(e.level!), value: e);
                                  }).toList(),
                                  value: _courseDialog,
                                  isExpanded: true,
                                  hint: Text("Класс"),
                                  onChanged: (Course? newValue) {
                                    setState(() {
                                      _courseDialog = newValue;
                                      // _list.clear();
                                      setState(() {
                                        _listGroupDialog = newValue!.groupSet!;
                                      });
                                    });
                                  },
                                ),
                              )),
                              Container(
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
                                  items: _listGroupDialog
                                      .map<DropdownMenuItem<GroupSet>>((e) {
                                    return DropdownMenuItem(
                                        child: Text(e.name!), value: e);
                                  }).toList(),
                                  value: _groupDialog,
                                  isExpanded: true,
                                  hint: Text("Группы"),
                                  onChanged: (GroupSet? newValue) {
                                    setState(() {
                                      _groupDialog = newValue;
                                      // _list.clear();
                                      // setState(() {
                                      //   _listStudentdialog =
                                      //       newValue!.students!;
                                      // });
                                    });
                                  },
                                ),
                              )),
                              Container(
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
                                  items: _listStudentdialog
                                      .map<DropdownMenuItem<Student>>((e) {
                                    return DropdownMenuItem(
                                        child: Text(e.name!), value: e);
                                  }).toList(),
                                  value: _studentDialog,
                                  isExpanded: true,
                                  hint: Text("Студент"),
                                  onChanged: (Student? newValue) {
                                   changeStudent(newValue);
                                  },
                                ),
                              )),
                            ],
                          ),
                        ));
                  }
                }),
            actions: <Widget>[
              TextButton(
                  child: Text('Сохранить'),
                  onPressed: () {
                    if (!_globalkeyjournal.currentState!.validate()) {
                      return;
                    }
                    if (_groupDialog == null || _studentDialog == null) {
                      SnackBar snackbar = SnackBar(
                        content: Text("Просим заполнить все поля !"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      return;
                    }

                    _groupBloc!
                        .addOrRemoveStudent(
                            "groupedu/addstudent",
                            _groupDialog!.id.toString(),
                            _studentDialog!.id.toString())
                        .then((value) {
                      GroupSet groupset = GroupSet.fromJson(value);

                      getstudentbygroup(groupset.id.toString());

                      Navigator.of(dialogContext).pop(); //
                    });
                  }),
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

  void changeStudent(Student? newValue) {
    setState(() {
      print(newValue!.name);
      _studentDialog = newValue;
    });
  }
}
