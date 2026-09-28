// As quatro operações aritméticas básicas suportadas pela calculadora.
enum CalculatorOperation {
  add('+'),
  subtract('-'),
  multiply('×'),
  divide('÷');

  const CalculatorOperation(this.symbol);

  // Símbolo exibido na interface da calculadora para esta operação.
  final String symbol;
}
