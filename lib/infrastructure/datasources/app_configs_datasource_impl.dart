import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/models.dart';

class AppConfigsDatasourceImpl implements AppconfigsDatasource {
  final _db = FirebaseFirestore.instance;

  @override
  Future<AppConfigs> getAppConfigs() async {
    return await _db
        .collection(FirestoreDbCollections.appConfigs)
        .doc(FirestoreDbCollections.defaultConfigs)
        .withConverter(
          fromFirestore: AppConfigs.fromFirestore,
          toFirestore: (config, options) => config.toFirestore(),
        )
        .get()
        .then(
      (value) {
        if (value.exists) return value.data()!.copyWith(docRef: value.id);
        throw Exception('An error occurred while getting App Configs');
      },
    ).onError(
      (error, stackTrace) {
        logger.e('Error while getting App Configs: $error');
        throw Exception(stackTrace);
      },
    );
  }

  @override
  Future<AppConfigs?> updateAppConfigs(AppConfigs configs,
      {bool checkExistence = true}) async {
    if (checkExistence) {
      final exists = await _checkAppConfigsExitsByDocRef(configs);
      if (!exists) {
        return null;
      }
    }
    return await _db
        .collection(FirestoreDbCollections.appConfigs)
        .doc(configs.docRef)
        .update(configs.toFirestore())
        .then((value) {
      return configs;
    }).onError((error, stackTrace) {
      final errorMsg =
          "Error while updating AppConfigs with docRef ${configs.docRef}: $error";
      logger.e(errorMsg);
      throw Exception(errorMsg);
    });
  }

  Future<bool> _checkAppConfigsExitsByDocRef(AppConfigs configs) async {
    if (configs.docRef == null || configs.docRef!.isEmpty) return false;
    return await _db
        .collection(FirestoreDbCollections.appConfigs)
        .doc(configs.docRef)
        .get()
        .then((value) {
      return value.exists;
    }).onError((error, stackTrace) {
      final errorMsg =
          "Error while checking existence of AppConfigs with docRef ${configs.docRef}: $error";
      logger.e(errorMsg);
      throw Exception(errorMsg);
    });
  }
}
