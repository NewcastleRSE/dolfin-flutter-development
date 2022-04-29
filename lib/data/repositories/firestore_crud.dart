import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dolfin_flutter/data/models/child_model.dart';
import 'package:dolfin_flutter/data/models/record_model.dart';

import '../models/parent_model.dart';

class FireStoreCrud {
  FireStoreCrud();

  final _firestore = FirebaseFirestore.instance;

  Future<void> addChild({required ChildModel child}) async {
    var childcollection = _firestore.collection('children');
    await childcollection.add(child.tojson());
  }

  Future<void> addRecord({required RecordModel record}) async {
    var recordcollection = _firestore.collection('records');
    await recordcollection.add(record.tojson());
  }

  Stream<List<ChildModel>> getChildren({required String parentID}) {
    return _firestore
        .collection('children')
        .where('parent_id', isEqualTo: parentID)
        .snapshots(includeMetadataChanges: true)
        .map((snapshot) => snapshot.docs
            .map((doc) => ChildModel.fromjson(doc.data(), doc.id))
            .toList());
  }

  Future<List<String>> getDischargeDates({required String parentID}) async {
    List<String> dates = [];

    final querySnapshot = await FirebaseFirestore.instance
        .collection('children')
        .where('parent_id', isEqualTo: parentID)
        .get();

    for (var doc in querySnapshot.docs) {
      // Getting data directly
      String date = doc.get('dischargeDate');

      dates.add(date);
    }

    return dates;
  }

  Stream<List<RecordModel>> getRecords({required String childID}) {
    return _firestore
        .collection('records')
        .where('child_id', isEqualTo: childID)
        .snapshots(includeMetadataChanges: true)
        .map((snapshot) => snapshot.docs
            .map((doc) => RecordModel.fromjson(doc.data(), doc.id))
            .toList());
  }

  Future<void> updateChild({
    required String name,
    dob,
    docid,
    dischargeDate,
    dueDate,
    recruitedAfterDischarge
  }) async {
    var childcollection = _firestore.collection('children');
    await childcollection.doc(docid).update({
      'name': name,
      'dob': dob,
      'dischargeDate': dischargeDate,
      'dueDate': dueDate,
      'recruitedAfterDischarge': recruitedAfterDischarge

    });
  }



  Future<void> updateRecord({
    required SupplementOptions supplement,
    weight,
    docid,
  }) async {
    var recordcollection = _firestore.collection('records');
    await recordcollection.doc(docid).update({
      'supplement': supplement,
      'weight': weight,
    });
  }

  Future<void> deleteChild({required String docid}) async {
    var childcollection = _firestore.collection('children');
    await childcollection.doc(docid).delete();
  }

  Future<void> deleteRecord({required String docid}) async {
    var recordollection = _firestore.collection('records');
    await recordollection.doc(docid).delete();
  }
}
