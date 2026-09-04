class CalculatorEngine {
  static const operators = ['+', '_', '×', '÷'];

  static double? evaluate(List<String> tokens){
    if(tokens.isEmpty) return 0;
    final numbers = <double>[];
    final ops = <String>[];
    for(var i = 0; i < tokens.length; i++){
      if(i.isEven){
        numbers.add(double.tryParse(tokens[i])?? 0);
      }else {
        ops.add(tokens[i]);
      }
    }


  final pass1Numbers = [numbers.first];
    final pass1Ops= <String>[];
    for(var i = 0; i < ops.length; i++){
      final next = numbers[i + 1];
      if(ops[i] == '×'){
        pass1Numbers[pass1Numbers.length - 1] *= next;
      } else if(ops[i] == '÷'){
        if(next == 0) return null;
        pass1Numbers[pass1Numbers.length - 1] /= next;
      } else{
        pass1Ops.add(ops[i]);
        pass1Numbers.add(next);
      }
    }


    var result = pass1Numbers.first;
    for(var i = 0; i < pass1Ops.length; i++){
      result = pass1Ops[i] == '+'
          ? result + pass1Numbers[i + 1]
          : result - pass1Numbers[i + 1];
    }
    return result;
  }

  static String format(double value){
    if(value.isNaN || value.isInfinite) return 'Error';
    String s = value.toStringAsFixed(10);
    if(s.contains('.')){
      s = s.replaceFirst(RegExp(r'0+$'), '');
      s = s.replaceFirst(RegExp(r'\.$'), '');
    }
    final asDouble = double.tryParse(s) ?? value;
    if(asDouble.abs() >= 1e15 || (asDouble != 0 && asDouble.abs() < 1e-9)){
      return value.toStringAsExponential(6);
    }
    return s.isEmpty ? '0' : s;
  }

}