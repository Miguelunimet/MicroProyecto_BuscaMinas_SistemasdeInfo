import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PantallaConfiguracion extends StatefulWidget {
  final bool esModoOscuro;
  final ValueChanged<bool> onTemaCambiado;

  const PantallaConfiguracion({
    super.key,
    required this.esModoOscuro,
    required this.onTemaCambiado,
  });

  @override
  State<PantallaConfiguracion> createState() => _PantallaConfiguracionState();
}

class _PantallaConfiguracionState extends State<PantallaConfiguracion> {
  String _estiloNumeros = 'Clásico';
  bool _sonidosActivos = true;
  bool _animacionesActivas = true;

  @override
  void initState() {
    super.initState();
    _cargarPreferencias();
  }

  // Carga los valores guardados localmente al abrir la pantalla
  Future<void> _cargarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _estiloNumeros = prefs.getString('estiloNumeros') ?? 'Clásico';
      _sonidosActivos = prefs.getBool('sonidosActivos') ?? true;
      _animacionesActivas = prefs.getBool('animacionesActivas') ?? true;
    });
  }

  // Guarda las opciones de forma persistente
  Future<void> _guardarPreferencia(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    }
  }

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
        child: ListView( // Cambiado a ListView por si agregas más opciones y necesitas scroll
          children: [            
        
            Card(
              color: esOscuroActual ? Colors.blueGrey[800] : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: SwitchListTile(
                secondary: Icon(
                  widget.esModoOscuro ? Icons.dark_mode : Icons.light_mode,
                  color: widget.esModoOscuro ? Colors.amber : Colors.orange,
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
                value: widget.esModoOscuro, // El valor actual (prendido/apagado)
                onChanged: widget.onTemaCambiado, // La función que avisa a main.dart que cambie la luz
              ),
            ),
            
            const Divider(height: 24),

            
            Card(
              color: esOscuroActual ? Colors.blueGrey[800] : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Icon(
                  Icons.looks_one,
                  color: esOscuroActual ? Colors.amber : Colors.blueAccent,
                ),
                title: Text(
                  'Estilo de Números',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: esOscuroActual ? Colors.white : Colors.black87,
                  ),
                ),
                subtitle: Text(
                  _estiloNumeros,
                  style: TextStyle(color: esOscuroActual ? Colors.grey[400] : Colors.black54),
                ),
                trailing: DropdownButton<String>(
                  value: _estiloNumeros,
                  dropdownColor: esOscuroActual ? Colors.blueGrey[800] : Colors.white,
                  style: TextStyle(
                    color: esOscuroActual ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold
                  ),
                  items: <String>['Clásico', 'Colorido', 'Retro', 'Minimalista'].map((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (nuevoValor) {
                    if (nuevoValor != null) {
                      setState(() => _estiloNumeros = nuevoValor);
                      _guardarPreferencia('estiloNumeros', nuevoValor);
                    }
                  },
                ),
              ),
            ),
            
            const Divider(height: 24),

        
            Card(
              color: esOscuroActual ? Colors.blueGrey[800] : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: Icon(
                      _sonidosActivos ? Icons.volume_up : Icons.volume_off,
                      color: _sonidosActivos ? Colors.green : Colors.grey,
                    ),
                    title: Text(
                      'Efectos de Sonido',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: esOscuroActual ? Colors.white : Colors.black87,
                    ),
                  ),
                  value: _sonidosActivos,
                  onChanged: (bool valor) {
                    setState(() => _sonidosActivos = valor);
                    _guardarPreferencia('sonidosActivos', valor);
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: Icon(
                    _animacionesActivas ? Icons.movie : Icons.movie_creation_outlined,
                    color: _animacionesActivas ? Colors.purple : Colors.grey,
                  ),
                  title: Text(
                    'Animaciones Visuales',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: esOscuroActual ? Colors.white : Colors.black87,
                    ),
                  ),
                  value: _animacionesActivas,
                  onChanged: (bool valor) {
                    setState(() => _animacionesActivas = valor);
                    _guardarPreferencia('animacionesActivas', valor);
                  },
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