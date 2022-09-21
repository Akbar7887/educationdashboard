class Course {
    List<GroupSet> groupSet;
    int id;
    String level;

    Course({this.groupSet, this.id, this.level});

    factory Course.fromJson(Map<String, dynamic> json) {
        return Course(
            groupSet: json['groupSet'] != null ? (json['groupSet'] as List).map((i) => GroupSet.fromJson(i)).toList() : null, 
            id: json['id'], 
            level: json['level'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['level'] = this.level;
        if (this.groupSet != null) {
            data['groupSet'] = this.groupSet.map((v) => v.toJson()).toList();
        }
        return data;
    }
}