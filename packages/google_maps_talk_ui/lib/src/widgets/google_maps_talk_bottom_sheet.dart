import 'package:flutter/material.dart';
import 'package:google_maps_talk_ui/src/extensions/theme_context.dart';

class GoogleMapsTalkBottomSheet extends StatelessWidget {
  const GoogleMapsTalkBottomSheet({
    super.key,
    this.onClosing,
    this.onDismiss,
    this.title,
    this.body,
  });

  static void showModal<T>(
    BuildContext context, {
    VoidCallback? onClosing,
    VoidCallback? onDismiss,
    String? title,
    Widget? body,
    bool isScrollControlled = true,
    bool showDragHandle = true,
  }) {
    showModalBottomSheet<T>(
      context: context,
      showDragHandle: showDragHandle,
      isScrollControlled: isScrollControlled,
      constraints: BoxConstraints(
        maxHeight: context.screenSize.height * 0.8,
        minHeight: context.screenSize.height * 0.2,
      ),
      builder: (_) => GoogleMapsTalkBottomSheet(
        onClosing: onClosing,
        title: title,
        body: body,
      ),
    ).then((_) => onDismiss?.call());
  }

  final VoidCallback? onClosing;

  final VoidCallback? onDismiss;

  final String? title;

  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () => onClosing,
      showDragHandle: false,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  title!,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ),
            if (body != null) body!,
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
