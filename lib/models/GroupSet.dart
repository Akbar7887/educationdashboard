import 'package:educationdashboard/models/Student.dart';

import 'Subject.dart';

class GroupSet {
  String? createdate;
  int? id;
  String? name;
  Subject? subject;
  List<Student>? students;

  GroupSet({
    this.createdate,
    this.id,
    this.name,
    this.subject,
    this.students,
  });

  factory GroupSet.fromJson(Map<String, dynamic> json) {
    return GroupSet(
      createdate: json['createdate'],
      id: json['id'],
      name: json['name'],
      students: json['students'] != null
          ? (json['students'] as List).map((i) => Student.fromJson(i)).toList()
          : null,
      subject:
          json['subject'] != null ? Subject.fromJson(json['subject']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdate'] = this.createdate;
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.students != null) {
      data['students'] = this.students!.map((v) => v.toJson()).toList();
    }
    if (this.subject != null) {
      data['subject'] = this.subject!.toJson();
    }
    return data;
  }
}
