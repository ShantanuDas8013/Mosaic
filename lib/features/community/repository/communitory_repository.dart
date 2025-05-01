import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mosaic/core/constants/firebase_constant.dart';
import 'package:mosaic/core/failure.dart';
import 'package:mosaic/core/providers/firebase_providers.dart';
import 'package:mosaic/core/type_defs.dart';
import 'package:mosaic/models/community_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

final communityRepositoryProvider = Provider((ref) {
  return CommunitoryRespository(firestore: ref.watch(firestoreProvider));
});

class CommunitoryRespository {
  final FirebaseFirestore _firestore;
  CommunitoryRespository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  FutureVoid createCommunity(Community community) async {
    try {
      var communityDoc = await _communities.doc(community.name).get();
      if (communityDoc.exists) {
        throw 'Community with the same name already exists';
      }
      return right(_communities.doc(community.name).set(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> getUserCommunities(String uid) {
    return _communities.where('members', arrayContains: uid).snapshots().map((
      event,
    ) {
      List<Community> communities = [];
      for (var doc in event.docs) {
        communities.add(Community.fromMap(doc.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }

  Stream<Community> getCommunityByName(String name) {
    return _communities
        .doc(name)
        .snapshots()
        .map(
          (event) => Community.fromMap(event.data() as Map<String, dynamic>),
        );
  }

  FutureEither<String> storeFile({
    required String path,
    required String id,
    required File file,
  }) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(path).child(id);
      UploadTask uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;
      return right(await snapshot.ref.getDownloadURL());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid updateCommunityBanner(String name, String bannerUrl) async {
    try {
      return right(_communities.doc(name).update({'banner': bannerUrl}));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid updateCommunityAvatar(String name, String avatarUrl) async {
    try {
      return right(_communities.doc(name).update({'avatar': avatarUrl}));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid editCommunity(Community community) async {
    try {
      return right(_communities.doc(community.name).update(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communitiesCollection);
}
