import 'Subject.dart';

class GroupEdu {
    String? active;
    String? createdate;
    int? id;
    String? name;
    Subject? subject;

    GroupEdu({this.active, this.createdate, this.id, this.name, this.subject});

    factory GroupEdu.fromJson(Map<String, dynamic> json) {
        return GroupEdu(
            active: json['active'], 
            createdate: json['createdate'], 
            id: json['id'], 
            name: json['name'], 
            subject: json['subject'] != null ? Subject.fromJson(json['subject']) : null, 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['active'] = this.active;
        data['createdate'] = this.createdate;
        data['id'] = this.id;
        data['name'] = this.name;
        if (this.subject != null) {
            data['subject'] = this.subject!.toJson();
        }
        return data;
    }
}