class ChildModel {
  final String id;
  final String studyID;
  final String name;
  final String? dischargeDate;
  final String? EDD;
  final String parentID;
  final String dob;
  final String parent_email;
  final bool active;

  ChildModel({
    required this.id,
    required this.dob,
    required this.studyID,
    required this.name,
    required this.dischargeDate,
    required this.EDD,
    required this.parentID,
    required this.parent_email,
    required this.active,
  });

  factory ChildModel.fromjson(Map<String, dynamic> json, String id) {
    return ChildModel(
        id: id,
        studyID: json['study_id'],
        name: json['name'],
        dob: json['dob'],
        dischargeDate: json['dischargeDate'],
        EDD: json['edd'],
        parentID: json['parent_id'],
        parent_email: json['parent_email'],
        active: json['active']
    );

  }

  Map<String, dynamic> tojson() {
    return {
      'study_id': studyID,
      'dob': dob,
      'name': name,
      'dischargeDate': dischargeDate,
      'EDD': EDD,
      'parent_id': parentID,
      'parent_email': parent_email,
      'active': active
    };
  }
}
