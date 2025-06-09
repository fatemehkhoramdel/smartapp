part of tokenizer;

/// Base class to be extended by all platform aware widgets
abstract class PlatformWidget extends StatelessWidget {
  Widget buildCupertinoWidget(BuildContext context);
  Widget buildMaterialWidget(BuildContext context);

  const PlatformWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      /// Use Cupertino on iOS
      return buildCupertinoWidget(context);
    }

    /// Use Material design on Android and other platforms
    return buildMaterialWidget(context);
  }
}
