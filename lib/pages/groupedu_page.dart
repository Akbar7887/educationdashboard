import 'package:date_field/date_field.dart';
import 'package:educationdashboard/bloc/course_bloc.dart';
import 'package:educationdashboard/bloc/edu_state.dart';
import 'package:educationdashboard/bloc/subject_bloc.dart';
import 'package:educationdashboard/models/GroupSet.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/edu_event.dart';
import '../bloc/groupbloc.dart';
import '../models/Course.dart';
import '../models/Subject.dart';
import '../models/ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

var formatter = DateFormat('dd-MM-yyyy');

class GroupEduPage extends StatefulWidget {
  const GroupEduPage({Key? key}) : super(key: key);

  @override
  State<GroupEduPage> createState() => _GroupEduPageState();
}

class _GroupEduPageState extends State<GroupEduPage> {
  List<GroupSet> _list = [];
  GroupSet? _groupEdu;
  List<Subject> _listSubject = [];
  late SubjectBloc? subjectBloc;
  Subject? _subject;
  TextEditingController _name = TextEditingController();
  DateTime? _selectedDate;
  final _globalKeyname = GlobalKey<FormState>();
  GroupBloc? groupBloc;
  DateFormat dateformat = DateFormat("yyyy-MM-ddThh:mm:ss.000+00:00");
  CourseBloc? courseBloc;

  // CourseBloc? _courseBloc;
  List<Course> _listCourse = [];
  Course? _course;

  void getAll() {
    subjectBloc!.getall().then((value) {
      if (value.isNotEmpty) {
        setState(() {
          _listSubject = value.map((e) => Subject.fromJson(e)).toList();
        });

        // if(_listSubject.length != 0){
        //   subject = _listSubject.first;
        // }
      }
    });
    // _courseBloc!.getall().then((value) {
    //   setState(() {
    //     if (value.isNotEmpty && _listCourse.length == 0) {
    //       _listCourse.addAll(value.map((e) => Course.fromJson(e)).toList());
    //       // if (_listCourse.isNotEmpty) {
    //       //   _course = _listCourse.first;
    //       // }
    //     }
    //
    //     //_course = _listCourse.first;
    //   });
    //
    // });
  }

  @override
  void initState() {
    super.initState();

    subjectBloc = BlocProvider.of<SubjectBloc>(context);
    groupBloc = BlocProvider.of<GroupBloc>(context);
    courseBloc = BlocProvider.of<CourseBloc>(context);
    getAll();
    // _subject = Subject();
    _groupEdu = GroupSet();
    _selectedDate = DateTime.now();
    // _course = Course();
  }

  @override
  void dispose() {
    super.dispose();
    subjectBloc!.close();
    groupBloc!.close();
    //_courseBloc!.close();
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
              _list = _course!.groupSet!;
            }
            _list.sort((a, b) => a.id!.compareTo(b.id!));

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(
            "Группы",
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
                  _groupEdu = null;
                  _subject = null;
                  showDialogWidget();
                },
                child: Text("Добавить"),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.indigoAccent)),
              ),
            ),
            SizedBox(
              width: 100,
            ),
            Container(
                width: 400,
                height: 70,
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
                        // _list.clear();
                        _list = newValue!.groupSet!;
                      });
                    },
                  ),
                )),
            // Container(child: ,),
          ],
        )),
        SizedBox(
          height: 10,
        ),
        Expanded(
            child: DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.grey),
          columnSpacing: MediaQuery.of(context).size.width > 800 ? 170 : 0,
          headingTextStyle: TextStyle(color: Colors.white),
          sortColumnIndex: 0,
          border: TableBorder.all(
            width: 0.1,
            // color:AppColors.secondaryColor,
          ),
          columns: [
            DataColumn(label: Text("id")),
            DataColumn(label: Text("Дата создание")),
            DataColumn(label: Text("Название группы")),
            DataColumn(label: Text("Предмет")),
            DataColumn(label: Text("Изменить", style: TextStyle(fontSize: 10))),
            DataColumn(label: Text("Удалить", style: TextStyle(fontSize: 10))),
          ],
          rows: _list.map((e) {
            return DataRow(
              cells: [
                DataCell(Text(e.id.toString())),
                DataCell(Text(formatter.format(DateTime.parse(e.createdate!)))),
                DataCell(Text(e.name!)),
                DataCell(Text(e.subject!.name!)),
                DataCell(Icon(Icons.edit), onTap: () {
                  _groupEdu = e;
                  showDialogWidget();
                }),
                DataCell(Icon(Icons.delete), onTap: () {
                  groupBloc!.remove(e.id.toString()).then((value) {
                    courseBloc!.add(EduLoadEvent());
                  });
                }),
              ],
            );
          }).toList(),
        ))
      ],
    );
  }

  Future<void> showDialogWidget() async {
    //TextEditingController _se = TextEditingController();

    if (_groupEdu != null) {
      _name.text = _groupEdu!.name!;
      _selectedDate = DateTime.parse(_groupEdu!.createdate!);
    } else {
      _name.text = "";
      _selectedDate = DateTime.now();
    }
    if (_listSubject.length != 0 && _groupEdu != null) {
      _subject = _listSubject
          .firstWhere((element) => element.id == _groupEdu!.subject!.id);
    } else {
      _subject = _listSubject.first;
    }
    return await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Группа'),
            content: SizedBox(
              width: 600,
              height: 400,
              child: Column(
                children: [
                  InputDecorator(
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      items: _listCourse.map<DropdownMenuItem<Course>>((e) {
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
                          _list = newValue!.groupSet!;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: DateTimeField(
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.black45),
                        errorStyle: TextStyle(color: Colors.redAccent),
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.event_note),
                        labelText: 'Дата создание',
                      ),
                      mode: DateTimeFieldPickerMode.date,
                      selectedDate: _selectedDate,
                      onDateSelected: (DateTime value) {
                        _selectedDate = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      child: _listSubject.length == 0
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : InputDecorator(
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
                                    child: Text(e.name!),
                                    value: e,
                                  );
                                }).toList(),
                                isExpanded: true,
                                hint: Text("Предмет"),
                                value: _subject,
                                onChanged: (Subject? newValue) {
                                  setState(() {
                                    _subject = newValue;
                                  });
                                },
                              ),
                            )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Form(
                      key: _globalKeyname,
                      child: TextFormField(
                        decoration:
                            InputDecoration(labelText: "Название группы"),
                        controller: _name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Просим заполнить название группы!";
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Сохранить'),
                onPressed: () {
                  if (_globalKeyname.currentState!.validate() == false) {
                    return;
                  }

                  if (_groupEdu == null) {
                    _groupEdu = GroupSet();
                  }
                  _groupEdu!.name = _name.text.trim();
                  _groupEdu!.subject = _subject;
                  String date = dateformat.format(_selectedDate!);
                  //String dateWithT = date.substring(0, 8) + 'T' + date.substring(8);
                  _groupEdu!.createdate = date;

                  groupBloc!
                      .save(_groupEdu!, "course_id", _course!.id.toString())
                      .then((value) {
                    // setState((){
                    //_listCourse.clear();

                    courseBloc!.add(EduLoadEvent());
                    // });
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
