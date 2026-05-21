import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PantallaRecords extends StatefulWidget {
  const PantallaRecords({super.key});

  @override
  State<PantallaRecords> createState() => _PantallaRecordsState();
}

class _PantallaRecordsState extends State<PantallaRecords> {
  int? recordFacil;
  int? recordMedio;
  int? recordDificil;

  @override
  void initState() {
    super.initState();
    _cargarRecords();
  }

  // Carga los récords del almacenamiento local
  Future<void> _cargarRecords() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Las llaves ("6x6", etc.) deben coincidir con las que usamos en pantalla_de_juego.dart
      recordFacil = prefs.getInt('record_6x6');
      recordMedio = prefs.getInt('record_10x10');
      recordDificil = prefs.getInt('record_12x12');
    });
  }

  @override
  Widget build(BuildContext context) {
    final esOscuro = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: esOscuro ? Colors.blueGrey[900] : Colors.grey[100],
      appBar: AppBar(
        title: const Text('Mejores Tiempos 🏆'),
        backgroundColor: esOscuro ? Colors.blueGrey[800] : Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Récords Personales',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _construirFilaRecord('Fácil (6x6)', recordFacil, Colors.green, esOscuro),
            const SizedBox(height: 16),
            _construirFilaRecord('Medio (10x10)', recordMedio, Colors.orange, esOscuro),
            const SizedBox(height: 16),
            _construirFilaRecord('Difícil (12x12)', recordDificil, Colors.red, esOscuro),
          ],
        ),
      ),
    );
  }

  Widget _construirFilaRecord(String titulo, int? segundos, Color color, bool esOscuro) {
    return Card(
      color: esOscuro ? Colors.blueGrey[800] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        leading: Icon(Icons.emoji_events, color: color, size: 36),
        title: Text(
          titulo,
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 18,
            color: esOscuro ? Colors.white : Colors.black87
          ),
        ),
        trailing: Text(
          segundos != null ? '$segundos s' : 'Sin récord',
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold,
            color: segundos != null ? color : Colors.grey
          ),
        ),
      ),
    );
  }
}