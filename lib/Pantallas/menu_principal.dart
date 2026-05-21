import 'package:flutter/material.dart';
import 'pantalla_de_juego.dart';
import 'pantalla_como_jugar.dart';
import 'pantalla_configuracion.dart';
import 'pantalla_records.dart';

class MenuPrincipal extends StatelessWidget {
  final bool esModoOscuro;
  final ValueChanged<bool> onTemaCambiado;

  const MenuPrincipal({
    super.key,
    required this.esModoOscuro,
    required this.onTemaCambiado,
  });

  void _mostrarSelectorDificultad(BuildContext context) {
    final esOscuro = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: esOscuro ? Colors.blueGrey[800] : Colors.white,
          title: Text(
            'Selecciona Dificultad',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: esOscuro ? Colors.amber : Colors.blueAccent, 
              fontWeight: FontWeight.bold
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.star, color: Colors.green),
                title: Text('Fácil (6x6 - 10 Minas)', style: TextStyle(color: esOscuro ? Colors.white : Colors.black87)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PantallaJuego(filas: 6, columnas: 6, cantidadMinas: 10),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.star, color: Colors.orange),
                title: Text('Medio (10x10 - 20 Minas)', style: TextStyle(color: esOscuro ? Colors.white : Colors.black87)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PantallaJuego(filas: 10, columnas: 10, cantidadMinas: 20),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.star, color: Colors.red),
                title: Text('Difícil (12x12 - 30 Minas)', style: TextStyle(color: esOscuro ? Colors.white : Colors.black87)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PantallaJuego(filas: 12, columnas: 12, cantidadMinas: 30),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final esOscuro = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: esOscuro ? Colors.blueGrey[900] : Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '💣 BUSCAMINAS 💣',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: esOscuro ? Colors.amber : Colors.blueAccent,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Edición Unimet',
                style: TextStyle(
                  fontSize: 16,
                  color: esOscuro ? Colors.grey[400] : Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 50),
              _BotonAnimado(
                texto: 'Jugar Partida 🎮',
                color: Colors.green[600]!,
                accion: () => _mostrarSelectorDificultad(context),
              ),
              const SizedBox(height: 15),
              _BotonAnimado(
                texto: 'Ver Récords 🏆',
                color: Colors.amber[700]!,
                accion: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PantallaRecords()),
                  );
                },
              ),
              const SizedBox(height: 15),
              _BotonAnimado(
                texto: 'Cómo Jugar 📖',
                color: Colors.blue[600]!,
                accion: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PantallaInstrucciones()),
                  );
                },
              ),
              const SizedBox(height: 15),
              _BotonAnimado(
                texto: 'Configuración ⚙️',
                color: Colors.purple[600]!,
                accion: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PantallaConfiguracion(
                        esModoOscuro: esModoOscuro,
                        onTemaCambiado: onTemaCambiado,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BotonAnimado extends StatefulWidget {
  final String texto;
  final Color color;
  final VoidCallback accion;

  const _BotonAnimado({
    required this.texto,
    required this.color,
    required this.accion,
  });

  @override
  State<_BotonAnimado> createState() => _BotonAnimadoState();
}

class _BotonAnimadoState extends State<_BotonAnimado> {
  bool _estaEncima = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _estaEncima = true),
      onExit: (_) => setState(() => _estaEncima = false),
      child: GestureDetector(
        onTap: widget.accion,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          width: _estaEncima ? 270 : 250,
          height: _estaEncima ? 65 : 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _estaEncima ? widget.color.withBlue(200) : widget.color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.4),
                blurRadius: _estaEncima ? 15 : 8,
                offset: _estaEncima ? const Offset(0, 6) : const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            widget.texto,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}