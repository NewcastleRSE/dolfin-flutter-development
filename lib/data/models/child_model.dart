class ChildModel {
  final String id;
  final String name;
  final String dob;

  ChildModel({
    required this.id,
    required this.name,
    required this.dob,
  });

  factory ChildModel.fromjson(Map<String, dynamic> json, String id) {
    return ChildModel(
      id: id,
      name: json['name'],
      dob: json['dob'],
    );
  }

  Map<String, dynamic> tojson() {
    return {
      'name': name,
      'dob': dob,
    };
  }
}
