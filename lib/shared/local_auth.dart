import 'package:flutter/services.dart';
import 'package:flutter_local_auth_invisible/auth_strings.dart';
import 'package:flutter_local_auth_invisible/flutter_local_auth_invisible.dart';
import 'package:flutter_local_auth_invisible/error_codes.dart' as auth_error;

class LocalAuthApi{

  static Future<bool> hasBiometrics()async {
    try{
      return await LocalAuthentication.canCheckBiometrics;
    } on PlatformException catch (e){
      return false;
    }
  }


  static Future<bool> authenticate()async{

    final isAvailable = await hasBiometrics();

    if(!isAvailable) return false;

    try{
        return await LocalAuthentication.authenticate(

            androidAuthStrings: const AndroidAuthMessages(
                signInTitle: 'التحقق من البصمه للدخول',
                cancelButton: 'رجوع',
                biometricHint: ''
              ),
            iOSAuthStrings: const IOSAuthMessages(
                cancelButton: 'رجوع',
            ),
            localizedReason: " ",
            useErrorDialogs: true,
            stickyAuth: true,
            biometricOnly: true,
        );
    } on PlatformException catch (e){
      if(e.code == auth_error.notAvailable){
        print("NOT RECO\n");
      }
      return false;
    }
  }
}