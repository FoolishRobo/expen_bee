import 'package:expen_bee/service/login_service.dart';
import 'package:expen_bee/view/dashboard/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expen_bee/constants/constants.dart';
import 'package:expen_bee/constants/app_colors.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoggingIn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: SafeArea(
        child: Center(
          child: InkWell(
            onTap: (){
              if(isLoggingIn) return;
              setState(() {
                isLoggingIn = true;
              });
              signInAnonymously();
            },
            child: Container(
              height: Constants.ctaButtonHeight,
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                gradient: AppColors.appGradient,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Center(
                child: isLoggingIn?CircularProgressIndicator():Text(
                  "Login Anonymously",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  signInAnonymously()async{
    _auth.signInAnonymously().then((result)async {
      await LoginService().checkIfUserAlreadyPresent();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
                (route) => false);
    });
  }

}
