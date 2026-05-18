import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/allowed_user_model.dart';
import '../models/material_info_model.dart';
import '../models/order_model.dart';
import '../models/worksheet_data_model.dart';

const String followupDataCollection = 'followup_data';
const String materialDataCollection = 'material_data';
const String orderSCollection = 'orders';
const String allowedUsersCollection = 'allowed_users';

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference get _followUpDataRef =>
      _firestore.collection(followupDataCollection);
  CollectionReference get _materialDataRef =>
      _firestore.collection(materialDataCollection);
  CollectionReference get _ordersRef => _firestore.collection(orderSCollection);
  CollectionReference get _allowedUsersRef =>
      _firestore.collection(allowedUsersCollection);

  //** FOLLOWUP DATA */
  // CREATE
  Future<DatabaseResult<DocumentReference<WorksheetDataModel>>>
  createFollowupData(WorksheetDataModel followupData) async {
    try {
      final result = await _followUpDataRef
          .withConverter<WorksheetDataModel>(
            fromFirestore:
                (snapshot, _) =>
                    WorksheetDataModel.fromJson(snapshot.data() ?? {}),
            toFirestore: (data, _) => data.toJson(),
          )
          .add(followupData);
      return DatabaseResult.success(result);
    } catch (e) {
      return DatabaseResult.error(e.toString());
    }
  }

  Future<void> createFollowupDataWithId(WorksheetDataModel followupData) async {
    try {
      await _followUpDataRef
          .withConverter<WorksheetDataModel>(
            fromFirestore:
                (snapshot, _) =>
                    WorksheetDataModel.fromJson(snapshot.data() ?? {}),
            toFirestore: (data, _) => data.toJson(),
          )
          .doc(followupData.worksheetId)
          .set(followupData);
    } catch (e) {
      print(e.toString());
    }
  }

  // READ ALL FOLLOW UP DATA
  Stream<DatabaseResult<QuerySnapshot<WorksheetDataModel>>> readFollowupData() {
    try {
      return _followUpDataRef
          .withConverter<WorksheetDataModel>(
            fromFirestore:
                (snapshot, _) => WorksheetDataModel.fromJson(snapshot.data()!),
            toFirestore: (followupData, _) => followupData.toJson(),
          )
          .snapshots()
          .map((snapshot) => DatabaseResult.success(snapshot))
          .handleError((error) => DatabaseResult.error(error.toString()));
    } catch (e) {
      return Stream.value(DatabaseResult.error(e.toString()));
    }
  }

  // UPDATE
  Future<DatabaseResult<void>> updateFollowupData(
    WorksheetDataModel followupData,
  ) async {
    try {
      await _followUpDataRef
          .doc(followupData.worksheetId)
          .update(followupData.toJson());
      return DatabaseResult.success(null);
    } catch (e) {
      return DatabaseResult.error(e.toString());
    }
  }

  // DELETE
  Future<DatabaseResult<void>> deleteFollowupData(String docId) async {
    try {
      await _followUpDataRef.doc(docId).delete();
      return DatabaseResult.success(null);
    } catch (e) {
      return DatabaseResult.error(e.toString());
    }
  }

  //** MATERIAL DATA */
  // CREATE
  Future<DatabaseResult<DocumentReference<MaterialInfoModel>>>
  createMaterialData(MaterialInfoModel materialData) async {
    try {
      final result = await _materialDataRef
          .withConverter<MaterialInfoModel>(
            fromFirestore:
                (snapshot, _) =>
                    MaterialInfoModel.fromJson(snapshot.data() ?? {}),
            toFirestore: (data, _) => data.toJson(),
          )
          .add(materialData);
      return DatabaseResult.success(result);
    } catch (e) {
      return DatabaseResult.error(e.toString());
    }
  }

  // READ ALL MATERIAL DATA
  Stream<DatabaseResult<QuerySnapshot<MaterialInfoModel>>> readMaterialData() {
    try {
      return _materialDataRef
          .withConverter<MaterialInfoModel>(
            fromFirestore:
                (snapshot, _) => MaterialInfoModel.fromJson(snapshot.data()!),
            toFirestore: (materialData, _) => materialData.toJson(),
          )
          .snapshots()
          .map((snapshot) => DatabaseResult.success(snapshot))
          .handleError((error) => DatabaseResult.error(error.toString()));
    } catch (e) {
      return Stream.value(DatabaseResult.error(e.toString()));
    }
  }

  // UPDATE
  Future<DatabaseResult<void>> updateMaterialData(
    MaterialInfoModel materialData,
    String docId,
  ) async {
    try {
      await _materialDataRef.doc(docId).update(materialData.toJson());
      return DatabaseResult.success(null);
    } catch (e) {
      return DatabaseResult.error(e.toString());
    }
  }

  // DELETE
  Future<DatabaseResult<void>> deleteMaterialData(String docId) async {
    try {
      await _materialDataRef.doc(docId).delete();
      return DatabaseResult.success(null);
    } catch (e) {
      return DatabaseResult.error(e.toString());
    }
  }

  //** ORDER */
  // CREATE
  Future<DatabaseResult<DocumentReference<OrderModel>>> createOrder(
    OrderModel order,
  ) async {
    try {
      final result = await _ordersRef
          .withConverter<OrderModel>(
            fromFirestore:
                (snapshot, _) => OrderModel.fromJson(snapshot.data() ?? {}),
            toFirestore: (data, _) => data.toJson(),
          )
          .add(order);
      return DatabaseResult.success(result);
    } catch (e) {
      return DatabaseResult.error(e.toString());
    }
  }

  // READ ALL ORDERS
  Stream<DatabaseResult<QuerySnapshot<OrderModel>>> readOrder() {
    try {
      return _ordersRef
          .withConverter<OrderModel>(
            fromFirestore:
                (snapshot, _) => OrderModel.fromJson(snapshot.data()!),
            toFirestore: (order, _) => order.toJson(),
          )
          .snapshots()
          .map((snapshot) => DatabaseResult.success(snapshot))
          .handleError((error) => DatabaseResult.error(error.toString()));
    } catch (e) {
      return Stream.value(DatabaseResult.error(e.toString()));
    }
  }

  // UPDATE
  Future<DatabaseResult<void>> updateOrder(
    OrderModel order,
    String docId,
  ) async {
    try {
      await _ordersRef.doc(docId).update(order.toJson());
      return DatabaseResult.success(null);
    } catch (e) {
      return DatabaseResult.error(e.toString());
    }
  }

  // DELETE
  Future<DatabaseResult<void>> deleteOrder(String docId) async {
    try {
      await _materialDataRef.doc(docId).delete();
      return DatabaseResult.success(null);
    } catch (e) {
      return DatabaseResult.error(e.toString());
    }
  }

  //** USER USERS */
  // CREATE ALLOWED USER ACCOUNT
  Future<DatabaseResult<DocumentReference<AllowedUserModel>>>
  createAllowedUserAccount(AllowedUserModel allowedUser) async {
    try {
      final result = await _allowedUsersRef
          .withConverter<AllowedUserModel>(
            fromFirestore:
                (snapshot, _) =>
                    AllowedUserModel.fromJson(snapshot.data() ?? {}),
            toFirestore: (data, _) => data.toJson(),
          )
          .add(allowedUser);
      return DatabaseResult.success(result);
    } catch (e) {
      return DatabaseResult.error(e.toString());
    }
  }

  // READ ALL ALLOWED USER ACCOUNT
  Stream<DatabaseResult<QuerySnapshot<AllowedUserModel>>>
  readAllowedUserAccount() {
    try {
      return _allowedUsersRef
          .withConverter<AllowedUserModel>(
            fromFirestore:
                (snapshot, _) => AllowedUserModel.fromJson(snapshot.data()!),
            toFirestore: (user, _) => user.toJson(),
          )
          .snapshots()
          .map((snapshot) => DatabaseResult.success(snapshot));
      // .handleError((error) => DatabaseResult.error(error.toString()));
    } catch (e) {
      return Stream.value(DatabaseResult.error(e.toString()));
    }
  }

  // UPDATE
  Future<DatabaseResult<void>> updateAllowedUserAccount(
    AllowedUserModel order,
    String docId,
  ) async {
    try {
      await _allowedUsersRef.doc(docId).update(order.toJson());
      return DatabaseResult.success(null);
    } catch (e) {
      return DatabaseResult.error(e.toString());
    }
  }

  // DELETE
  Future<DatabaseResult<void>> deleteAllowedUserAccount(String docId) async {
    try {
      await _allowedUsersRef.doc(docId).delete();
      return DatabaseResult.success(null);
    } catch (e) {
      return DatabaseResult.error(e.toString());
    }
  }
}

class DatabaseResult<T> {
  final T? data;
  final String? error;

  DatabaseResult.success(this.data) : error = null;
  DatabaseResult.error(this.error) : data = null;

  bool get isSuccess => error == null;
  bool get isError => error != null;
}
