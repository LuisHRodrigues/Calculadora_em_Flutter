import 'package:flutter/material.dart';

/// Visor somente leitura que exibe o valor atual da calculadora.
class CalculatorDisplay extends StatelessWidget {
  const CalculatorDisplay({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      alignment: Alignment.bottomRight,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.bottomRight,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
