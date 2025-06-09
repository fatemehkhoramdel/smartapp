part of tokenizer;

class PlatformScaffold extends PlatformWidget {
  final Key? scaffoldKey;
  final PlatformAppBar? appBar;
  final Color? backgroundColor;
  final Widget body;
  final Widget? drawer;
  final Widget? bottomNavigationBar;

  const PlatformScaffold({
    required this.body,
    this.appBar,
    this.scaffoldKey,
    this.backgroundColor,
    this.drawer,
    this.bottomNavigationBar,
  });

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoPageScaffold(
      key: scaffoldKey,
      backgroundColor: backgroundColor,
      navigationBar: appBar?.buildCupertinoWidget(context)
          as ObstructingPreferredSizeWidget?,
      child: Material(
        type: MaterialType.transparency,
        child: body,
      ),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: backgroundColor,
      drawer: drawer,
      bottomNavigationBar: bottomNavigationBar,
      appBar: appBar?.buildMaterialWidget(context) as PreferredSizeWidget?,
      body: body,
    );
  }
}
