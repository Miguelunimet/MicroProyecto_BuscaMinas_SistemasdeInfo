import 'package:flutter/material.dart';

class PantallaInstrucciones extends StatelessWidget {
  const PantallaInstrucciones({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: const Text('¿Cómo Jugar Buscaminas?'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _crearRegla(
              icono: Icons.ads_click,
              colorIcono: Colors.blue,
              titulo: '1. Revelar una casilla',
              descripcion: 'Haz un clic normal sobre cualquier casilla gris. Si tiene un número, te indicará cuántas minas hay escondidas en las 8 casillas de su alrededor.',
            ),
            const SizedBox(height: 20),
            _crearRegla(
              icono: Icons.flag,
              colorIcono: Colors.orange,
              titulo: '2. Poner una bandera',
              descripcion: 'Si sospechas con seguridad que en una casilla hay una mina, deja el clic presionado (clic largo) para colocar una bandera naranja y bloquear la casilla.',
            ),
            const SizedBox(height: 20),
            _crearRegla(
              icono: Icons.brightness_7,
              colorIcono: Colors.red,
              titulo: '3. Evita las minas',
              descripcion: 'Si haces clic en una casilla que contiene una mina... ¡BOOM! El juego terminará inmediatamente y se revelará todo el tablero.',
            ),
            const SizedBox(height: 20),
            _crearRegla(
              icono: Icons.emoji_events,
              colorIcono: Colors.amber,
              titulo: '4. ¿Cómo se gana?',
              descripcion: 'Ganas la partida cuando logres revelar absolutamente todas las casillas del tablero que NO tengan minas.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _crearRegla({
    required IconData icono,
    required Color colorIcono,
    required String titulo,
    required String descripcion,
  }) {
    return Card(
      color: Colors.blueGrey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icono, color: colorIcono, size: 36),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    descripcion,
                    style: TextStyle(color: Colors.grey[300], fontSize: 14, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}