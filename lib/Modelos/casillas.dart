class Casilla {
    final int fila;
  final int columna;

   bool tieneMina;
  bool estaRevelada;
  bool tieneBandera;
  int minasAlrededor;
  
  Casilla({
    required this.fila,
    required this.columna,
    this.tieneMina = false,
    this.estaRevelada = false,
    this.tieneBandera = false,
    this.minasAlrededor = 0,
  });
}