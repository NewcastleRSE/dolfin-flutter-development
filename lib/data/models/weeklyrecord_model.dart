import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dolfin_flutter/data/models/record_model.dart';
import 'package:dolfin_flutter/presentation/screens/addrecord_page.dart';

class WeeklyRecordModel {
  final String id;
  final String child;
  final String studyID;
  final DateTime date;
  final int? numSupplements;
  final bool? problem;
 final List reasons;
  final String otherReason;

  WeeklyRecordModel({
    required this.id,
    required this.child,
    required this.studyID,
    required this.date,
    required this.numSupplements,
    required this.problem,
    required this.reasons,
    required this.otherReason,
  });

  factory WeeklyRecordModel.fromjson(Map<String, dynamic> json, String id) {
    final Timestamp timestamp = json['date'];
    return WeeklyRecordModel(
        id: id,
        child: json['child_id'],
        studyID: json['study_id'],
        date: timestamp.toDate(),
        numSupplements: int.parse(json['supplement']),
        reasons: (json['reasons']),
        otherReason: json['other_reason'],
        problem: json['problem']);
  }

  Map<String, dynamic> tojson() {
    return {
      'child_id': child,
      'study_id': studyID,
      'date': date,
      'supplement': numSupplements.toString(),
      'reasons': reasons,
      'other_reason': otherReason,
      'problem': problem
    };
  }
}
