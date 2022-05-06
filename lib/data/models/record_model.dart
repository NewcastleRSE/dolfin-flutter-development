import 'package:cloud_firestore/cloud_firestore.dart';
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
  final String studyID;
  final DateTime date;
  final SupplementOptions? supplement;
  final ReasonOptions? reason;
  final String otherReason;

  RecordModel({
    required this.id,
    required this.child,
    required this.studyID,
    required this.date,
    required this.supplement,
    required this.reason,
    required this.otherReason,
  });

  factory RecordModel.fromjson(Map<String, dynamic> json, String id) {
    final Timestamp timestamp = json['date'];
    return RecordModel(
        id: id,
        child: json['child_id'],
        studyID: json['study_id'],
        date: timestamp.toDate(),
        supplement: deserialiseSupplement(json['supplement']),
        reason: deserialiseReason(json['reason']),
        otherReason: json['other_reason']);
  }

  Map<String, dynamic> tojson() {
    return {
      'child_id': child,
      'study_id': studyID,
      'date': date,
      'supplement': supplement.toString(),
      'reason': reason.toString(),
      'other_reason': otherReason,
    };
  }
}
