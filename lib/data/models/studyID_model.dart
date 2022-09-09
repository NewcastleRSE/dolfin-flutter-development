class StudyIDModel {
  final String id;
  final String studyID;

  StudyIDModel({
    required this.id,
    required this.studyID
  });

  factory StudyIDModel.fromjson(Map<String, dynamic> json, String id) {
    return StudyIDModel(
        id: id,
        studyID: json['study_id']
    );}

  Map<String, dynamic> tojson() {
    return {
      'study_id': studyID
    };
  }
}
