import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calculadora/calculator_app.dart';
import 'package:calculadora/view/widgets/calculator_keypad.dart';

/// Localiza o texto atualmente exibido no visor da calculadora, em
/// contraste com qualquer botão do teclado que possa ter o mesmo rótulo.
Finder displayText(String value) => find.descendant(
  of: find.byKey(const Key('calculatorDisplay')),
  matching: find.text(value),
);

/// Localiza um botão do teclado pelo seu rótulo, em contraste com o visor,
/// que pode exibir o mesmo texto.
Finder key(String label) => find.descendant(
  of: find.byType(CalculatorKeypad),
  matching: find.text(label),
);

void main() {
  testWidgets('performs addition and shows the result', (tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await tester.tap(key('7'));
    await tester.tap(key('+'));
    await tester.tap(key('3'));
    await tester.tap(key('='));
    await tester.pump();

    expect(displayText('10'), findsOneWidget);
  });

  testWidgets('performs division and shows the result', (tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await tester.tap(key('9'));
    await tester.tap(key('÷'));
    await tester.tap(key('3'));
    await tester.tap(key('='));
    await tester.pump();

    expect(displayText('3'), findsOneWidget);
  });

  testWidgets('shows an error when dividing by zero', (tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await tester.tap(key('5'));
    await tester.tap(key('÷'));
    await tester.tap(key('0'));
    await tester.tap(key('='));
    await tester.pump();

    expect(displayText('Erro'), findsOneWidget);
  });

  testWidgets('AC clears the display back to 0', (tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await tester.tap(key('5'));
    await tester.pump();
    expect(displayText('5'), findsOneWidget);

    await tester.tap(key('AC'));
    await tester.pump();

    expect(displayText('0'), findsOneWidget);
  });
}
