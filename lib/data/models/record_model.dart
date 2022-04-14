class RecordModel {
  final String id;
  final String child;
  final String date;
  final String supplement;
  final String reason;
  final String weight;

  RecordModel({
    required this.id,
    required this.child,
    required this.date,
    required this.supplement,
    required this.reason,
    required this.weight,
  });

  factory RecordModel.fromjson(Map<String, dynamic> json, String id) {
    return RecordModel(
        id: id,
        child: json['child_id'],
        date: json['date'],
        supplement: json['supplement'],
        reason: json['reason'],
        weight: json['weight']);
  }

  Map<String, dynamic> tojson() {
    return {
      'child_id': child,
      'date': date,
      'supplement': supplement,
      'reason': reason,
      'weight': weight
    };
  }
}
