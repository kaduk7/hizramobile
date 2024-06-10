import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class AuthService {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      // Using the correct parameters as per the latest documentation
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your face to authenticate',
        biometricOnly: true,  // Ensures only biometrics are used (not PIN, pattern, or password)
        useErrorDialogs: true, // Use built-in dialogs for errors.
        stickyAuth: true,     // Persistent authentication sessions
      );
    } on PlatformException catch (e) {
      print('Failed to authenticate: ${e.toString()}');
    }
    return authenticated;
  }
}
