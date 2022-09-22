import 'package:educationdashboard/bloc/course_bloc.dart';
import 'package:educationdashboard/models/Course.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  Course? _course;
  StudentBloc? studentBloc;
  CourseBloc? courseBloc;

  void getAll() {
    courseBloc!.get().then((value) {
      _listCourse = value.map((e) => Course.fromJson(e)).toList();
    });
    studentBloc!.get().then((value) {
      _listStudent = value.map((e) => Student.fromJson(e)).toList();
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
    return Column(
      children: [
        Container(
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
                  // _groupEdu = null;
                  // _subject = null;
                  // showDialogWidget();
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
                        // _list = newValue!.groupSet!;
                      });
                    },
                  ),
                )),
            // Container(child: ,),
          ],
        )),
      ],
    );
  }
}
