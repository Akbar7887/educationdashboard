class Region {
    int? id;
    String? name;

    Region({this.id, this.name});

    factory Region.fromJson(Map<String, dynamic> json) {
        return Region(
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