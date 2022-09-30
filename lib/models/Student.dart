import 'Course.dart';
import 'GroupSet.dart';
import 'Region.dart';

class Student {
  String? adress;
  String? birthday;
  // Course? course;
  String? createdate;
  String? exitdate;
  List<GroupSet>? groupEduSet;
  int? id;
  String? name;
  String? passportId;
  Region? region;

  Student(
      {this.adress,
      this.birthday,
      // this.course,
      this.createdate,
      this.exitdate,
      this.groupEduSet,
      this.id,
      this.name,
      this.passportId,
      this.region});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      adress: json['adress'],
      birthday: json['birthday'],
      // course: json['course'] != null ? Course.fromJson(json['course']) : null,
      createdate: json['createdate'],
      exitdate: json['exitdate'],
      groupEduSet: json['groupEduSet'] != null
          ? (json['groupEduSet'] as List).map((i) => GroupSet.fromJson(i)).toList()
          : null,
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
    // if (this.course != null) {
    //   data['course'] = this.course!.toJson();
    // }
    data['exitdate'] = this.exitdate;
    if (this.groupEduSet != null) {
      data['groupEduSet'] = this.groupEduSet!.map((v) => v.toJson()).toList();
    }
    if (this.region != null) {
      data['region'] = this.region!.toJson();
    }
    return data;
  }
}
