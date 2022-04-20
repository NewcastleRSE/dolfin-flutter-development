class ParentModel {
  final String id;
  final String uid;
  final String fcmToken;

  ParentModel({
    required this.id,
    required this.uid,
    required this.fcmToken,
  });

  factory ParentModel.fromjson(Map<String, dynamic> json, String id) {
    return ParentModel(
        id: id,
        uid: json['uid'],
        fcmToken: json['fcmToken']);
  }

  Map<String, dynamic> tojson() {
    return {
      'uid': uid,
      'fcmToken': fcmToken
    };
  }
}