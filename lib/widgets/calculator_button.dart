import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum CalcButtonType { number, operatorBtn, action, equals, memory }

class CalculatorButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final CalcButtonType type;
  final int flex;

  const CalculatorButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = CalcButtonType.number,
    this.flex = 1,
  });

  Color _background(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    switch (type) {
      case CalcButtonType.operatorBtn:
        return scheme.primary;
      case CalcButtonType.action:
        return scheme.surfaceContainerHighest;
      case CalcButtonType.equals:
        return scheme.tertiary;
      case CalcButtonType.memory:
        return Colors.transparent;
      case CalcButtonType.number:
        return scheme.surfaceContainerHigh;
    }
  }

  ShapeBorder? _shape() {
    if (type == CalcButtonType.memory) return null;
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(28));
  }

  Color _foreground(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    switch (type) {
      case CalcButtonType.operatorBtn:
        return scheme.onPrimary;
      case CalcButtonType.equals:
        return scheme.onTertiary;
      case CalcButtonType.action:
        return scheme.onSurfaceVariant;
      case CalcButtonType.memory:
        return onPressed == null
            ? scheme.onSurfaceVariant.withOpacity(0.35)
            : scheme.primary;
      case CalcButtonType.number:
        return scheme.onSurface;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFlat = type == CalcButtonType.memory;
    return Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.all(isFlat ? 4 : 6),
        child: Material(
          color: _background(context),
          shape: _shape(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed == null
                ? null
                : () {
              HapticFeedback.lightImpact();
              onPressed!();
            },

            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: isFlat ? 18 : 26,
                  fontWeight: isFlat ? FontWeight.w600 : FontWeight.w500,
                  color: _foreground(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}