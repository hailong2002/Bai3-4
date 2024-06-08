
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signUpUser ({required String email, required String password}) async{
    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _fireStore.collection('users').doc(credential.user!.uid).set({
        'email': email,
        'uid': credential.user!.uid
      });
      return true;
    }catch(e){
      print(e.toString());
    }
    return false;
  }

  Future<bool> loginUser({required String email, required String password}) async{
    try{
      await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    }catch(e){
      print(e.toString());
    }
    return false;
  }

  Future<void> logoutUser() async{
    await _auth.signOut();
  }

}