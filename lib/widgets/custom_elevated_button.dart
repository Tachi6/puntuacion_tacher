import 'package:flutter/material.dart';

class CustomElevatedButton extends StatefulWidget {

  final double width;
  final double? height;
  final Color? color;
  final Future<void> Function()? onPressed;
  final Widget child;
  final Widget? isLoadingchild;

  const CustomElevatedButton({
    super.key, 
    required this.width, 
    this.height, 
    this.color, 
    this.onPressed, 
    required this.child,
    this.isLoadingchild,
  });

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final defaultHeight = widget.width / 3;
    final double borderRadius = (15 * (widget.height ?? defaultHeight)) / 50;

    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: WidgetStatePropertyAll(Size(widget.width, widget.height ?? defaultHeight)),
        elevation: const WidgetStatePropertyAll(1),
        backgroundColor: WidgetStatePropertyAll(widget.color ?? colors.surfaceContainerHigh),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius))),
      ),
      onPressed: () async {
        isLoading = true;
        setState(() {});
        await widget.onPressed!();
        isLoading = true;
        setState(() {});
      },
      child: (isLoading && widget.isLoadingchild != null)  
        ? widget.isLoadingchild
        : widget.child,
    );
  }
}