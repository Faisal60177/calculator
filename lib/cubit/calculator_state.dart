import 'package:equatable/equatable.dart';

class CalculatorState extends Equatable {
  final List<String> tokens;
  final String expressionLine;
  final String resultLine;
  final bool hasError;
  final bool justEvaluated;

  final double memoryValue;

  const CalculatorState({
    required this.tokens,
    required this.expressionLine,
    required this.resultLine,
    required this.hasError,
    required this.justEvaluated,
    required this.memoryValue,
  });

  factory CalculatorState.initial() => const CalculatorState(
      tokens: [],
      expressionLine: '',
      resultLine: '0',
      hasError: false,
      justEvaluated: false,
      memoryValue: 0);

  bool get hasMemory => memoryValue != 0;

  CalculatorState copyWith({
    List<String>? tokens,
    String? expressionLine,
    String? resultLine,
    bool? hasError,
    bool? justEvaluated,
    double? memoryValue,
  }) {
    return CalculatorState(
      tokens: tokens ?? this.tokens,
      expressionLine: expressionLine ?? this.expressionLine,
      resultLine: resultLine ?? this.resultLine,
      hasError: hasError ?? this.hasError,
      justEvaluated: justEvaluated ?? this.justEvaluated,
      memoryValue: memoryValue ?? this.memoryValue,
    );
  }

  @override
  List<Object?> get props =>
      [tokens, expressionLine, resultLine, hasError, justEvaluated, memoryValue];
}