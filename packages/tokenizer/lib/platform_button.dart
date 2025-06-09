part of tokenizer;

class PlatformButton extends PlatformWidget {
  final Widget child;
  final Color color;
  final VoidCallback onPressed;

  const PlatformButton({
    Key? key,
    required this.child,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoButton(
      color: color,
      pressedOpacity: 0.5,
      onPressed: onPressed,
      child: child,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return MaterialButton(
      color: color,
      onPressed: onPressed,
      child: child,
    );
  }
}
