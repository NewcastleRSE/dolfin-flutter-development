import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dolfin_flutter/data/models/child_model.dart';
import 'package:dolfin_flutter/data/models/task_model.dart';

class FireStoreCrud {
  FireStoreCrud();

  final _firestore = FirebaseFirestore.instance;

  Future<void> addTask({required TaskModel task}) async {
    var taskcollection = _firestore.collection('tasks');
    await taskcollection.add(task.tojson());
  }

  Future<void> addChild({required ChildModel child}) async {
    var childcollection = _firestore.collection('children');
    await childcollection.add(child.tojson());
  }

  Stream<List<TaskModel>> getTasks({required String mydate}) {
    return _firestore
        .collection('tasks')
        .where('date', isEqualTo: mydate)
        .snapshots(includeMetadataChanges: true)
        .map((snapshor) => snapshor.docs
            .map((doc) => TaskModel.fromjson(doc.data(), doc.id))
            .toList());
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

  Future<void> updateTask(
      {required String title,
      note,
      docid,
      date,
      starttime,
      endtime,
      required int reminder,
      colorindex}) async {
    var taskcollection = _firestore.collection('tasks');
    await taskcollection.doc(docid).update({
      'title': title,
      'note': note,
      'date': date,
      'starttime': starttime,
      'endtime': endtime,
      'reminder': reminder,
      'colorindex': colorindex,
    });
  }

  Future<void> updateChild({
    required String name,
    dob,
    docid,
  }) async {
    var taskcollection = _firestore.collection('children');
    await taskcollection.doc(docid).update({
      'name': name,
      'dob': dob,
    });
  }

  Future<void> deleteTask({required String docid}) async {
    var taskcollection = _firestore.collection('tasks');
    await taskcollection.doc(docid).delete();
  }

  Future<void> deleteChild({required String docid}) async {
    var childcollection = _firestore.collection('children');
    await childcollection.doc(docid).delete();
  }
}
