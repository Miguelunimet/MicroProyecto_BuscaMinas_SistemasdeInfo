import 'package:flutter/material.dart';
import 'Pantallas/menu_principal.dart';
import 'Pantallas/pantalla_de_carga.dart';

void main() {
  runApp(const MiBuscaminas());
}

class MiBuscaminas extends StatefulWidget {
  const MiBuscaminas({super.key});

  @override
  State<MiBuscaminas> createState() => _MiBuscaminasState();
}

class _MiBuscaminasState extends State<MiBuscaminas> {
  bool _esModoOscuro = true;
  bool _mostrarCarga = true; // Controla si la app está en su fase de carga inicial

  void _cambiarTema(bool valor) {
    setState(() {
      _esModoOscuro = !_esModoOscuro; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buscaminas Unimet',
      debugShowCheckedModeBanner: false,
      theme: _esModoOscuro ? ThemeData.dark() : ThemeData.light(),
      home: _mostrarCarga
          ? PantallaDeCarga(
              alTerminar: () {
                setState(() {
                  _mostrarCarga = false; // Quita la carga y da el pase automático al Menú Principal
                });
              },
            )
          : MenuPrincipal(
              esModoOscuro: _esModoOscuro,
              onTemaCambiado: (valor) => _cambiarTema(valor),
            ),
    );
  }
}