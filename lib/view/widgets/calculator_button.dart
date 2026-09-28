import 'package:flutter/material.dart';

// Uma tecla individual e circular da calculadora.
class CalculatorButton extends StatelessWidget {
  const CalculatorButton({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
    this.flex = 1,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onPressed;

  // Quantas "larguras de tecla" este botão deve ocupar (usado pela tecla
  // larga "0" no layout padrão da calculadora).
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Material(
          color: backgroundColor,
          shape: const StadiumBorder(),
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: onPressed,
            child: Align(
              alignment: flex == 1 ? Alignment.center : Alignment.centerLeft,
              child: Padding(
                padding: flex == 1
                    ? EdgeInsets.zero
                    : const EdgeInsets.only(left: 28),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 28,
                    color: foregroundColor,
                    fontWeight: FontWeight.w500,
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
