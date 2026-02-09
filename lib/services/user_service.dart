import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String? name;
  final String? phoneNumber;
  final String? role;

  UserModel({
    required this.uid,
    this.name,
    this.phoneNumber,
    this.role,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      name: map['name'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      role: map['role'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'role': role,
      'lastLogin': FieldValue.serverTimestamp(),
    };
  }
}

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'users';

  Future<void> createUserIfNotExists(User user) async {
    final docRef = _firestore.collection(_collection).doc(user.uid);
    final docSnap = await docRef.get();

    if (!docSnap.exists) {
      final newUser = UserModel(
        uid: user.uid,
        name: 'Farmer ${user.phoneNumber?.substring(user.phoneNumber!.length - 4) ?? "John"}', // Default name
        phoneNumber: user.phoneNumber,
        role: 'farmer',
      );
      await docRef.set(newUser.toMap());
    } else {
        // Update last login
        await docRef.update({
            'lastLogin': FieldValue.serverTimestamp(),
        });
    }
  }

  Stream<UserModel?> getUserStream(String uid) {
    return _firestore.collection(_collection).doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return UserModel.fromMap(snapshot.data()!, uid);
      }
      return null;
    });
  }
  
  Future<void> updateUserName(String uid, String name) async {
      await _firestore.collection(_collection).doc(uid).update({'name': name});
  }
}
