import '../model/calculation_engine.dart';
import '../model/calculator_operation.dart';

const String _initialDisplayValue = '0';
const String _errorDisplayValue = 'Erro';
const int _maxDisplayLength = 12;

/// Mantém e altera o estado da calculadora, expondo-o para a View em um
/// formato pronto para exibição.
///
/// Esta é a camada ViewModel da arquitetura MVVM. Ela depende apenas do
/// [CalculationEngine] (o Model) e não conhece nenhum widget — a View (um
/// [StatefulWidget]) possui uma instância desta classe, chama seus métodos
/// em resposta às ações do usuário e reconstrói a tela com `setState`.
class CalculatorViewModel {
  CalculatorViewModel({
    this._engine = const CalculationEngine(),
  });

  final CalculationEngine _engine;

  String _displayValue = _initialDisplayValue;
  double? _storedOperand;
  CalculatorOperation? _pendingOperation;
  bool _shouldResetDisplayOnNextDigit = false;
  bool _hasError = false;

  /// Texto atualmente exibido na tela da calculadora.
  String get display => _displayValue;

  /// Símbolo da operação aguardando para ser aplicada, se houver. Usado pela
  /// View para destacar o botão do operador ativo.
  String? get pendingOperationSymbol => _pendingOperation?.symbol;

  void inputDigit(String digit) {
    if (_hasError) _resetState();

    if (_shouldResetDisplayOnNextDigit) {
      _displayValue = digit;
      _shouldResetDisplayOnNextDigit = false;
      return;
    }

    if (_displayValue == _initialDisplayValue) {
      _displayValue = digit;
      return;
    }

    if (_displayValue.length >= _maxDisplayLength) return;

    _displayValue += digit;
  }

  void inputDecimalPoint() {
    if (_hasError) _resetState();

    if (_shouldResetDisplayOnNextDigit) {
      _displayValue = '0.';
      _shouldResetDisplayOnNextDigit = false;
      return;
    }

    if (_displayValue.contains('.')) return;

    _displayValue += '.';
  }

  void toggleSign() {
    if (_hasError || _displayValue == _initialDisplayValue) return;

    _displayValue = _displayValue.startsWith('-')
        ? _displayValue.substring(1)
        : '-$_displayValue';
  }

  void applyPercentage() {
    if (_hasError) return;

    final double value = double.parse(_displayValue) / 100;
    _displayValue = _formatNumber(value);
  }

  void selectOperation(CalculatorOperation operation) {
    if (_hasError) return;

    if (_pendingOperation != null && !_shouldResetDisplayOnNextDigit) {
      _applyPendingOperation();
    } else {
      _storedOperand = double.parse(_displayValue);
    }

    _pendingOperation = operation;
    _shouldResetDisplayOnNextDigit = true;
  }

  void calculateResult() {
    if (_hasError || _pendingOperation == null) return;

    _applyPendingOperation();
    _pendingOperation = null;
    _shouldResetDisplayOnNextDigit = true;
  }

  void clear() => _resetState();

  void _applyPendingOperation() {
    final double firstOperand = _storedOperand ?? double.parse(_displayValue);
    final double secondOperand = double.parse(_displayValue);

    try {
      final double result = _engine.execute(
        firstOperand: firstOperand,
        secondOperand: secondOperand,
        operation: _pendingOperation!,
      );
      _displayValue = _formatNumber(result);
      _storedOperand = result;
    } on DivisionByZeroException {
      _hasError = true;
      _displayValue = _errorDisplayValue;
      _storedOperand = null;
    }
  }

  void _resetState() {
    _displayValue = _initialDisplayValue;
    _storedOperand = null;
    _pendingOperation = null;
    _shouldResetDisplayOnNextDigit = false;
    _hasError = false;
  }

  String _formatNumber(double value) {
    if (value.isNaN || value.isInfinite) return _errorDisplayValue;

    final bool isWholeNumber = value == value.truncateToDouble();
    final String formatted = isWholeNumber
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(6).replaceFirst(RegExp(r'0+$'), '')
            .replaceFirst(RegExp(r'\.$'), '');

    return formatted;
  }
}
