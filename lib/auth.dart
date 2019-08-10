import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:charcha/config.dart';

Future<GoogleSignInAccount> getSignedInAccount(GoogleSignIn googleSignIn) async {
  GoogleSignInAccount account = googleSignIn.currentUser;
  if (account == null) {
    account = await googleSignIn.signInSilently();
  }
  return account;
}

Future<FirebaseUser> signIntoFirebase(GoogleSignInAccount googleSignInAccount) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;
  print(googleAuth.accessToken);
  return await _auth.signInWithCredential(GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken));
}

Future<Null> getGoogleJwt(GoogleSignInAccount googleSignInAccount) async {
  print("Entered for jwt retrival");
  GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;
  http.post(config.baseUrl+"/users/googleauth", body: {
    "token": googleAuth.idToken
  },).then((http.Response response) {
    print("GOOGLE SIGN_IN WITH ENDPOINT SUCCESSFUL");
    print(response.statusCode);
    print(response.body);
  });
}