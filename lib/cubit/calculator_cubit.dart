import 'dart:convert';
import 'package:calculator/core/calculator_engine.dart';
import 'package:calculator/cubit/calculator_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalculatorCubit  extends Cubit<CalculatorState>{
  CalculatorCubit() : super(CalculatorState.initial());

  static const int _maxDigitsPerNumber = 15;
  static const int _maxTokens = 40;

  bool get _lastIsNumber =>
      state.tokens.isNotEmpty && state.tokens.length.isOdd;
  bool get _lastIsOperator =>
      state.tokens.isNotEmpty && state.tokens.length.isEven;

  void inputDigit(String digit){
    if(state.hasError || state.justEvaluated){
      _emitTokens([digit], justEvaluated: false);
      return;
    }
    if(state.tokens.length >= _maxTokens) return;
    final tokens = [...state.tokens];
    if(tokens.isEmpty || _lastIsOperator){
      tokens.add(digit);
    }else {
      final current = tokens.last;
      final digitsOnly = current.replaceAll(RegExp(r'[-.]'), '');
      if(digitsOnly.length >= _maxDigitsPerNumber) return;
      tokens[tokens.length - 1] = current == '0' ? digit : current + digit;
    }
    _emitTokens(tokens);
  }

  void inputDecimal() {
    if (state.hasError || state.justEvaluated) {
      _emitTokens(['0.'], justEvaluated: false);
      return;
    }
    final tokens = [...state.tokens];
    if (tokens.isEmpty || _lastIsOperator) {
      tokens.add('0.');
    } else if (!tokens.last.contains('.')) {
      tokens[tokens.length - 1] = '${tokens.last}.';
    } else {
      return;
    }
    _emitTokens(tokens);
  }

  void inputOperator(String operator){
    if(state.hasError) return;
    final tokens = [...state.tokens];
    if (state.justEvaluated) {
      _emitTokens([state.resultLine, operator], justEvaluated: false);
      return;
    }

    if(tokens.isEmpty){
      if(operator == '-') tokens.add('-0');
      return _emitTokens(tokens);
    }
    if (_lastIsOperator) {
      tokens[tokens.length - 1] = operator;
    } else {
      tokens.add(operator);
    }
    _emitTokens(tokens);
  }

  void toggleSign(){
    if(state.hasError || !_lastIsNumber)return;
    final tokens = [...state.tokens];
    final last = tokens.last;
    tokens[tokens.length - 1] = last.startsWith('-')? last.substring(1) : '-$last';
    _emitTokens(tokens);
  }

  void percentage(){
    if (state.hasError || !_lastIsNumber) return;
    final value = double.tryParse(state.tokens.last);
    if(value == null) return;
    final tokens = [...state.tokens];
    tokens[tokens.length - 1] = CalculatorEngine.format(value / 100);
    _emitTokens(tokens);
  }

  void backspace(){
    if(state.hasError) return clear();
    if(state.tokens.isEmpty) return;
    final tokens = [...state.tokens];
    final last = tokens.last;
    if(last.length <= 1 ||(last.length == 2 && last.startsWith('-'))){
      tokens.removeLast();
    }else {
      tokens[tokens.length -1] = last.substring(0, last.length -1);
    }
    _emitTokens(tokens, justEvaluated: false);
  }

  void calculate(){
    if (state.hasError || state.tokens.isEmpty) return;
    final evaluable =
        _lastIsOperator ? state.tokens.sublist(0, state.tokens.length - 1) : state.tokens;
    if(evaluable.isEmpty) return;
    final result = CalculatorEngine.evaluate(evaluable);
    if(result == null){

      emit(state.copyWith(
        tokens: const[],
        expressionLine: '',
        resultLine: 'Cannot divide by zero',
        hasError: true,
        justEvaluated: false,
      ));
      return;
    }
    final formatted = CalculatorEngine.format(result);
    emit(state.copyWith(
        tokens: [formatted],
      expressionLine: '',
      resultLine: formatted,
      hasError: false,
      justEvaluated: true,
    ));
  }

  void clear() => emit(CalculatorState.initial());

  void clearEntry(){
    if(state.hasError) return clear();
    if(!_lastIsNumber) return;
    final tokens = [...state.tokens];
    tokens[tokens.length - 1] = '0';
    _emitTokens(tokens, justEvaluated: false);
  }

  void _emitTokens(List<String> tokens, {bool justEvaluated = false}){
    final evaluable = (tokens.isNotEmpty && tokens.length.isEven)
        ? tokens.sublist(0, tokens.length - 1)
        : tokens;
    final preview =
        evaluable.isEmpty ? null : CalculatorEngine.evaluate(evaluable);
    emit(state.copyWith(
      tokens: tokens,
      expressionLine: tokens.join(),
      resultLine: preview ==null
        ? (tokens.isEmpty ? '0' : state.resultLine)
          : CalculatorEngine.format(preview),
      hasError: false,
      justEvaluated: justEvaluated,

    ));
  }

}