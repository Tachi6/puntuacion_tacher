import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key, 
    required this.widgetButton, 
    this.leading, 
    this.trailing,
  });

  final Widget widgetButton;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    
    return SafeArea(
      top: false,
      child: Material(
        elevation: 2,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        color: colors.surfaceDim,
        child: Container(
          height: 58,
          width: double.infinity,
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              leading != null || trailing != null 
                ? SizedBox(
                  height: 58, 
                  width: 58, 
                  child: leading
                )
                : const SizedBox(),
        
              widgetButton,
        
              leading != null || trailing != null
                ? SizedBox(
                  height: 58, 
                  width: 58, 
                  child: trailing
                )
                : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
