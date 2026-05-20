import 'package:shared_preferences/shared_preferences.dart';

class ServicioPuntuacion {
  // Guarda el récord si el tiempo actual es menor al guardado anteriormente
  static Future<bool> verificarYGuardarRecord(String dificultad, int segundos) async {
    final prefs = await SharedPreferences.getInstance();
    int? recordActual = prefs.getInt('record_$dificultad');

    // SOLUCIÓN: Si es nulo, entra. Si NO es nulo (!= null), extraemos su valor real con una comparación limpia.
    if (recordActual == null || segundos < recordActual) {
      await prefs.setInt('record_$dificultad', segundos);
      return true; // Retorna true si es un nuevo récord
    }
    return false; // Retorna false si no superó el récord
  }

  // Obtiene el récord actual de una dificultad
  static Future<int?> obtenerRecord(String dificultad) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('record_$dificultad');
  }
}