import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import 'mobile/edit_relay_view_mobile.dart';

class EditRelayView extends StatelessWidget {
  const EditRelayView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('edit_relay')),
        centerTitle: true,
      ),
      body: EditRelayViewMobile(),
    );
  }
}
