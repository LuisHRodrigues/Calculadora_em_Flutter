# Calculadora Flutter

Aplicativo de calculadora desenvolvido em Flutter, aplicando os conceitos de
**Gerenciamento de Estado com `StatefulWidget`**, organizado segundo a
arquitetura **MVVM (Model-View-ViewModel)** e os princípios de **Clean
Code**.

O app realiza as quatro operações matemáticas básicas (adição, subtração,
multiplicação e divisão) através de uma interface simples e funcional,
inspirada na calculadora nativa do iOS.

## Funcionalidades

- Adição, subtração, multiplicação e divisão
- Entrada de números decimais (`.`)
- Inversão de sinal (`+/-`)
- Cálculo de porcentagem (`%`)
- Encadeamento de operações (ex.: `2 + 3 + 4 =`)
- Limpeza total do estado (`AC`)
- Tratamento de erro em divisão por zero, exibindo `Erro` na tela
- Destaque visual do operador selecionado enquanto ele está pendente

## Arquitetura

O projeto segue o padrão **MVVM**, separando claramente responsabilidades
entre três camadas:

```
lib/
├── main.dart                          # Ponto de entrada da aplicação
├── calculator_app.dart                # Widget raiz (MaterialApp e tema)
│
├── model/                             # Camada Model
│   ├── calculator_operation.dart      # Enum com as 4 operações suportadas
│   └── calculation_engine.dart        # Lógica pura de cálculo
│
├── viewmodel/                         # Camada ViewModel
│   └── calculator_viewmodel.dart      # Estado e regras de interação
│
└── view/                              # Camada View
    ├── screens/
    │   └── calculator_screen.dart     # Tela principal (StatefulWidget)
    └── widgets/
        ├── calculator_display.dart    # Visor de resultado
        ├── calculator_button.dart     # Botão individual
        └── calculator_keypad.dart     # Layout do teclado numérico
```

### Model

Representa a regra de negócio pura, sem qualquer dependência de Flutter ou
de estado. `CalculationEngine` recebe dois operandos e uma operação
(`CalculatorOperation`) e devolve o resultado, lançando
`DivisionByZeroException` quando aplicável. É a camada mais fácil de testar
isoladamente, pois não depende de widgets.

### ViewModel

`CalculatorViewModel` é uma classe Dart comum (não estende nada do
Flutter) que guarda o estado da calculadora (o valor exibido, o operando
armazenado, a operação pendente e o estado de erro) e expõe métodos de
intenção do usuário, como `inputDigit`, `selectOperation`,
`calculateResult`, `toggleSign`, `applyPercentage` e `clear`. Ele depende
apenas do `CalculationEngine` (Model) e nunca de um `BuildContext` ou
widget.

### View

`CalculatorScreen` é um `StatefulWidget` que **possui** a instância do
`CalculatorViewModel`. A View não contém nenhuma regra de negócio: cada
toque de tecla é apenas traduzido em uma chamada de método no ViewModel,
envolvida em `setState`, para que o Flutter reconstrua a árvore de widgets
com o novo estado. Essa é a aplicação prática do **Gerenciamento de Estado
com `StatefulWidget`**: o estado vive fora da árvore de widgets (no
ViewModel), e o `setState` apenas notifica o framework de que a UI precisa
ser redesenhada.

```
Usuário toca "7" → CalculatorScreen._handleKeyPress("7")
                  → setState(() => _viewModel.inputDigit("7"))
                  → build() é chamado novamente
                  → CalculatorDisplay exibe _viewModel.display
```

## Princípios de Clean Code aplicados

- **Responsabilidade única**: cada classe tem um único motivo para mudar
  (`CalculationEngine` só calcula, `CalculatorViewModel` só gerencia
  estado, `CalculatorScreen` só conecta UI a eventos).
- **Nomes significativos**: métodos e variáveis descrevem intenção
  (`selectOperation`, `applyPercentage`, `_shouldResetDisplayOnNextDigit`).
- **Funções pequenas e coesas**: cada método resolve um único passo do
  fluxo de cálculo.
- **Sem lógica de negócio na UI**: widgets apenas exibem estado e
  encaminham eventos; nenhuma conta é feita dentro de um `build()`.
- **Sem dependências desnecessárias**: o projeto usa apenas o SDK do
  Flutter, sem pacotes de gerenciamento de estado externos (Provider,
  Bloc, Riverpod etc.), conforme pedido no enunciado do exercício.

## Como executar

Pré-requisitos: [Flutter SDK](https://docs.flutter.dev/get-started/install)
instalado e configurado.

```bash
# Instalar as dependências
flutter pub get

# Rodar o app (emulador, dispositivo físico ou navegador)
flutter run

# Analisar o código estaticamente
flutter analyze

# Rodar os testes
flutter test
```

## Testes

O arquivo [`test/widget_test.dart`](test/widget_test.dart) cobre os
principais fluxos da calculadora:

- Soma com resultado exibido corretamente
- Divisão com resultado exibido corretamente
- Divisão por zero exibindo `Erro`
- Botão `AC` limpando o estado e retornando o visor para `0`

## Estrutura de pastas relevante

| Caminho | Descrição |
|---|---|
| `lib/model/` | Regras de negócio puras (Model) |
| `lib/viewmodel/` | Estado e lógica de apresentação (ViewModel) |
| `lib/view/screens/` | Telas do app (View) |
| `lib/view/widgets/` | Componentes de UI reutilizáveis (View) |
| `test/` | Testes de widget |
