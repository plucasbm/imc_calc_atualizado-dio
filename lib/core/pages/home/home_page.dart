import 'package:flutter/material.dart';
import 'package:imc_att/core/models/imc.dart';
import 'package:imc_att/core/repositories/imc_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final alturaEC = TextEditingController();
  final pesoEC = TextEditingController();
  final _imcRespository = ImcRepository();
  List<Imc> _imc = [];

  void toCalculateIMC(double peso, double altura) {
    double imc = (peso / (altura * altura));
    String estado = "";

    if (imc < 16) {
      estado = "Magreza grave";
    } else if (imc >= 16 && imc < 17) {
      estado = "Magreza moderada";
    } else if (imc >= 17 && imc < 18.5) {
      estado = "Magreza leve";
    } else if (imc >= 18.5 && imc < 25) {
      estado = "Saudável";
    } else if (imc >= 25 && imc < 30) {
      estado = "Sobrepeso";
    } else if (imc >= 30 && imc < 35) {
      estado = "Obesidade grau I";
    } else if (imc >= 35 && imc < 40) {
      estado = "Obesidade grau II (severa)";
    } else {
      estado = "Obesidade grau III (mórbida)";
    }

    _imc = _imcRespository.getImc();

    setState(
      () {
        _imcRespository.addImc(
          Imc(
            altura: altura,
            peso: peso,
            imc: imc.toStringAsFixed(2),
            estado: estado,
          ),
        );
      },
    );

    print(_imcRespository.getImc().length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculadora de IMC',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text('Insira seus dados'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: pesoEC,
                      decoration: const InputDecoration(
                        hintText: 'Peso(kg)',
                      ),
                    ),
                    TextField(
                      controller: alturaEC,
                      decoration: const InputDecoration(
                        hintText: 'Altura(m)',
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      toCalculateIMC(double.parse(pesoEC.text),
                          double.parse(alturaEC.text));
                      Navigator.pop(context);
                      pesoEC.clear();
                      alturaEC.clear();
                      setState(() {
                        _imcRespository.getImc();
                      });
                    },
                    child: const Text('Calcular'),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(
          Icons.calculate_outlined,
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
        itemCount: _imc.length,
        itemBuilder: (_, idx) {
          Imc imc = _imc[idx];
          return ListTile(
            title: Text('IMC: ${imc.imc} - ${imc.estado}'),
            subtitle: Text('Peso: ${imc.peso} - Altura: ${imc.altura}'),
          );
        },
      ),
    );
  }
}
