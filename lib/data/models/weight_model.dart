import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dolfin_flutter/presentation/screens/addrecord_page.dart';

class WeightModel {
  final String id;
  final String child;
  final String studyID;
  final DateTime date;
  final DateTime dateSubmitted;
  final String weight;
  final String numScoops;

  // @imre-patch: Adding this to make it easier to debug
  // @override
  // String toString() {
  //   return 'WeightModel{id: $id, child: $child, studyID: $studyID, date: $date, dateSubmitted: $dateSubmitted, weight: $weight, numScoops: $numScoops}\n\n';
  // }

  WeightModel({
    required this.id,
    required this.child,
    required this.studyID,
    required this.date,
    required this.dateSubmitted,
    required this.weight,
    required this.numScoops,
  });

  factory WeightModel.fromjson(Map<String, dynamic> json, String id) {
    final Timestamp date = json['date'];
    final Timestamp submitted = json.containsKey('date_submitted')
        ? json['date_submitted']
        : json['date'];
    return WeightModel(
        id: id,
        child: json['child_id'],
        studyID: json['study_id'],
        date: date.toDate(),
        dateSubmitted: submitted.toDate(),
        weight: json['weight'],
        numScoops: json['num_scoops']);
  }

  Map<String, dynamic> tojson() {
    return {
      'child_id': child,
      'study_id': studyID,
      'date': date,
      'date_submitted': DateTime.now(),
      'weight': weight,
      'num_scoops': numScoops,
    };
  }
}
