import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

import '../../config/routes/app_routes.dart';
import '../../core/constants/asset_constants.dart';
import '../../core/constants/global_keys.dart';
import '../../core/utils/helper.dart';

class DrawerMenuWidget extends StatelessWidget {
  final GlobalKey<SliderDrawerState>? drawerKey;
  
  const DrawerMenuWidget({Key? key, this.drawerKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0XFF122950),
      child: SingleChildScrollView(
        child: SizedBox(
          height: 1.sh,
          child: Column(
            children: <Widget>[
              SizedBox(height: 40.h),
              _buildHeaderImage(),
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
                child: const Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.white54,
                ),
              ),
              // sliderItem(
              //   translate('add_device'),
              //   Icons.add_circle,
              //   () {
              //     closeDrawerAndRoute(AppRoutes.addDeviceRoute, context);
              //   },
              // ),
              // sliderItem(
              //   translate('charge_device'),
              //   Icons.attach_money_rounded,
              //   () {
              //     closeDrawerAndRoute(AppRoutes.chargeDeviceRoute, context);
              //   },
              // ),
              // sliderItem(
              //   translate('device_setting'),
              //   Icons.settings,
              //   () {
              //     closeDrawerAndRoute(AppRoutes.deviceSettingsRoute, context);
              //   },
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              //   child: const Divider(
              //     height: 1,
              //     thickness: 1,
              //     color: Colors.white54,
              //   ),
              // ),
              // sliderItem(
              //   translate('advance_tools'),
              //   Icons.settings_input_component_rounded,
              //   () {
              //     closeDrawerAndRoute(AppRoutes.advanceToolsRoute, context);
              //   },
              // ),
              // sliderItem(
              //   translate('contacts'),
              //   Icons.phone,
              //   () {
              //     closeDrawerAndRoute(AppRoutes.contactsRoute, context);
              //   },
              // ),
              // sliderItem(
              //   translate('zones'),
              //   Icons.control_camera,
              //   () {
              //     closeDrawerAndRoute(AppRoutes.zonesRoute, context);
              //   },
              // ),
              sliderItem(
                translate('خانه'),
                Icons.home,
                () {
                  closeDrawerAndRoute(AppRoutes.homeRoute, context);
                },
              ),
              sliderItem(
                translate('scenario'),
                Icons.movie_outlined,
                () {
                  closeDrawerAndRoute(AppRoutes.scenarioRoute, context);
                },
              ),
              sliderItem(
                translate('scheduling'),
                Icons.schedule,
                () {
                  closeDrawerAndRoute(AppRoutes.schedulingRoute, context);
                },
              ),
              sliderItem(
                translate('smart_control'),
                Icons.smart_button,
                () {
                  closeDrawerAndRoute(AppRoutes.smartControlRoute, context);
                },
              ),
              // sliderItem(
              //   translate('android_app_settings'),
              //   Icons.settings_cell_rounded,
              //   () {
              //     closeDrawerAndRoute(
              //       AppRoutes.applicationSettingsRoute,
              //       context,
              //     );
              //   },
              // ),
              // sliderItem(
              //   translate('guide'),
              //   Icons.help,
              //   () {
              //     closeDrawerAndRoute(AppRoutes.guideRoute, context);
              //   },
              // ),
              // sliderItem(
              //   translate('about_us'),
              //   Icons.info,
              //   () {
              //     closeDrawerAndRoute(AppRoutes.aboutUsRoute, context);
              //   },
              // ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
                child: const Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.white54,
                ),
              ),
              sliderItem(
                translate('exit'),
                Icons.exit_to_app,
                exitApp,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    return CircleAvatar(
      radius: 60.w,
      backgroundColor: Colors.transparent,
      child: CircleAvatar(
        radius: 55.w,
        backgroundColor: Colors.transparent,
        child: Image.asset(kLogoAsset),
        // backgroundImage: const AssetImage(kIconLauncherAsset),
      ),
    );
  }

  void closeDrawerAndRoute(String routeName, BuildContext context) {
    // Close drawer using the provided key
    if (drawerKey != null && drawerKey!.currentState != null) {
      drawerKey!.currentState!.toggle();
    }
    
    // Manejar la navegación a la pantalla de inicio de forma especial
    if (routeName == AppRoutes.homeRoute) {
      // Obtener la ruta actual
      final currentRoute = ModalRoute.of(context)?.settings.name;
      
      // Si ya estamos en la pantalla de inicio, solo cerramos el drawer sin navegar
      if (currentRoute == AppRoutes.homeRoute) {
        return;
      }
      
      // Si estamos en otra pantalla, reemplazamos la pantalla actual en lugar de apilar
      Navigator.pushNamedAndRemoveUntil(
        context, 
        AppRoutes.homeRoute,
        (route) => false, // Eliminar todas las rutas anteriores
      );
    } else {
      // Para otras rutas, comportamiento normal
      Navigator.pushNamed(context, routeName);
    }
  }

  void exitApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }

  Widget sliderItem(String title, IconData icons, Function()? onItemClick) =>
      Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onItemClick,
          child: ListTile(
            contentPadding: EdgeInsets.only(right: 20.w),
            title: Text(
              title,
              style: styleGenerator(fontSize: 14, fontColor: Colors.white),
            ),
            leading: Icon(icons, color: Colors.white60),
          ),
        ),
      );
}
