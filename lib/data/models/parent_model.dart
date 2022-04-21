class ParentModel {
  final String id;
  final String uid;
  final String tokens;

  ParentModel({
    required this.id,
    required this.uid,
    required this.tokens,
  });

  factory ParentModel.fromjson(Map<String, dynamic> json, String id) {
    return ParentModel(
        id: id,
        uid: json['uid'],
        tokens: json['tokens']);
  }

  Map<String, dynamic> tojson() {
    return {
      'uid': uid,
      'tokens': tokens
    };
  }
}