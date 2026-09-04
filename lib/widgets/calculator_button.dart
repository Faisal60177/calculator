import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum CalcButtonType {number, operatorBtn, action, equals}

class CalculatorButton  extends StatelessWidget{
  final String label;
  final VoidCallback onPressed;
  final CalcButtonType type;
  final int flex;

  const CalculatorButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = CalcButtonType.number,
    this.flex = 1,
});

  Color _background(BuildContext context){
    final schema = Theme.of(context).colorScheme;
    switch(type){
      case CalcButtonType.operatorBtn:
        return schema.primary;
      case CalcButtonType.action:
        return schema.surfaceContainerHighest;
      case CalcButtonType.equals:
        return schema.tertiary;
      case CalcButtonType.number:
        return schema.surfaceContainerHigh;
    }
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
      case CalcButtonType.number:
        return scheme.onSurface;
    }
  }

  @override
  Widget build(BuildContext context){
    return Expanded(
        flex: flex,
        child: Padding(padding: const EdgeInsets.all(6),
        child: Material(
          color: _background(context),
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: (){
              HapticFeedback.lightImpact();
              onPressed();
            },

            child: AspectRatio(aspectRatio: flex == 2 ? 2.2 : 1,
            child: Align(
              alignment: flex ==2 ? const Alignment(-0.5, 0) : Alignment.center,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  color: _foreground(context),
                ),
              ),
            ),
            ),
          ),
        ),
        ),
    );
  }
}