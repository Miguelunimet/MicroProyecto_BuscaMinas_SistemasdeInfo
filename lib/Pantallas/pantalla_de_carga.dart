import 'package:flutter/material.dart';
import 'dart:async';

class PantallaDeCarga extends StatefulWidget {
  final VoidCallback alTerminar;

  const PantallaDeCarga({
    super.key,
    required this.alTerminar,
  });

  @override
  State<PantallaDeCarga> createState() => _PantallaDeCargaState();
}

class _PantallaDeCargaState extends State<PantallaDeCarga> {
  double _opacidad = 0.0;
  double _escala = 0.5;

  @override
  void initState() {
    super.initState();
    
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _opacidad = 1.0;
          _escala = 1.0;
        });
      }
    });

    Timer(const Duration(seconds: 3), widget.alTerminar);
  }

  @override
  Widget build(BuildContext context) {
    final esOscuro = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: esOscuro ? Colors.blueGrey[950] : Colors.blueAccent,
      body: Stack(
        children: [
          Center(
            child: AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: _opacidad,
              child: AnimatedScale(
                duration: const Duration(seconds: 1),
                scale: _escala,
                curve: Curves.elasticOut,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.brightness_7, 
                        size: 80, 
                        color: Colors.black87
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'BUSCAMINAS\nFLUTTER',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'UNIMET - 2026',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: TextButton(
              onPressed: widget.alTerminar,
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Row(
                children: [
                  Text('Saltar ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Icon(Icons.skip_next, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}