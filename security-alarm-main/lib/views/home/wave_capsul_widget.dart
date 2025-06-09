import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supercharged/supercharged.dart';
// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math.dart' as vector;

import '../../core/constants/asset_constants.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/helper.dart';

class WaveCapsulWidget extends StatefulWidget {
  final double percentageValue;

  const WaveCapsulWidget({Key? key, this.percentageValue = 0.0})
      : super(key: key);

  @override
  WaveCapsulWidgetState createState() => WaveCapsulWidgetState();
}

class WaveCapsulWidgetState extends State<WaveCapsulWidget>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController waveAnimationController;
  Offset bottleOffset1 = Offset.zero;
  List<Offset> animList1 = [];
  Offset bottleOffset2 = const Offset(60, 0);
  List<Offset> animList2 = [];

  @override
  void initState() {
    animationController = AnimationController(
      duration: 2200.milliseconds,
      vsync: this,
    );
    waveAnimationController = AnimationController(
      duration: 5000.milliseconds,
      vsync: this,
    );
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
    waveAnimationController.addListener(() {
      animList1.clear();
      for (int i = -2 - bottleOffset1.dx.toInt(); i <= 60 + 2; i++) {
        animList1.add(
          Offset(
            i.toDouble() + bottleOffset1.dx.toInt(),
            math.sin(
                      (waveAnimationController.value * 360 - i) %
                          360 *
                          vector.degrees2Radians,
                    ) *
                    4 +
                ((100 - widget.percentageValue) * 160 / 100),
          ),
        );
      }
      animList2.clear();
      for (int i = -2 - bottleOffset2.dx.toInt(); i <= 60 + 2; i++) {
        animList2.add(
          Offset(
            i.toDouble() + bottleOffset2.dx.toInt(),
            math.sin(
                      (waveAnimationController.value * 360 - i) %
                          360 *
                          vector.degrees2Radians,
                    ) *
                    4 +
                ((100 - widget.percentageValue) * 160 / 100),
          ),
        );
      }
    });
    waveAnimationController.repeat();
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    waveAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: AnimatedBuilder(
        animation: CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
        builder: (context, child) => Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            ClipPath(
              clipper: WaveClipper(animationController.value, animList1),
              child: Container(
                decoration: BoxDecoration(
                  color: widget.percentageValue <= 25.0
                      ? Colors.red
                      : nearlyDarkBlue.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(80.0),
                    bottomLeft: Radius.circular(80.0),
                    bottomRight: Radius.circular(80.0),
                    topRight: Radius.circular(80.0),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      if (widget.percentageValue <= 25.0)
                        Colors.red.withOpacity(0.2)
                      else
                        nearlyDarkBlue.withOpacity(0.2),
                      if (widget.percentageValue <= 25.0)
                        Colors.red.withOpacity(0.5)
                      else
                        nearlyDarkBlue.withOpacity(0.5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            ClipPath(
              clipper: WaveClipper(animationController.value, animList2),
              child: Container(
                decoration: BoxDecoration(
                  color: nearlyDarkBlue,
                  gradient: LinearGradient(
                    colors: [
                      nearlyDarkBlue.withOpacity(0.3),
                      if (widget.percentageValue <= 25.0)
                        Colors.red
                      else
                        nearlyDarkBlue
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(80.0),
                    bottomLeft: Radius.circular(80.0),
                    bottomRight: Radius.circular(80.0),
                    topRight: Radius.circular(80.0),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 25.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'اعتبار\n${widget.percentageValue.floor()} ٪ ',
                    textAlign: TextAlign.center,
                    style: styleGenerator(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontColor: widget.percentageValue <= 25.0
                          ? Colors.black54
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 6,
              bottom: 8,
              child: ScaleTransition(
                scale: Tween(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animationController,
                    curve:
                        const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
                  ),
                ),
                child: Container(
                  width: 2,
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 24,
              right: 0,
              bottom: 16,
              child: ScaleTransition(
                scale: Tween(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animationController,
                    curve:
                        const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
                  ),
                ),
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 24,
              bottom: 32,
              child: ScaleTransition(
                scale: Tween(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animationController,
                    curve:
                        const Interval(0.6, 0.8, curve: Curves.fastOutSlowIn),
                  ),
                ),
                child: Container(
                  width: 3,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 20,
              bottom: 0,
              child: Transform(
                transform: Matrix4.translationValues(
                  0.0,
                  16 * (1.0 - animationController.value),
                  0.0,
                ),
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(
                      animationController.status == AnimationStatus.reverse
                          ? 0.0
                          : 0.4,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(kBottleAsset),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  final double animation;

  List<Offset> waveList1 = [];

  WaveClipper(this.animation, this.waveList1);

  @override
  Path getClip(Size size) {
    Path path = Path();

    path.addPolygon(waveList1, false);

    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) =>
      animation != oldClipper.animation;
}
