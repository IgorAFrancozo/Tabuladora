import 'dart:math';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(TabuladoraApp());

class TabuladoraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tabuladora',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: CalculadoraScreen(),
    );
  }
}

class CalculadoraScreen extends StatefulWidget {
  @override
  _CalculadoraScreenState createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen> {
  TextEditingController _controller = TextEditingController();
  List<String> _historico = [];

  void _calcularRaizQuadrada(String input) {
    if (input.isNotEmpty) {
      double numero = double.parse(input);
      double resultado = sqrt(numero);
      String operacao = '√$input';
      String resposta = '\n$operacao = $resultado';
      setState(() {
        _historico.insert(0, resposta);
        _controller.text = '';
      });
    }
  }

  void _calcularOperacao(String input) {
    if (input.isNotEmpty) {
      String expressao = input
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('√x', 'sqrt(');
      Parser parser = Parser();
      Expression expressaoFinal = parser.parse(expressao);
      ContextModel contexto = ContextModel();
      double resultado = expressaoFinal.evaluate(EvaluationType.REAL, contexto);
      String operacao = input;
      String resposta = '\n$operacao = $resultado';
      setState(() {
        _historico.insert(0, resposta);
        _controller.text = '';
      });
    }
  }

  void _calcularTabuada(String input) {
    if (input.isNotEmpty) {
      double numero = double.parse(input);
      String operacao = '\nTabuada do nº $input:\n';
      for (int i = 1; i <= 10; i++) {
        double resultado = numero * i;
        String linhaTabuada = '$numero x $i = $resultado';
        operacao += '\n$linhaTabuada';
      }
      setState(() {
        _historico.insert(0, operacao);
        _controller.text = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabuladora'),
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.36,
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: _historico.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(
                  _historico[index],
                  maxLines: 14,
                  style: const TextStyle(color: Colors.deepOrangeAccent, fontSize: 19),
                );
              },
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextField(
                  textAlign: TextAlign.center,
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.yellow, fontSize: 34, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('÷', color: Colors.yellow.shade400),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('×', color: Colors.yellow.shade400),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('-', color: Colors.yellow.shade400),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _buildButton('C', color: Colors.deepOrangeAccent),
                    _buildButton('0'),
                    _buildButton('=', color: Colors.deepOrangeAccent),
                    _buildButton('+', color: Colors.yellow.shade400),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton('-={ Tabular }=-', color: Colors.yellow.shade400),
                    _buildButton('√x', color: Colors.yellow.shade400)
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, {Color color = Colors.white}) {
    return ElevatedButton(
      onPressed: () {
        if (text == '=') {
          _calcularOperacao(_controller.text);
        } else if (text == 'C') {
          _controller.clear();
        } else if (text == '-={ Tabular }=-') {
          _calcularTabuada(_controller.text);
        } else if (text == '√x') {
          _calcularRaizQuadrada(_controller.text);
        } else {
          _controller.text += text;
        }
      },
      style: ElevatedButton.styleFrom(
        primary: color,
        onPrimary: Colors.black,
        padding: const EdgeInsets.fromLTRB(34, 7, 34, 7),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 25),
      ),
    );
  }
}
