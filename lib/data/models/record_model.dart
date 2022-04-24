import 'package:dolfin_flutter/presentation/screens/addrecord_page.dart';

enum SupplementOptions { fullDose, partialDose, noDose }

SupplementOptions? deserialiseSupplement(String str) {
  return SupplementOptions.values.firstWhere((e) => e.toString() == str);
}

enum ReasonOptions { forgot, ranOut, refused, spatOut, unwell, other }

ReasonOptions? deserialiseReason(String str) {
  return ReasonOptions.values.firstWhere((e) => e.toString() == str);
}

class RecordModel {
  final String id;
  final String child;
  final String date;
  final SupplementOptions? supplement;
  final ReasonOptions? reason;
  final String otherReason;
  final num weight;

  RecordModel({
    required this.id,
    required this.child,
    required this.date,
    required this.supplement,
    required this.reason,
    required this.otherReason,
    required this.weight,
  });

  factory RecordModel.fromjson(Map<String, dynamic> json, String id) {
    return RecordModel(
        id: id,
        child: json['child_id'],
        date: json['date'],
        supplement: deserialiseSupplement(json['supplement']),
        reason: deserialiseReason(json['reason']),
        otherReason: json['other_reason'],
        weight: json['weight']);
  }

  Map<String, dynamic> tojson() {
    return {
      'child_id': child,
      'date': date,
      'supplement': supplement.toString(),
      'reason': reason.toString(),
      'other_reason': otherReason,
      'weight': weight
    };
  }
}
