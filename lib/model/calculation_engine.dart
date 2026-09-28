import 'calculator_operation.dart';

/// Lançada quando uma divisão por zero é tentada.
class DivisionByZeroException implements Exception {
  @override
  String toString() => 'Division by zero is not allowed';
}

class CalculationEngine {
  const CalculationEngine();

  double execute({
    required double firstOperand,
    required double secondOperand,
    required CalculatorOperation operation,
  }) {
    switch (operation) {
      case CalculatorOperation.add:
        return firstOperand + secondOperand;
      case CalculatorOperation.subtract:
        return firstOperand - secondOperand;
      case CalculatorOperation.multiply:
        return firstOperand * secondOperand;
      case CalculatorOperation.divide:
        if (secondOperand == 0) {
          throw DivisionByZeroException();
        }
        return firstOperand / secondOperand;
    }
  }
}
