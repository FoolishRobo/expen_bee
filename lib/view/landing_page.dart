import 'package:expen_bee/constants/app_colors.dart';
import 'package:expen_bee/enum/login_status.dart';
import 'package:expen_bee/service/login_service.dart';
import 'package:expen_bee/view/dashboard/dashboard.dart';
import 'package:expen_bee/view/login/login.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with SingleTickerProviderStateMixin {
  AnimationController animationController;


  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 1),
    );
    animationController.repeat();
    redirect();
  }

  void redirect()async{
    await Future.delayed(Duration(seconds: 3));
    if(LoginService().checkLoginStatus() == LOGIN_STATUS.LoggedIn){
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
              (route) => false);
    }else{
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Login()),
              (route) => false);
    }
  }

  startRotation() {
    animationController.repeat();
  }

  stopRotation() {
    animationController.stop();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Stack(
        children: [
          Center(
            child: AnimatedBuilder(
              animation: animationController,
              builder: (BuildContext context, Widget _widget) {
                return Transform.rotate(
                  angle: animationController.value * 6.3,
                  child: _widget,
                );
              },
              child: Container(
                height: MediaQuery.of(context).size.width / 2,
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  gradient: AppColors.appGradient,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              "Ambee",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
