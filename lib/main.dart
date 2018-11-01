import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

void main() {
  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _state createState() => new _state();
}

class _state extends State<MyApp> {
  String _status;

  @override
  void initState() {
    _status = 'Not Authenticated';
    super.initState();
  }

  void _signInGoogle() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    if (user != null && !user.isAnonymous) {
      setState(() {
        _status = 'Signed in as ${user.displayName}';
      });
    } else {
      setState(() {
        _status = 'Signed in Failed';
      });
    }
    print("signed in " + user.displayName);
  }

  void _signInAnon() async {
    FirebaseUser user = await _auth.signInAnonymously();

    if (user != null && user.isAnonymous) {
      setState(() {
        _status = 'Signed in Anonymously';
      });
    } else {
      setState(() {
        _status = 'Signed in Failed';
      });
    }
  }

  void _signOut() async {
    await _auth.signOut();
    setState(() {
      _status = 'Signed Out';
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('My Title'),
      ),
      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text(_status),
              new RaisedButton(
                onPressed: _signInAnon,
                child: new Text('Sign In Anonymously'),
              ),
              new RaisedButton(
                onPressed: _signOut,
                child: new Text('Sign Out'),
              ),
              new RaisedButton(
                onPressed: _signInGoogle,
                child: new Text('Sign in With Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
