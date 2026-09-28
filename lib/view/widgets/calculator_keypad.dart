import 'package:flutter/material.dart';

import 'calculator_button.dart';

/// Papel visual de uma tecla, usado para definir suas cores.
enum CalculatorKeyType { digit, function, operatorKey, equals }

/// Descrição estática de uma tecla da calculadora: seu rótulo e seu papel.
class CalculatorKeyData {
  const CalculatorKeyData(this.label, this.type, {this.flex = 1});

  final String label;
  final CalculatorKeyType type;
  final int flex;
}

/// O teclado completo da calculadora, organizado em linhas de
/// [CalculatorButton]s.
class CalculatorKeypad extends StatelessWidget {
  const CalculatorKeypad({
    super.key,
    required this.onKeyPressed,
    required this.activeOperatorSymbol,
  });

  final ValueChanged<String> onKeyPressed;

  /// Símbolo do operador atualmente pendente, para que sua tecla possa ser
  /// destacada (ex.: "+" enquanto o usuário digita o segundo operando).
  final String? activeOperatorSymbol;

  static const List<List<CalculatorKeyData>> _rows = [
    [
      CalculatorKeyData('AC', CalculatorKeyType.function),
      CalculatorKeyData('+/-', CalculatorKeyType.function),
      CalculatorKeyData('%', CalculatorKeyType.function),
      CalculatorKeyData('÷', CalculatorKeyType.operatorKey),
    ],
    [
      CalculatorKeyData('7', CalculatorKeyType.digit),
      CalculatorKeyData('8', CalculatorKeyType.digit),
      CalculatorKeyData('9', CalculatorKeyType.digit),
      CalculatorKeyData('×', CalculatorKeyType.operatorKey),
    ],
    [
      CalculatorKeyData('4', CalculatorKeyType.digit),
      CalculatorKeyData('5', CalculatorKeyType.digit),
      CalculatorKeyData('6', CalculatorKeyType.digit),
      CalculatorKeyData('-', CalculatorKeyType.operatorKey),
    ],
    [
      CalculatorKeyData('1', CalculatorKeyType.digit),
      CalculatorKeyData('2', CalculatorKeyType.digit),
      CalculatorKeyData('3', CalculatorKeyType.digit),
      CalculatorKeyData('+', CalculatorKeyType.operatorKey),
    ],
    [
      CalculatorKeyData('0', CalculatorKeyType.digit, flex: 2),
      CalculatorKeyData('.', CalculatorKeyType.digit),
      CalculatorKeyData('=', CalculatorKeyType.equals),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final row in _rows)
          Expanded(
            child: Row(
              children: [
                for (final key in row)
                  CalculatorButton(
                    label: key.label,
                    flex: key.flex,
                    backgroundColor: _backgroundColorFor(key),
                    foregroundColor: _foregroundColorFor(
                      key.type,
                      isActive: key.label == activeOperatorSymbol,
                    ),
                    onPressed: () => onKeyPressed(key.label),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Color _backgroundColorFor(CalculatorKeyData key) {
    final bool isActive = key.label == activeOperatorSymbol;

    switch (key.type) {
      case CalculatorKeyType.digit:
        return const Color(0xFF333333);
      case CalculatorKeyType.function:
        return const Color(0xFFA5A5A5);
      case CalculatorKeyType.operatorKey:
      case CalculatorKeyType.equals:
        return isActive ? Colors.white : const Color(0xFFFF9F0A);
    }
  }

  Color _foregroundColorFor(CalculatorKeyType type, {required bool isActive}) {
    switch (type) {
      case CalculatorKeyType.function:
        return Colors.black;
      case CalculatorKeyType.operatorKey:
      case CalculatorKeyType.equals:
        return isActive ? const Color(0xFFFF9F0A) : Colors.white;
      case CalculatorKeyType.digit:
        return Colors.white;
    }
  }
}
