class ParentModel {
  final String id;
  final List tokens;
  final bool dailyNotifications;

  ParentModel({
    required this.id,
    required this.tokens,
    required this.dailyNotifications,
  });

  factory ParentModel.fromjson(Map<String, dynamic> json, String id) {
    return ParentModel(
        id: id,
        tokens: json['tokens'],
        dailyNotifications: json['dailyNotifications']
    );

  }

  Map<String, dynamic> tojson() {
    return {
      'tokens': tokens,
      'dailyNotifications': dailyNotifications
    };
  }
}