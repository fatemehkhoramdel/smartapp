import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:supercharged/supercharged.dart';

import '../../../core/constants/asset_constants.dart';
import '../../../providers/splash_provider.dart';

class SplashViewMobile extends StatelessWidget {
  late SplashProvider _splashProvider;

  SplashViewMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _splashProvider = context.read<SplashProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.delayed(600.milliseconds).then(
        (value) => _splashProvider.initialSetup(),
      );
    });

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [
              0.0,
              0.5,
              1.0,
            ],
            colors: <Color>[Color(0xFF09162E), Color(0xFF265DC0), Color(0xFF09162E),]),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('TPMAX',
            style: TextStyle(
              color: Color(0X80D5E2FA),
              fontSize: 36,
            ),
            ),
            const Text('دزد گیر  تی پی مکس',
            style: TextStyle(
              color: Color(0X80D5E2FA),
              fontSize: 36,
            ),
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              width: 280.h,
              height: 280.h,
              child: Image.asset(kLogoAsset),
            ),
            const Text('دزد گیر هوشمند',
              style: TextStyle(
                color: Colors.transparent,
                fontSize: 36,
              ),
            ),
            const Text('دزد گیر هوشمند',
              style: TextStyle(
                color: Colors.transparent,
                fontSize: 36,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }
}
