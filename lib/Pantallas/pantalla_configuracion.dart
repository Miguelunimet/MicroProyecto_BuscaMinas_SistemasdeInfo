import 'package:flutter/material.dart';

class PantallaConfiguracion extends StatelessWidget {
  final bool esModoOscuro;
  final ValueChanged<bool> onTemaCambiado;

  const PantallaConfiguracion({
    super.key,
    required this.esModoOscuro,
    required this.onTemaCambiado,
  });

  @override
  Widget build(BuildContext context) {
    // Detectamos si la app está en modo oscuro para ajustar los colores de esta pantalla
    final esOscuroActual = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Si está oscuro, fondo gris azulado. Si no, gris clarito.
      backgroundColor: esOscuroActual ? Colors.blueGrey[900] : Colors.grey[100],
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: esOscuroActual ? Colors.blueGrey[800] : Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: esOscuroActual ? Colors.blueGrey[800] : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: SwitchListTile(
                secondary: Icon(
                  esModoOscuro ? Icons.dark_mode : Icons.light_mode,
                  color: esModoOscuro ? Colors.amber : Colors.orange,
                ),
                title: Text(
                  'Tema Oscuro',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: esOscuroActual ? Colors.white : Colors.black87,
                  ),
                ),
                subtitle: Text(
                  'Cambia el aspecto visual de la aplicación',
                  style: TextStyle(
                    color: esOscuroActual ? Colors.grey[400] : Colors.black54
                  ),
                ),
                value: esModoOscuro, // El valor actual (prendido/apagado)
                onChanged: onTemaCambiado, // La función que avisa a main.dart que cambie la luz
              ),
            ),
          ],
        ),
      ),
    );
  }
}