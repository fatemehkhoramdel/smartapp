import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/constants/design_values.dart';
import '../../core/utils/extensions.dart';
import '../../providers/app_settings_provider.dart';
import '../../providers/main_provider.dart';

class PalettePickerDialogWidget extends StatelessWidget {
  const PalettePickerDialogWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int selectedThemePalette =
        context.read<MainProvider>().appSettings.selectedThemePalette;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPalette(context, 0, selectedThemePalette),
          SizedBox(height: 12.h),
          _buildPalette(context, 1, selectedThemePalette),
          SizedBox(height: 12.h),
          _buildPalette(context, 2, selectedThemePalette),
        ],
      ),
    );
  }

  Widget _buildPalette(
    BuildContext context,
    int position,
    int selectedThemePalette,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (selectedThemePalette == position) ...[
          Icon(Icons.arrow_forward, size: 16.w),
          const Spacer(),
        ],
        SizedBox(
          width: 0.47.sw,
          height: 40.h,
          child: GestureDetector(
            onTap: () async =>
                context.read<AppSettingsProvider>().updateAppTheme(position),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: ThemePalettesExt.getThemePalettesList()[position]
                          .value[3],
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(kBorderRadius.r),
                        bottomRight: Radius.circular(kBorderRadius.r),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: ThemePalettesExt.getThemePalettesList()[position]
                          .value[2],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: ThemePalettesExt.getThemePalettesList()[position]
                          .value[1],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: ThemePalettesExt.getThemePalettesList()[position]
                          .value[0],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(kBorderRadius.r),
                        bottomLeft: Radius.circular(kBorderRadius.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
