import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dolfin_flutter/presentation/screens/addrecord_page.dart';

class WeightModel {
  final String id;
  final String child;
  final String studyID;
  final DateTime date;
  final String weight;
  final String numScoops;

  WeightModel({
    required this.id,
    required this.child,
    required this.studyID,
    required this.date,
    required this.weight,
    required this.numScoops,
  });

  factory WeightModel.fromjson(Map<String, dynamic> json, String id) {
    final Timestamp timestamp = json['date'];
    return WeightModel(
        id: id,
        child: json['child_id'],
        studyID: json['study_id'],
        date: timestamp.toDate(),
        weight: json['weight'],
        numScoops: json['num_scoops']);
  }

  Map<String, dynamic> tojson() {
    return {
      'child_id': child,
      'study_id': studyID,
      'date': date,
      'weight': weight,
      'num_scoops': numScoops,
    };
  }
}
