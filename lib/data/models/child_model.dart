class ChildModel {
  final String id;
  final String studyID;
  final String name;
  final dischargeDate;
  final String parentID;
  final String dob;
  final String parent_email;

  ChildModel({
    required this.id,
    required this.dob,
    required this.studyID,
    required this.name,
    required this.dischargeDate,
    required this.parentID,
    required this.parent_email
  });

  factory ChildModel.fromjson(Map<String, dynamic> json, String id) {
    return ChildModel(
        id: id,
        studyID: json['study_id'],
        name: json['name'],
        dob: json['dob'],
        dischargeDate: json['dischargeDate'],
        parentID: json['parent_id'],
        parent_email: json['parent_email']
    );

  }

  Map<String, dynamic> tojson() {
    return {
      'study_id': studyID,
      'dob': dob,
      'name': name,
      'dischargeDate': dischargeDate,
      'parent_id': parentID,
      'parent_email': parent_email
    };
  }
}
