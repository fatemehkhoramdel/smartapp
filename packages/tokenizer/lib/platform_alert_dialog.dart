part of tokenizer;

class PlatformAlertDialog extends PlatformWidget {
  const PlatformAlertDialog({
    required this.title,
    required this.content,
    this.cancelText,
    required this.confirmText,
  });

  final Widget title;
  final Widget content;
  final String? cancelText;
  final String confirmText;

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: _actions(
        context,
        cancelText?.toUpperCase(),
        confirmText.toUpperCase(),
      ),
    );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: title,
      content: content,
      actions: _actions(context, cancelText, confirmText),
    );
  }

  List<Widget> _actions(
    BuildContext context,
    String? cancelText,
    String confirmText,
  ) {
    final actions = <Widget>[];
    if (cancelText != null) {
      actions.add(
        PlatformAlertDialogAction(
          onPressed: () => _dismiss(context, false),
          child: Text(cancelText),
        ),
      );
    }
    actions.add(
      PlatformAlertDialogAction(
        onPressed: () => _dismiss(context, true),
        child: Text(confirmText),
      ),
    );
    return actions;
  }

  Future<bool> show(BuildContext context) async {
    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return this;
      },
    ) as bool;
    return Future.value(result);
  }

  void _dismiss(BuildContext context, bool value) {
    Navigator.pop(context, value);
  }
}

class PlatformAlertDialogAction extends PlatformWidget {
  final Widget child;
  final VoidCallback onPressed;

  const PlatformAlertDialogAction({
    required this.child,
    required this.onPressed,
  });

  @override
  MaterialButton buildMaterialWidget(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: child,
    );
  }

  @override
  CupertinoDialogAction buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      onPressed: onPressed,
      child: child,
    );
  }
}
