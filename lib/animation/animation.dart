import 'package:flutter/cupertino.dart';

class Animations extends PageRouteBuilder {
  final dynamic page;

  Animations({this.page})
      : super(
            pageBuilder: (context, animation2, animationTwo) => page,
            transitionDuration: const Duration(seconds: 1),
            reverseTransitionDuration: const Duration(seconds: 1),
            transitionsBuilder: (context, animation1, animationTwo, child) {
              var begin = const Offset(0, 1);
              var end = const Offset(0, 0);
              var tween = Tween(begin: begin, end: end);
              var curvanimation = CurvedAnimation(
                  parent: animation1,
                  curve: Curves.linear,
                  reverseCurve: Curves.linear);
              return SlideTransition(
                position: tween.animate(curvanimation),
                child: child,
              );
              // var begin= 0.0;
              // var end =1.0;
              // var tween= Tween(begin:  begin,end:  end);
              // var offsetanimation= animation.drive(tween);
              // var curvanimation= CurvedAnimation(parent: animation, curve: Curves.easeInCirc);
              // return ScaleTransition(scale: tween.animate(curvanimation),child: child,);
              // var begin= 0.0;
              // var end =1.0;
              //
              //
              //
              //
              // var tween= Tween(begin:  begin,end:  end);
              // // var offsetanimation= animation.drive(tween);
              // var curvanimation= CurvedAnimation(parent: animation, curve: Curves.easeInOutCubicEmphasized);
              // return RotationTransition(turns: tween.animate(curvanimation),child: child,);
              // return Align(
              //     alignment: Alignment.center,
              //     child: SizeTransition(
              //       sizeFactor: animation,
              //       child: child,
              //     ));
              // var begin= 0.0;
              // var end =1.0;
              // var tween= Tween(begin:  begin,end:  end);
              // var offsetanimation= animation.drive(tween);
              // var curvanimation= CurvedAnimation(parent: animation, curve: Curves.easeInOutCubicEmphasized);
              // return FadeTransition(opacity: animation,child: RotationTransition(turns: tween.animate(curvanimation),child: child,),);
            });
}
