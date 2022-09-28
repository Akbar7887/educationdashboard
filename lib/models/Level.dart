import 'package:educationdashboard/models/Subject.dart';

import 'Course.dart';
import 'Task.dart';

class Level {
  Course? course;
  String? description;
  int? level_id;
  String? levelname;
  Subject? subject;
  List<Task>? taskList;

  Level(
      {this.course,
      this.description,
      this.level_id,
      this.levelname,
      this.subject,
      this.taskList});

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      course: json['course'] != null ? Course.fromJson(json['course']) : null,
      description: json['description'],
      level_id: json['level_id'],
      levelname: json['levelname'],
      subject:
          json['subject'] != null ? Subject.fromJson(json['subject']) : null,
      taskList: json['taskList'] != null ? (json['taskList'] as List).map((i) => Task.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['level_id'] = this.level_id;
    data['levelname'] = this.levelname;
    if (this.course != null) {
      data['course'] = this.course!.toJson();
    }
    if (this.subject != null) {
      data['subject'] = this.subject!.toJson();
    }
    if (this.taskList != null) {
      data['taskList'] = this.taskList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
