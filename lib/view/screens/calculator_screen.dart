import 'package:flutter/material.dart';

import '../../model/calculator_operation.dart';
import '../../viewmodel/calculator_viewmodel.dart';
import '../widgets/calculator_display.dart';
import '../widgets/calculator_keypad.dart';

/// Mapeia o rótulo de uma tecla (como exibido no teclado) para uma
/// operação, quando aplicável.
const Map<String, CalculatorOperation> _operationsByLabel = {
  '÷': CalculatorOperation.divide,
  '×': CalculatorOperation.multiply,
  '-': CalculatorOperation.subtract,
  '+': CalculatorOperation.add,
};

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final CalculatorViewModel _viewModel = CalculatorViewModel();

  void _handleKeyPress(String label) {
    setState(() => _dispatch(label));
  }

  void _dispatch(String label) {
    final CalculatorOperation? operation = _operationsByLabel[label];
    if (operation != null) {
      _viewModel.selectOperation(operation);
      return;
    }

    switch (label) {
      case 'AC':
        _viewModel.clear();
        break;
      case '+/-':
        _viewModel.toggleSign();
        break;
      case '%':
        _viewModel.applyPercentage();
        break;
      case '=':
        _viewModel.calculateResult();
        break;
      case '.':
        _viewModel.inputDecimalPoint();
        break;
      default:
        _viewModel.inputDigit(label);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: CalculatorDisplay(
                key: const Key('calculatorDisplay'),
                text: _viewModel.display,
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CalculatorKeypad(
                  onKeyPressed: _handleKeyPress,
                  activeOperatorSymbol: _viewModel.pendingOperationSymbol,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
