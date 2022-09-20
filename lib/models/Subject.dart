class Subject {
    int? id;
    String? name;

    Subject({this.id, this.name});

    factory Subject.fromJson(Map<String, dynamic> json) {
        return Subject(
            id: json['id'], 
            name: json['name'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['name'] = this.name;
        return data;
    }
}