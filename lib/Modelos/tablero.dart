import 'dart:math';
import 'casillas.dart';

class TableroBuscaminas {
  final int filas;
  final int columnas;
  final int cantidadMinas;
  
  List<List<Casilla>> matriz = [];
  bool minasColocadas = false; // Nos ayuda a saber si ya se plantaron las minas

  TableroBuscaminas({
    required this.filas,
    required this.columnas,
    required this.cantidadMinas,
  }) {
    _generarTableroVacio();
  }

  void _generarTableroVacio() {
    matriz = List.generate(filas, (f) {
      return List.generate(columnas, (c) {
        return Casilla(fila: f, columna: c);
      });
    });
  }

  // Coloca minas respetando el primer clic del jugador
  void inicializarMinas(int filaPrimerClic, int columnaPrimerClic) {
    int minasPuestas = 0;
    Random random = Random();

    while (minasPuestas < cantidadMinas) {
      int f = random.nextInt(filas);
      int c = random.nextInt(columnas);

      // No poner mina si coincide con el primer clic del jugador
      if (f == filaPrimerClic && c == columnaPrimerClic) {
        continue;
      }

      if (!matriz[f][c].tieneMina) {
        matriz[f][c].tieneMina = true;
        minasPuestas++;
      }
    }

    _calcularNumerosVecinos();
    minasColocadas = true;
  }

  void _calcularNumerosVecinos() {
    for (int f = 0; f < filas; f++) {
      for (int c = 0; c < columnas; c++) {
        if (matriz[f][c].tieneMina) continue;

        int contador = 0;
        for (int i = -1; i <= 1; i++) {
          for (int j = -1; j <= 1; j++) {
            int nuevaFila = f + i;
            int nuevaColumna = c + j;

            if (nuevaFila >= 0 && nuevaFila < filas && nuevaColumna >= 0 && nuevaColumna < columnas) {
              if (matriz[nuevaFila][nuevaColumna].tieneMina) {
                contador++;
              }
            }
          }
        }
        matriz[f][c].minasAlrededor = contador;
      }
    }
  }
}