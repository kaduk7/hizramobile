import 'package:flutter/material.dart';
import 'package:hizramobile/pages/home_page.dart';
import 'package:local_auth/local_auth.dart';

class FaceVerificationPage extends StatefulWidget {
  @override
  _FaceVerificationPageState createState() => _FaceVerificationPageState();
}

class _FaceVerificationPageState extends State<FaceVerificationPage> {
  final LocalAuthentication auth = LocalAuthentication();
  String _authorized = 'Not Authorized';

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
          localizedReason: 'Scan your face to authenticate',
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true);
    } catch (e) {
      print('manyp:$e');
    }

    if (!mounted) return;

    setState(() {
      _authorized = authenticated ? 'Authorized' : 'Not Authorized';
    });

    if (authenticated) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Verification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Status: $_authorized'),
            ElevatedButton(
              onPressed: _authenticate,
              child: Text('Verify Face'),
            ),
          ],
        ),
      ),
    );
  }
}
