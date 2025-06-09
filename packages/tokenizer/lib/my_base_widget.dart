part of tokenizer;

class MyBaseWidget extends StatelessWidget {
  final Widget mobileChild;
  final Widget? tabletChild;
  final Widget? desktopChild;
  final PlatformAppBar? platformAppBar;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Key? scaffoldKey;
  final Color? backgroundColor;
  final bool hasSafeArea;
  final bool hasScrollView;

  const MyBaseWidget({
    Key? key,
    required this.mobileChild,
    this.tabletChild,
    this.desktopChild,
    this.platformAppBar,
    this.bottomNavigationBar,
    this.drawer,
    this.scaffoldKey,
    this.backgroundColor,
    this.hasSafeArea = false,
    this.hasScrollView = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return hasSafeArea
        ? GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: PlatformScaffold(
          scaffoldKey: scaffoldKey,
          backgroundColor: backgroundColor,
          appBar: platformAppBar,
          drawer: drawer,
          body: _buildBody(context),
          bottomNavigationBar: bottomNavigationBar,
        ),
      ),
    )
        : GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: PlatformScaffold(
        scaffoldKey: scaffoldKey,
        backgroundColor: backgroundColor,
        appBar: platformAppBar,
        drawer: drawer,
        body: _buildBody(context),
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final responsiveChild = MyResponsive(
      mobile: mobileChild,
      tablet: tabletChild ?? mobileChild,
      desktop: desktopChild ?? mobileChild,
    );

    return hasScrollView ? SingleChildScrollView(child: responsiveChild) : responsiveChild;
  }
}

class MyResponsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const MyResponsive({
    Key? key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (size.width >= 1100) {
      return desktop;
    } else if (size.width >= 650) {
      return tablet;
    } else {
      return mobile;
    }
  }
}
