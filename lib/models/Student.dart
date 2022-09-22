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
  GroupSet? groupSet;
  int? id;
  String? name;
  String? passportId;
  Region? region;

  Student(
      {this.adress,
      this.birthday,
      this.course,
      this.createdate,
      this.exitdate,
      this.groupSet,
      this.id,
      this.name,
      this.passportId,
      this.region});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      adress: json['adress'],
      birthday: json['birthday'],
      course: json['course'] != null ? Course.fromJson(json['course']) : null,
      createdate: json['createdate'],
      exitdate: json['exitdate'] !=null?json['exitdate'] : null,
      groupSet: json['groupEdu'] != null ? GroupSet.fromJson(json['groupEdu']) : null,
      id: json['id'],
      name: json['name'],
      passportId: json['passportId'],
      region: json['region'] != null ? Region.fromJson(json['region']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adress'] = this.adress;
    data['birthday'] = this.birthday;
    data['createdate'] = this.createdate;
    data['id'] = this.id;
    data['name'] = this.name;
    data['passportId'] = this.passportId;
    if (this.course != null) {
      data['course'] = this.course!.toJson();
    }
    if (this.exitdate != null) {
      data['exitdate'] = this.exitdate;
    }
      data['groupEdu'] = this.groupSet;
    if (this.region != null) {
      data['region'] = this.region!.toJson();
    }
    return data;
  }
}
