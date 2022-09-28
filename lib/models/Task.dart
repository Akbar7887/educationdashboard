class Task {
  bool? ans_A = false;
  String? ans_A_name;
  bool? ans_B = false;
  String? ans_B_name;
  bool? ans_C = false;
  String? ans_C_name;
  bool? ans_D = false;
  String? ans_D_name;
  bool? ans_E = false;
  String? ans_E_name;

  int? id;
  String? taskname;

  bool? show;

  Task(
      { this.ans_A,
      this.ans_A_name,
       this.ans_B,
      this.ans_B_name,
       this.ans_C,
      this.ans_C_name,
       this.ans_D,
      this.ans_D_name,
       this.ans_E,
      this.ans_E_name,
      this.id,
      this.taskname,
      this.show});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      ans_A: json['ans_A'],
      ans_B: json['ans_B'],
      ans_C: json['ans_C'],
      ans_D: json['ans_D'],
      ans_E: json['ans_E'],
      ans_A_name: json['ans_A_name'],
      ans_B_name: json['ans_B_name'],
      ans_C_name: json['ans_C_name'],
      ans_D_name: json['ans_D_name'],
      ans_E_name: json['ans_E_name'],
      id: json['id'],
      taskname: json['taskname'],
      show: json['show'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ans_A'] = this.ans_A;
    data['ans_B'] = this.ans_B;
    data['ans_C'] = this.ans_C;
    data['ans_D'] = this.ans_D;
    data['ans_E'] = this.ans_E;
    data['ans_A_name'] = this.ans_A_name;
    data['ans_B_name'] = this.ans_B_name;
    data['ans_C_name'] = this.ans_C_name;
    data['ans_D_name'] = this.ans_D_name;
    data['ans_E_name'] = this.ans_E_name;
    data['id'] = this.id;
    data['taskname'] = this.taskname;
    data['show'] = this.show;
    return data;
  }
}
