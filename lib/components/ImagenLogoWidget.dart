import 'package:flutter/material.dart';

class ImagenLogoWidget extends StatelessWidget {
  final String rutaAsset;
  final double? altura;
  final double? ancho;
  final BoxFit ajuste;

  const ImagenLogoWidget({
    super.key,
    required this.rutaAsset,
    this.altura,
    this.ancho,
    this.ajuste = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Image.asset(
          rutaAsset,
          height: altura ?? 100,
          width: ancho ?? 100,
          fit: ajuste,
        ),
      ),
    );
  }
}