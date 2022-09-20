import 'package:date_field/date_field.dart';
import 'package:educationdashboard/bloc/edu_state.dart';
import 'package:educationdashboard/bloc/subject_bloc.dart';
import 'package:educationdashboard/models/GroupEdu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/groupbloc.dart';
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
  List<GroupEdu> _list = [];
  late GroupEdu? _groupEdu;
  List<Subject> _listSubject = [];
  late SubjectBloc subjectBloc;

  void getAll() {
    subjectBloc.getall().then((value) {
      setState(() {
        if(value!=null){
          _listSubject = value.map((e) => Subject.fromJson(e)).toList();
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    subjectBloc = BlocProvider.of<SubjectBloc>(context);
    getAll();

  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupBloc, EduState>(
        builder: (context, state) {
          if (state is EduEmtyState) {
            return Center(child: Text("No data!"));
          }
          if (state is EduLoadingState) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is GroupEduLoadedSatet) {
            _list = state.loadedGroupEdu;
            return Container(
                alignment: Alignment.center,
                // padding: EdgeInsets.only(left: 20, right: 20),
                child: Card(
                    child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        width: double.maxFinite,
                        child: main())));
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

  Widget main() {
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
          alignment: Alignment.topLeft,
          child: ElevatedButton(
            onPressed: () {
              _groupEdu = null;
              showDialogWidget();
            },
            child: Text("Добавить"),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Ui.color)),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
            child: DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.grey),
          columnSpacing: 100,
          headingTextStyle: TextStyle(color: Colors.white),
          sortColumnIndex: 0,
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
                DataCell(Icon(Icons.delete), onTap: () {}),
              ],
            );
          }).toList(),
        ))
      ],
    );
  }

  Future<void> showDialogWidget() async {
    TextEditingController _name = TextEditingController();
    // TextEditingController _creatdate = TextEditingController();
    DateTime? selectedDate;
    Subject? _subject;

    //TextEditingController _se = TextEditingController();

    if (_groupEdu != null) {
      _name.text = _groupEdu!.name!;
      selectedDate = DateTime.parse(_groupEdu!.createdate!);
      if (_listSubject.length != 0) {
        _subject = _listSubject
            .firstWhere((element) => element.id == _groupEdu!.subject!.id);
      }
    }
    return await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Группа'),
          content: SizedBox(
            width: 600,
            height: 400,
            child: Column(
              children: [
                Container(
                  child: DateTimeField(
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.black45),
                      errorStyle: TextStyle(color: Colors.redAccent),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.event_note),
                      labelText: 'Дата создание',
                    ),
                    initialDate: DateTime.tryParse(_groupEdu!.createdate!),
                    mode: DateTimeFieldPickerMode.date,
                    selectedDate: selectedDate,
                    // autovalidateMode: AutovalidateMode.always,
                    // validator: (e) =>
                    //     (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                    onDateSelected: (DateTime value) {
                      selectedDate = value;
                    },
                  ),
                ),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Название группы"),
                    controller: _name,
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
                      : DropdownButton(
                          items:
                              _listSubject.map<DropdownMenuItem<Subject>>((e) {
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
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Сохранить'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
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
      },
    );
  }
}
