import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../Modelos/tablero.dart';
import '../Modelos/casillas.dart';
import 'servicio_puntuacion.dart';

class PantallaJuego extends StatefulWidget {
  final int filas;
  final int columnas;
  final int cantidadMinas;

  const PantallaJuego({
    super.key,
    required this.filas,
    required this.columnas,
    required this.cantidadMinas,
  });

  @override
  State<PantallaJuego> createState() => _PantallaJuegoState();
}

class _PantallaJuegoState extends State<PantallaJuego> {
  late TableroBuscaminas delTablero;
  
  Timer? _timer;
  int _segundosTranscurridos = 0;
  bool _juegoIniciado = false;
  int _banderasColocadas = 0;
  double _escalaReloj = 1.0;

  
  String _estiloLetraActual = 'Clásico'; 

  @override
  void initState() {
    super.initState();
    _reiniciarPartida();
    _cargarEstiloConfigurado(); 
  }

  @override
  void dispose() {
    _detenerReloj();
    super.dispose();
  }

  
  Future<void> _cargarEstiloConfigurado() async {
    final prefs = await SharedPreferences.getInstance();
    String estiloGuardado = prefs.getString('estiloNumeros') ?? 'Clásico';
    if (mounted) {
      setState(() {
        _estiloLetraActual = estiloGuardado;
      });
    }
  }

  void _reiniciarPartida() {
    _detenerReloj();
    setState(() {
      delTablero = TableroBuscaminas(
        filas: widget.filas,
        columnas: widget.columnas,
        cantidadMinas: widget.cantidadMinas,
      );
      _segundosTranscurridos = 0;
      _juegoIniciado = false;
      _banderasColocadas = 0;
      _escalaReloj = 1.0;
    });
  }

  void _iniciarReloj() {
    _juegoIniciado = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _segundosTranscurridos++;
        _escalaReloj = 1.2;
      });
      
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) {
          setState(() {
            _escalaReloj = 1.0;
          });
        }
      });
    });
  }

  void _detenerReloj() {
    _timer?.cancel();
  }

  void _revelarCasilla(Casilla casilla) {
    if (casilla.estaRevelada || casilla.tieneBandera) return;

    setState(() {
      if (!_juegoIniciado) {
        _juegoIniciado = true;
        _iniciarReloj();
      }

      if (!delTablero.minasColocadas) {
        delTablero.inicializarMinas(casilla.fila, casilla.columna);
      }

      casilla.estaRevelada = true;

      if (casilla.tieneMina) {
        _detenerReloj();
        _mostrarDialogoFin('¡BOOM! Tocaste una mina.', 'Juego Terminado 🤯🤯🤯🗿🗿🗿');
        _revelarTodo();
      } else {
        if (casilla.minasAlrededor == 0) {
          _revelarAutomatico(casilla.fila, casilla.columna);
        }
        _verificarVictoria();
      }
    });
  }

  void _ponerBandera(Casilla casilla) {
    if (casilla.estaRevelada) return;
    setState(() {
      casilla.tieneBandera = !casilla.tieneBandera;
      if (casilla.tieneBandera) {
        _banderasColocadas++;
      } else {
        _banderasColocadas--;
      }
    });
  }

  void _revelarTodo() {
    for (var fila in delTablero.matriz) {
      for (var c in fila) {
        c.estaRevelada = true;
      }
    }
  }

  void _revelarAutomatico(int f, int c) {
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        int nF = f + i;
        int nC = c + j;
        if (nF >= 0 && nF < delTablero.filas && nC >= 0 && nC < delTablero.columnas) {
          Casilla vecina = delTablero.matriz[nF][nC];
          if (!vecina.estaRevelada && !vecina.tieneMina && !vecina.tieneBandera) {
            setState(() {
              vecina.estaRevelada = true;
              if (vecina.minasAlrededor == 0) {
                _revelarAutomatico(nF, nC);
              }
            });
          }
        }
      }
    }
  }

  void _verificarVictoria() async {
    bool gano = true;
    for (var fila in delTablero.matriz) {
      for (var casilla in fila) {
        if (!casilla.tieneMina && !casilla.estaRevelada) {
          gano = false;
        }
      }
    }

    if (gano) {
      _detenerReloj();

      String dificultadKey = '${widget.filas}x${widget.columnas}';
      bool esNuevoRecord = await ServicioPuntuacion.verificarYGuardarRecord(dificultadKey, _segundosTranscurridos);

      String mensajeVictoria = 'Completaste el juego en $_segundosTranscurridos segundos.';
      
      if (esNuevoRecord) {
        mensajeVictoria += '\n\n🥳 ¡NUEVO RÉCORD HISTÓRICO! 🥳';
      } else {
        int? recordActual = await ServicioPuntuacion.obtenerRecord(dificultadKey);
        if (recordActual != null) {
          mensajeVictoria += '\n(El récord actual es de $recordActual segundos)';
        }
      }

      _mostrarDialogoFin(mensajeVictoria, '¡Ganaste! 🏆');
    }
  }

  void _mostrarDialogoFin(String mensaje, String titulo) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text(mensaje, textAlign: TextAlign.center),
          actions: [
            TextButton(
              child: const Text('Volver al Menú'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text('Reintentar'),
              onPressed: () {
                Navigator.pop(context);
                _reiniciarPartida();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final esOscuro = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: esOscuro ? Colors.blueGrey[900] : Colors.grey[200],
      appBar: AppBar(
        title: Text('Buscaminas (${widget.filas}x${widget.columnas})'),
        backgroundColor: esOscuro ? Colors.blueGrey[800] : Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reiniciarPartida,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _crearIndicador(
                  icono: Icons.brightness_7,
                  colorIcono: Colors.redAccent,
                  valor: '${widget.cantidadMinas - _banderasColocadas}',
                  escala: 1.0, 
                  context: context,
                ),
                _crearIndicador(
                  icono: Icons.timer,
                  colorIcono: Colors.amber,
                  valor: '$_segundosTranscurridos s',
                  escala: _escalaReloj,
                  context: context,
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: delTablero.columnas,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemCount: delTablero.filas * delTablero.columnas,
                    itemBuilder: (context, index) {
                      int f = index ~/ delTablero.columnas;
                      int c = index % delTablero.columnas;
                      Casilla casilla = delTablero.matriz[f][c];

                      return GestureDetector(
                        onTap: () => _revelarCasilla(casilla),
                        onLongPress: () => _ponerBandera(casilla),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 150),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                          key: ValueKey('casilla_${f}_${c}_${casilla.estaRevelada}'),
                          child: Container(
                            decoration: BoxDecoration(
                              color: casilla.estaRevelada
                                  ? (casilla.tieneMina ? Colors.red : (esOscuro ? Colors.grey[300] : Colors.grey[400]))
                                  : (esOscuro ? Colors.blueGrey[700] : Colors.blueGrey[300]),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Center(
                              child: _construirContenidoCasilla(casilla, esOscuro),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearIndicador({
    required IconData icono,
    required Color colorIcono,
    required String valor,
    required double escala,
    required BuildContext context,
  }) {
    final esOscuro = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: esOscuro ? Colors.blueGrey[800] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Icon(icono, color: colorIcono),
          const SizedBox(width: 8),
          AnimatedScale(
            scale: escala,
            duration: const Duration(milliseconds: 100),
            child: Text(
              valor,
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
                color: esOscuro ? Colors.white : Colors.black87
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirContenidoCasilla(Casilla casilla, bool esOscuro) {
    if (!casilla.estaRevelada) {
      return casilla.tieneBandera 
          ? const Icon(Icons.flag, color: Colors.orange) 
          : const SizedBox();
    }
    if (casilla.tieneMina) {
      return const Icon(Icons.brightness_7, color: Colors.white);
    }
    if (casilla.minasAlrededor > 0) {
      
      final esRetro = _estiloLetraActual == 'Retro';

      return Text(
        '${casilla.minasAlrededor}',
        style: TextStyle(
          fontWeight: FontWeight.w900, 
          fontSize: esRetro ? 26 : 18,            
          fontFamily: esRetro ? 'Pixel' : null, 
          fontFamilyFallback: esRetro ? const ['monospace', 'Courier'] : null,
          color: _obtenerColorNumero(casilla.minasAlrededor, esOscuro), 
          
          shadows: esRetro 
              ? const [
                  Shadow(offset: Offset(-2, -2), color: Colors.black),
                  Shadow(offset: Offset(2, -2), color: Colors.black),
                  Shadow(offset: Offset(2, 2), color: Colors.black),
                  Shadow(offset: Offset(-2, 2), color: Colors.black),
                ]
              : null,
        ),
      );
    }
    return const SizedBox();
  }

  Color _obtenerColorNumero(int numero, bool esOscuro) {
    switch (_estiloLetraActual) {
      case 'Colorido':
        List<Color> coloresVivos = [
          Colors.transparent,
          Colors.cyanAccent,   
          Colors.greenAccent,  
          Colors.pinkAccent,   
          Colors.purpleAccent, 
          Colors.orangeAccent, 
          Colors.yellowAccent, 
          Colors.green,      
          Colors.redAccent,    
        ];
        return coloresVivos[numero];

      case 'Retro':
        List<Color> coloresRetro = [
          Colors.transparent,
          const Color(0xFF00FF00), 
          const Color(0xFF00FFFF), 
          const Color(0xFFFF00FF), 
          const Color(0xFFFFCC00), 
          const Color(0xFFFF3333), 
          Colors.indigoAccent,
          Colors.teal,
          Colors.amber,
        ];
        return coloresRetro[numero];

      case 'Minimalista':
        if (esOscuro) {
          return numero % 2 == 0 ? Colors.white : Colors.grey[400]!;
        } else {
          return numero % 2 == 0 ? Colors.black87 : Colors.grey[700]!;
        }

      case 'Clásico':
      default:
        switch (numero) {
          case 1: return Colors.blue[800]!;
          case 2: return Colors.green[700]!;
          case 3: return Colors.red[700]!;
          case 4: return const Color(0xFF010080); 
          case 5: return const Color(0xFF800000); 
          case 6: return const Color(0xFF008080); 
          case 7: return Colors.black;
          case 8: return Colors.grey;
          default: return Colors.purple;
        }
    }
  }
}