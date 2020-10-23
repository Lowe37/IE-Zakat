import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutteriezakat/database.dart';
import 'package:flutteriezakat/models/user.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseuser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }
//sign in with email and password
  Future signinWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      await DBservice(uid: user.uid).updateUserData('Lowe', 'lowe@gmail.com', '654321', '654321');
      return _userFromFirebaseuser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(String name, String email, String password, String confirmpassword) async {
   try {
     AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
     FirebaseUser user = result.user;

     await DBservice(uid: user.uid).updateUserData('Lowe', 'lowe@gmail.com', '654321', '654321');
     return _userFromFirebaseuser(user);
   } catch(e){
     print(e.toString());
     return null;
   }
  }


  // sign out
  Future signOut() async {
  try {
    return await _auth.signOut();
  } catch(e){
    print((e.toString()));
    return null;
  }
}

}