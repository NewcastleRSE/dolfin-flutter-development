class ChildModel {
  final String id;
  final String studyID;
  final String name;
  final String dob;
  final String dischargeDate;
  final String parentID;

  ChildModel({
    required this.id,
    required this.studyID,
    required this.name,
    required this.dob,
    required this.dischargeDate,
    required this.parentID,
  });

  factory ChildModel.fromjson(Map<String, dynamic> json, String id) {
    return ChildModel(
        id: id,
        studyID: json['study_id'],
        name: json['name'],
        dob: json['dob'],
        dischargeDate: json['dischargeDate'],
        parentID: json['parent_id']);
  }

  Map<String, dynamic> tojson() {
    return {
      'study_id': studyID,
      'name': name,
      'dob': dob,
      'dischargeDate': dischargeDate,
      'parent_id': parentID
    };
  }
}
