import 'package:educationdashboard/bloc/TaskBloc.dart';
import 'package:educationdashboard/models/Task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/course_bloc.dart';
import '../bloc/level_bloc.dart';
import '../bloc/subject_bloc.dart';
import '../models/Course.dart';
import '../models/Level.dart';
import '../models/Subject.dart';
import '../models/ui.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<Level> _listLevel = [];
  Level? _level;
  List<Course> _listCourse = [];
  Course? _course;
  List<Subject> _listSubject = [];
  Subject? _subject;
  List<Task> _listTask = [];
  Task? _task;
  int _anssh = 0;

  late CourseBloc courseBloc;
  late SubjectBloc subjectBloc;
  late LevelBloc levelBloc;
  late TaskBloc taskBloc;
  final _globalKeyTask = GlobalKey<FormState>();

  // void get_anssh() {
  //   _anssh = false;
  //   if (_task!.ans_A) {
  //     _anssh = _task!.ans_A;
  //   } else if (_task!.ans_B) {
  //     _anssh = _task!.ans_B;
  //   } else if (_task!.ans_C) {
  //     _anssh = _task!.ans_C;
  //   } else if (_task!.ans_D) {
  //     _anssh = _task!.ans_D;
  //   } else if (_task!.ans_E) {
  //     _anssh = _task!.ans_E;
  //   }
  // }

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

  void getTasks() {
    if (_level != null) {
      taskBloc.getBylevelId(_level!.level_id.toString()).then((value) {
        _listTask = value.map((e) => Task.fromJson(e)).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    courseBloc = BlocProvider.of<CourseBloc>(context);
    subjectBloc = BlocProvider.of<SubjectBloc>(context);
    levelBloc = BlocProvider.of<LevelBloc>(context);
    taskBloc = BlocProvider.of<TaskBloc>(context);
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
          // if (_level != null) {
          //   _listTask = _level!.taskList!;
          // }
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
                        height: 70,
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            // _course = null;
                            // _subject = null;
                            // _level = null;
                            _task = null;
                            if (_level == null) {
                              final snackbar = SnackBar(
                                content: Text("Просим выбирать Тему!"),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackbar);
                              return;
                            }
                            showDialogWidget();
                          },
                          child: Text("Добавить"),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.indigoAccent)),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                          width: 200,
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
                          width: 200,
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
                      SizedBox(
                        width: 30,
                      ),
                      SizedBox(
                          width: 300,
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
                              items:
                                  _listLevel.map<DropdownMenuItem<Level>>((e) {
                                return DropdownMenuItem(
                                    child: Text(e.levelname!), value: e);
                              }).toList(),
                              value: _level,
                              isExpanded: true,
                              hint: Text("Темы"),
                              onChanged: (Level? newValue) {
                                setState(() {
                                  _level = newValue;
                                  getTasks();
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
                      child: SingleChildScrollView(
                          child: _listTask.length == 0
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : DataTable(
                                  dataRowHeight: 250,
                                  headingRowColor:
                                      MaterialStateProperty.all(Colors.grey),
                                  // columnSpacing:
                                  //     MediaQuery.of(context).size.width > 800 ? 200 : 0,
                                  headingTextStyle:
                                      TextStyle(color: Colors.white),

                                  border: TableBorder.all(
                                    width: 0.1,
                                    // color:AppColors.secondaryColor,
                                  ),
                                  columns: [
                                    DataColumn(label: Text("№")),
                                    DataColumn(label: Text("Задание")),
                                    DataColumn(label: Text("Ответы")),
                                    DataColumn(label: Text("Показать")),
                                    DataColumn(label: Text("Изменить")),
                                    DataColumn(label: Text("Удалить")),
                                  ],
                                  rows: _listTask.map((e) {
                                    bool _ans = false;

                                    if (e.ans_A!) {
                                      _ans = e.ans_A!;
                                    } else if (e.ans_B!) {
                                      _ans = e.ans_B!;
                                    } else if (e.ans_C!) {
                                      _ans = e.ans_C!;
                                    } else if (e.ans_D!) {
                                      _ans = e.ans_D!;
                                    } else if (e.ans_E!) {
                                      _ans = e.ans_E!;
                                    }

                                    return DataRow(cells: [
                                      DataCell(Text((_listTask.indexOf(e) + 1)
                                          .toString())),
                                      DataCell(SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          child: Text(e.taskname!))),
                                      DataCell(SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          child: Column(children: [
                                            Container(
                                                child: Row(
                                              children: [
                                                Container(
                                                    child: Text(
                                                  "A",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                                Expanded(
                                                    child: RadioListTile<bool>(
                                                  title: Text(
                                                    '${e.ans_A_name!}',
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                  value: e.ans_A!,
                                                  groupValue: _ans,
                                                  onChanged: (bool? anw) {
                                                    setState(() {
                                                      _ans = anw!;
                                                    });
                                                  },
                                                )),
                                              ],
                                            )),
                                            Container(
                                                child: Row(
                                              children: [
                                                Container(
                                                    child: Text(
                                                  "B",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                                Expanded(
                                                    child: RadioListTile<bool>(
                                                  title: Text(
                                                    '${e.ans_B_name!}',
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                  value: e.ans_B!,
                                                  groupValue: _ans,
                                                  onChanged: (bool? anw) {
                                                    setState(() {
                                                      _ans = anw!;
                                                    });
                                                  },
                                                )),
                                              ],
                                            )),
                                            Container(
                                                child: Row(
                                              children: [
                                                Container(
                                                    child: Text(
                                                  "C",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                                Expanded(
                                                    child: RadioListTile<bool>(
                                                  title: Text(
                                                    '${e.ans_C_name!}',
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                  value: e.ans_C!,
                                                  groupValue: _ans,
                                                  onChanged: (bool? anw) {
                                                    setState(() {
                                                      _ans = anw!;
                                                    });
                                                  },
                                                )),
                                              ],
                                            )),
                                            Container(
                                                child: Row(
                                              children: [
                                                Container(
                                                    child: Text(
                                                  "D",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                                Expanded(
                                                    child: RadioListTile<bool>(
                                                  title: Text(
                                                    '${e.ans_D_name!}',
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                  value: e.ans_D!,
                                                  groupValue: _ans,
                                                  onChanged: (bool? anw) {
                                                    setState(() {
                                                      _ans = anw!;
                                                    });
                                                  },
                                                )),
                                              ],
                                            )),
                                            Container(
                                                child: Row(
                                              children: [
                                                Container(
                                                    child: Text(
                                                  "E",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                                Expanded(
                                                    child: RadioListTile<bool>(
                                                  title: Text(
                                                    '${e.ans_E_name!}',
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                  value: e.ans_E!,
                                                  groupValue: _ans,
                                                  onChanged: (bool? anw) {
                                                    setState(() {
                                                      _ans = anw!;
                                                    });
                                                  },
                                                )),
                                              ],
                                            )),
                                          ]))),
                                      DataCell(Checkbox(
                                        value: e.show,
                                        onChanged: (bool? value) {
                                          taskBloc
                                              .saveShow("task/save/show",
                                                  e.id.toString(), value!)
                                              .then((boolvalue) {
                                            setState(() {

                                             e.show = value;
                                              //getTasks();
                                            });
                                          });
                                        },
                                      )),
                                      DataCell(Icon(Icons.edit), onTap: () {
                                        _task = e;
                                        showDialogWidget();
                                      }),
                                      DataCell(Icon(Icons.delete), onTap: () {
                                        taskBloc
                                            .remove(e.id.toString())
                                            .then((value) {
                                          setState(() {
                                            getTasks();
                                          });
                                        });
                                      }),
                                    ]);
                                  }).toList(),
                                )))
                ],
              ));
        }
      },
    );
  }

  Future<void> showDialogWidget() async {
    TextEditingController _taskname = TextEditingController();
    TextEditingController _anwA = TextEditingController();
    TextEditingController _anwB = TextEditingController();
    TextEditingController _anwC = TextEditingController();
    TextEditingController _anwD = TextEditingController();
    TextEditingController _anwE = TextEditingController();

    if (_task != null) {
      _taskname.text = _task!.taskname!;
      _anssh = 0;
      if (_task!.ans_A!) {
        _anssh = 0;
      } else if (_task!.ans_B!) {
        _anssh = 1;
      } else if (_task!.ans_C!) {
        _anssh = 2;
      } else if (_task!.ans_D!) {
        _anssh = 3;
      } else if (_task!.ans_E!) {
        _anssh = 4;
      }

      _anwA.text = _task!.ans_A_name!;
      _anwB.text = _task!.ans_B_name!;
      _anwC.text = _task!.ans_C_name!;
      _anwD.text = _task!.ans_D_name!;
      _anwE.text = _task!.ans_E_name!;
    }

    return await showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Задание'),
            content: Form(
              key: _globalKeyTask,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 2,
                child: Column(
                  children: [
                    Container(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Вопрос"),
                        controller: _taskname,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Просим заполнить Вопрос!";
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        child: Row(
                      children: [
                        Container(
                            child: Text(
                          "A",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        Expanded(
                          child: RadioListTile<int>(
                            title: TextFormField(
                              controller: _anwA,
                              style: TextStyle(fontSize: 15),
                            ),
                            value: 0,
                            groupValue: _anssh,
                            onChanged: (int? anw) {
                              setState(() {
                                print(anw);
                                _anssh = anw!;
                              });
                            },
                          ),
                        ),
                      ],
                    )),
                    Container(
                        child: Row(
                      children: [
                        Container(
                            child: Text(
                          "B",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        Expanded(
                          child: RadioListTile<int>(
                            title: TextFormField(
                              controller: _anwB,
                              style: TextStyle(fontSize: 15),
                            ),
                            value: 1,
                            groupValue: _anssh,
                            // selected: _task!.ans_B,
                            onChanged: (int? anw) {
                              setState(() {
                                print(anw);
                                _anssh = anw!;
                              });
                            },
                          ),
                        ),
                      ],
                    )),
                    Container(
                        child: Row(
                      children: [
                        Container(
                            child: Text(
                          "C",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        Expanded(
                          child: RadioListTile<int>(
                            title: TextFormField(
                              controller: _anwC,
                              style: TextStyle(fontSize: 15),
                            ),
                            value: 2,
                            // selected: _task!.ans_C,

                            groupValue: _anssh,
                            onChanged: (int? anw) {
                              setState(() {
                                print(anw);
                                _anssh = anw!;
                              });
                            },
                          ),
                        ),
                      ],
                    )),
                    Container(
                        child: Row(
                      children: [
                        Container(
                            child: Text(
                          "D",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        Expanded(
                          child: RadioListTile<int>(
                            title: TextFormField(
                              controller: _anwD,
                              style: TextStyle(fontSize: 15),
                            ),
                            value: 3,
                            // selected: _task!.ans_D,
                            groupValue: _anssh,
                            onChanged: (int? anw) {
                              setState(() {
                                print(anw);
                                _anssh = anw!;
                              });
                            },
                          ),
                        ),
                      ],
                    )),
                    Container(
                        child: Row(
                      children: [
                        Container(
                            child: Text(
                          "E",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        Expanded(
                          child: RadioListTile<int>(
                            title: TextFormField(
                              controller: _anwE,
                              style: TextStyle(fontSize: 15),
                            ),
                            value: 4,
                            // selected: _task!.ans_E,
                            groupValue: _anssh,
                            onChanged: (int? anw) {
                              setState(() {
                                print(anw);
                                _anssh = anw!;
                              });
                            },
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                  child: Text('Сохранить'),
                  onPressed: () {
                    if (_globalKeyTask.currentState!.validate() == false) {
                      return;
                    }
                    if (_task == null) {
                      _task = Task();
                    }
                    _task!.ans_A = _anssh == 0 ? true : false;
                    _task!.ans_B = _anssh == 1 ? true : false;
                    _task!.ans_C = _anssh == 2 ? true : false;
                    _task!.ans_D = _anssh == 3 ? true : false;
                    _task!.ans_E = _anssh == 4 ? true : false;
                    _task!.taskname = _taskname.text;
                    _task!.ans_A_name = _anwA.text.trim();
                    _task!.ans_B_name = _anwB.text.trim();
                    _task!.ans_C_name = _anwC.text.trim();
                    _task!.ans_D_name = _anwD.text.trim();
                    _task!.ans_E_name = _anwE.text.trim();

                    taskBloc
                        .save(_task!, _level!.level_id.toString())
                        .then((value) {
                      setState(() {
                        getTasks();
                      });
                      Navigator.of(dialogContext).pop(); // D
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
}
