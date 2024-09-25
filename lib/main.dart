import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
      ),
      home: CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String displayText = "";
  String operand1 = "";
  String operand2 = "";
  String operator = "";
  bool isOperatorPressed = false;

  void appendToDisplay(String value) {
    if (isOperatorPressed) {
      if (value == '.') {
        if (operand2.contains('.')) return; // Prevent multiple decimals
      }
      operand2 += value;
    } else {
      if (value == '.') {
        if (operand1.contains('.')) return; // Prevent multiple decimals
      }
      operand1 += value;
    }
    displayText += value;
    setState(() {});
  }

  void setOperator(String op) {
    if (operand1.isNotEmpty) {
      operator = op;
      isOperatorPressed = true;
      displayText += ' $op ';
      setState(() {});
    }
  }

  void calculateResult() {
    if (operand1.isNotEmpty && operand2.isNotEmpty) {
      double num1 = double.parse(operand1);
      double num2 = double.parse(operand2);
      double result = 0;

      switch (operator) {
        case '+':
          result = num1 + num2;
          break;
        case '-':
          result = num1 - num2;
          break;
        case '*':
          result = num1 * num2;
          break;
        case '/':
          if (num2 == 0) {
            displayText = "Error: Div by 0";
            resetCalculator();
            return;
          }
          result = num1 / num2;
          break;
      }
      displayText = result.toString();
      resetCalculator();
    }
  }

  void resetCalculator() {
    operand1 = "";
    operand2 = "";
    operator = "";
    isOperatorPressed = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              height: 80,
              child: Text(
                displayText,
                style: TextStyle(fontSize: 32, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildButton('7'),
                      buildButton('8'),
                      buildButton('9'),
                      buildButton('/'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildButton('4'),
                      buildButton('5'),
                      buildButton('6'),
                      buildButton('*'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildButton('1'),
                      buildButton('2'),
                      buildButton('3'),
                      buildButton('-'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildButton('0'),
                      buildButton('.'),
                      buildButton('C', isClear: true),
                      buildButton('+'),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: calculateResult,
              child: Text('=', style: TextStyle(fontSize: 24, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                backgroundColor: Colors.purple, // Set color for the "=" button
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String value, {bool isClear = false}) {
    return ElevatedButton(
      onPressed: () {
        if (isClear) {
          resetCalculator();
          displayText = '';
        } else if (['+', '-', '*', '/'].contains(value)) {
          setOperator(value);
        } else {
          appendToDisplay(value);
        }
      },
      child: Text(
        value,
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(20),
        shape: CircleBorder(),
        backgroundColor: isClear ? Colors.red : Colors.deepPurpleAccent, // Button colors
      ),
    );
  }
}
