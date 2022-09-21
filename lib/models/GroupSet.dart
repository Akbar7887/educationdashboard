import 'Subject.dart';

class GroupSet {
    String? active;
    String? createdate;
    int? id;
    String? name;
    Subject? subject;

    GroupSet({this.createdate, this.id, this.name, this.subject});

    factory GroupSet.fromJson(Map<String, dynamic> json) {
        return GroupSet(
            createdate: json['createdate'],
            id: json['id'], 
            name: json['name'], 
            subject: json['subject'] != null ? Subject.fromJson(json['subject']) : null, 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['createdate'] = this.createdate;
        data['id'] = this.id;
        data['name'] = this.name;
        if (this.subject != null) {
            data['subject'] = this.subject!.toJson();
        }
        return data;
    }
}