import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/constants.dart';
import '../../../core/utils/helper.dart';

class AboutUsViewMobile extends StatelessWidget {
  const AboutUsViewMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      height: 1.0.sh,
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBackButton(context),
          SizedBox(height: 60.h),
          _buildTitle(),
          _buildDivider(),
          SizedBox(height: 25.h),
          _aboutText(),
          SizedBox(height: 5.h),
          _siteText(),
          SizedBox(height: 25.h),
          _buildDivider(),
          SizedBox(height: 15.h),
          _buildVersionText(),
          SizedBox(height: 5.h),
          _buildVersionNumber(),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_rounded,
        color: Colors.white,
        size: 22.w,
      ),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _buildTitle() {
    return Text(
      translate('app_title'),
      style: styleGenerator(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        fontColor: Colors.white,
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 0.3.sw,
      margin: EdgeInsets.only(top: 8.h),
      child: const Divider(
        height: 3,
        thickness: 3,
        color: Colors.white,
      ),
    );
  }

  Widget _buildVersionText() {
    return Text(
      translate('version'),
      style: styleGenerator(
        fontSize: 13,
        fontWeight: FontWeight.w300,
        fontColor: Colors.white60,
      ),
    );
  }

  Widget _aboutText() {
    return Text(
      translate('about'),
      style: styleGenerator(
        fontSize: 15,
        fontWeight: FontWeight.w300,
        fontColor: Colors.white,
      ),
      textAlign: TextAlign.justify,
    );
  }

  Widget _siteText() {
    return Row(
      children: [
        Text(
          translate('support'),
          style: styleGenerator(
            fontSize: 15,
            fontWeight: FontWeight.w300,
            fontColor: Colors.white,
          ),
          textAlign: TextAlign.justify,
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            launchUrl(Uri.parse('http://www.danaguarantee.com'));
          },
          child: Text(
            translate('site'),
            style: styleGenerator(
              fontSize: 15,
              fontWeight: FontWeight.w300,
              fontColor: Colors.blue,
            ),
            textAlign: TextAlign.justify,
          ),
        )
      ],
    );
  }

  Widget _buildVersionNumber() {
    return Text(
      kAppVersion,
      style: styleGenerator(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontColor: Colors.white,
      ),
    );
  }
}
