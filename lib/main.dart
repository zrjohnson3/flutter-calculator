import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData.dark(),
      home: const CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '';
  bool _isClearing = false;

  void _addToExpression(String value) {
    setState(() {
      _expression += value;
    });
  }

  void _clearExpression() {
    setState(() {
      _isClearing = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _expression = '';
        _result = '';
        _isClearing = false;
      });
    });
  }

  void _toggleSign() {
    setState(() {
      if (_expression.isNotEmpty) {
        if (_expression.startsWith('-')) {
          _expression = _expression.substring(1);
        } else {
          _expression = '-$_expression';
        }
      }
    });
  }

  void _squareNumber() {
    if (_expression.isNotEmpty) {
      try {
        final double value = double.parse(_expression);
        setState(() {
          _expression = (value * value).toString();
        });
      } catch (e) {
        setState(() {
          _expression = 'Error';
        });
      }
    }
  }

  void _evaluateExpression() {
    try {
      final expression = Expression.parse(_expression);
      final evaluator = const ExpressionEvaluator();
      final result = evaluator.eval(expression, {});
      setState(() {
        _result = result.toString();
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView( // Prevents pixel overflow
          child: Column(
            children: [
              const SizedBox(height: 30),
              _buildDisplay(),
              const SizedBox(height: 10),
              _buildButtonGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDisplay() {
    return Column(
      children: [
        _buildShadedBox(_expression.isEmpty ? '0' : _expression, 48),
        const SizedBox(height: 10),
        _buildShadedBox(_result.isEmpty ? '0' : _result, 32),
      ],
    );
  }

  Widget _buildShadedBox(String text, double fontSize) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize, color: Colors.white),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildButtonGrid() {
    const buttonLabels = [
      ['C', '±', '%', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      ['0', '.', 'x²', '='],
    ];

    return Column(
      children: buttonLabels.map((row) {
        return Row(
          children: row.map((label) => _buildButton(label)).toList(),
        );
      }).toList(),
    );
  }

  Widget _buildButton(String value) {
    Color buttonColor;
    Color textColor = Colors.white;

    // Apple-style color scheme
    if (value == 'C' || value == '±' || value == '%' || value == 'x²') {
      buttonColor = Colors.grey[700]!; // Light gray for function buttons
    } else if (value == '÷' || value == '×' || value == '-' || value == '+' || value == '=') {
      buttonColor = Colors.orange; // Orange for operator buttons
    } else {
      buttonColor = Colors.grey[850]!; // Dark gray for number buttons
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: ElevatedButton(
          onPressed: () {
            if (value == '=') {
              _evaluateExpression();
            } else if (value == 'C') {
              _clearExpression();
            } else if (value == 'x²') {
              _squareNumber();
            } else if (value == '±') {
              _toggleSign();
            } else {
              _addToExpression(value == '×' ? '*' : value == '÷' ? '/' : value);
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: textColor,
            backgroundColor: buttonColor,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
            elevation: 2,
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
