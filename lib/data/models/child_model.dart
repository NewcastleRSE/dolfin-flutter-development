class ChildModel {
  final String id;
  final String studyID;
  final String name;
  final String dischargeDate;
  final String parentID;
  final String supplementStartDate;
  final String dob;
  final bool recruitedAfterDischarge;
  final String parent_email;

  ChildModel({
    required this.id,
    required this.dob,
    required this.studyID,
    required this.name,
    required this.supplementStartDate,
    required this.dischargeDate,
    required this.parentID,
    required this.recruitedAfterDischarge,
    required this.parent_email
  });

  factory ChildModel.fromjson(Map<String, dynamic> json, String id) {
    return ChildModel(
        id: id,
        studyID: json['study_id'],
        name: json['name'],
        dob: json['dob'],
        supplementStartDate: json['supplementStartDate'],
        dischargeDate: json['dischargeDate'],
        recruitedAfterDischarge: json['recruitedAfterDischarge'],
        parentID: json['parent_id'],
        parent_email: json['parent_email']
    );

  }

  Map<String, dynamic> tojson() {
    return {
      'study_id': studyID,
      'dob': dob,
      'name': name,
      'supplementStartDate': supplementStartDate,
      'dischargeDate': dischargeDate,
      'recruitedAfterDischarge': recruitedAfterDischarge,
      'parent_id': parentID,
      'parent_email': parent_email
    };
  }
}
