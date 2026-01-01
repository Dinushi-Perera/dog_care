import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dog_care/firebase/register.dart';

class FirebaseService {

  final CollectionReference _registerUser = FirebaseFirestore.instance.collection('registerUser');

  Future<void> addUser(String fullName, String email, int phoneNumber, String address) async{
    try{
      final userdata = Register(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        address: address,
      );
      final Map<String, dynamic> data = userdata.toJson();
      await _registerUser.add(data);
      print("✅ User data added successfully: ${data}");
    }
    catch (e) {
      print("❌ Error adding user data: $e");
      throw Exception("Failed to add user data.");
    }
  }

  Stream<List<Register>> getUsers(){
    return _registerUser.snapshots().map((snapshot) => snapshot.docs.map((doc) => Register.fromJson(doc.data() as Map<String, dynamic>,doc.id)).toList());
    //  return _RegisterCustomer.snapshots().map((snapshot) => snapshot.docs.map((doc) => Register.fromJson(doc.data() as Map<String, dynamic>,doc.id)).toList());
  }
}