import 'Course.dart';
import 'GroupSet.dart';
import 'Region.dart';
import 'Subject.dart';

class Student {
  String? adress;
  String? birthday;
  Course? course;
  String? createdate;
  String? exitdate;
  List<GroupSet>? groupEduSet;
  int? id;
  String? lastname;
  String? name;
  String? passportId;
  Region? region;
  Subject? subject;

  Student(
      {this.adress,
      this.birthday,
      this.course,
      this.createdate,
      this.exitdate,
      this.groupEduSet,
      this.id,
      this.lastname,
      this.name,
      this.passportId,
      this.region,
      this.subject});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      adress: json['adress'],
      birthday: json['birthday'],
      course: json['course'] != null ? Course.fromJson(json['course']) : null,
      createdate: json['createdate'],
      exitdate: json['exitdate'],
      groupEduSet: json['groupEduSet'] != null
          ? (json['groupEduSet'] as List)
              .map((i) => GroupSet.fromJson(i))
              .toList()
          : null,
      id: json['id'],
      lastname: json['lastname'],
      name: json['name'],
      passportId: json['passportId'],
      region: json['region'] != null ? Region.fromJson(json['region']) : null,
      subject:
          json['subject'] != null ? Subject.fromJson(json['subject']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adress'] = this.adress;
    data['birthday'] = this.birthday;
    data['createdate'] = this.createdate;
    data['id'] = this.id;
    data['lastname'] = this.lastname;
    data['name'] = this.name;
    data['passportId'] = this.passportId;
    if (this.course != null) {
      data['course'] = this.course!.toJson();
    }
    if (this.exitdate != null) {
      data['exitdate'] = this.exitdate;
    }
    if (this.groupEduSet != null) {
      data['groupEduSet'] = this.groupEduSet!.map((v) => v.toJson()).toList();
    }
    if (this.region != null) {
      data['region'] = this.region!.toJson();
    }
    if (this.subject != null) {
      data['subject'] = this.subject!.toJson();
    }
    return data;
  }
}
