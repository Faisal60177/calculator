import 'package:calculator/cubit/calculator_cubit.dart';
import 'package:calculator/cubit/calculator_state.dart';
import 'package:calculator/widgets/calculator_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalculatorScreen  extends StatelessWidget{
  const CalculatorScreen({super.key});

  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(child: Column(
        children: [
          const Expanded(flex: 2, child: _DisplayArea()),
          Expanded(flex : 5,child: Padding(padding: EdgeInsets.symmetric(horizontal: 8),
          child: _ButtonGrid(),),),
        ],
      )),
    );
  }
}

class _DisplayArea extends StatelessWidget{
  const _DisplayArea();

  Widget build(BuildContext context) {
    return BlocBuilder<CalculatorCubit, CalculatorState>(
        buildWhen: (prev, curr) =>
        prev.expressionLine != curr.expressionLine ||
        prev.resultLine != curr.resultLine ||
        prev.hasError != curr.hasError,
        builder: (context, state){
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 16),
            alignment: Alignment.bottomRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.bottomRight,
                  child: Text(
                    state.expressionLine,
                    style: TextStyle(
                      fontSize: 40,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 8,),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.bottomRight,
                  child: Text(
                    state.resultLine,
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w300,
                      color: state.hasError
                        ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                )
              ],
            ),
          );

        }
        );
  }
}

class _ButtonGrid extends StatelessWidget{
  @override
  Widget build(BuildContext context){

    final cubit = context.read<CalculatorCubit>();
    return Column(
      children: [
        Row(children: [
          CalculatorButton(label: 'AC', type: CalcButtonType.action, onPressed: cubit.clear),
          CalculatorButton(label: 'CE', type: CalcButtonType.action, onPressed: cubit.clearEntry),
          CalculatorButton(
              label: '%', type: CalcButtonType.action, onPressed: cubit.percentage),
          CalculatorButton(
              label: '÷',
              type: CalcButtonType.operatorBtn,
              onPressed: () => cubit.inputOperator('÷')),

        ],),
        Row(children: [
          CalculatorButton(label: '7',  onPressed: ()=> cubit.inputDigit('7')),
          CalculatorButton(label: '8', onPressed: () => cubit.inputDigit('8')),
          CalculatorButton(label: '9', onPressed: () => cubit.inputDigit('9')),
          CalculatorButton(
              label: '×',
              type: CalcButtonType.operatorBtn,
              onPressed: () => cubit.inputOperator('×')),
        ],),
        Row(children: [
          CalculatorButton(label: '4', onPressed: () => cubit.inputDigit('4')),
          CalculatorButton(label: '5', onPressed: () => cubit.inputDigit('5')),
          CalculatorButton(label: '6', onPressed: () => cubit.inputDigit('6')),
          CalculatorButton(
              label: '-',
              type: CalcButtonType.operatorBtn,
              onPressed: () => cubit.inputOperator('-')),
        ]),
        Row(children: [
          CalculatorButton(label: '1', onPressed: () => cubit.inputDigit('1')),
          CalculatorButton(label: '2', onPressed: () => cubit.inputDigit('2')),
          CalculatorButton(label: '3', onPressed: () => cubit.inputDigit('3')),
          CalculatorButton(
              label: '+',
              type: CalcButtonType.operatorBtn,
              onPressed: () => cubit.inputOperator('+')),
        ]),
        Row(children: [
          CalculatorButton(
              label: '⌫', type: CalcButtonType.action, onPressed: cubit.backspace),
          CalculatorButton(label: '0', onPressed: () => cubit.inputDigit('0')),
          CalculatorButton(label: '.', onPressed: cubit.inputDecimal),
          CalculatorButton(
              label: '=', type: CalcButtonType.equals, onPressed: cubit.calculate),
        ]),
      ],
    );
  }
}














