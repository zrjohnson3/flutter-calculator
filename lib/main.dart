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
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
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
      appBar: AppBar(title: const Text('Flutter Calculator')),
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 3,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildDisplay(),
              const SizedBox(height: 10),
              _buildButtonGrid(),
              const SizedBox(height: 10),
              _buildClearButton(),
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
        color: Colors.black54,
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
      ['7', '8', '9', '+'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '*'],
      ['0', '.', '=', '/'],
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: ElevatedButton(
          onPressed: () {
            if (value == '=') {
              _evaluateExpression();
            } else {
              _addToExpression(value);
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.grey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(20),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 28),
          ),
        ),
      ),
    );
  }

  Widget _buildClearButton() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _isClearing ? 0.5 : 1.0,
      child: ElevatedButton(
        onPressed: _clearExpression,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'CLEAR',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
