import 'package:flutter/material.dart';

class CustomElevatedButton extends StatefulWidget {

  final double width;
  final double? height;
  final Color? color;
  final Future<void> Function()? onPressed;
  final String label;
  final String? isSendingLabel;
  final TextStyle? style;
  final Widget? customLabel;

  const CustomElevatedButton({
    super.key, 
    required this.width, 
    this.height, 
    this.color, 
    this.onPressed, 
    required this.label,
    this.isSendingLabel,
    this.style,
    this.customLabel,
  });

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {

  bool isSending = false;

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final defaultHeight = widget.width / 3;
    final double borderRadius = (15 * (widget.height ?? defaultHeight)) / 50;

    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: WidgetStatePropertyAll(Size(widget.width, widget.height ?? defaultHeight)),
        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 15)),
        elevation: const WidgetStatePropertyAll(1),
        backgroundColor: WidgetStatePropertyAll(widget.color ?? colors.surfaceContainerHigh),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius))),
      ),
      onPressed: isSending 
        ? null
        : () async {
          isSending = true;
          setState(() {});
          await widget.onPressed!();
          isSending = false;
          // En create multiple taste pide que ponga esto al crear vino desde buscador
          if (context.mounted) {
            setState(() {});
          }
        },
      child: widget.customLabel ?? Text(
        isSending 
          ? widget.isSendingLabel ?? widget.label 
          : widget.label,
        style: widget.style,
      ),
    );
  }
}