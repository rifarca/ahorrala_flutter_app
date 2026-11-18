import 'package:ahorrala/helpers/Helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final MobileScannerController _cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  bool _processing = false;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _buscarProducto(String barcode) async {
    if (_processing) return;

    setState(() {
      _processing = true;
    });

    // Detener cámara para evitar múltiples lecturas
    await _cameraController.stop();

    try {
      final result = await Helper.getItemsDetails(barcode);

      if (!mounted) return;

      if (result.isNotEmpty) {
        // Producto encontrado
        Navigator.pop(context, result.first);
      } else {
        // Producto no encontrado
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "No encontramos ningún producto con este código de barras",
            ),
            duration: Duration(seconds: 2),
          ),
        );

        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          Navigator.pop(context, null);
        }
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("El Producto no existe en nuestra Base de Datos"),
          duration: const Duration(seconds: 2),
        ),
      );

      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        Navigator.pop(context, null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text('Escanear Código de Barras'),
        actions: [
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: _cameraController,
            builder: (context, state, child) {
              if (!state.isInitialized) {
                return const SizedBox.shrink();
              }

              switch (state.torchState) {
                case TorchState.off:
                  return IconButton(
                    icon: const Icon(Icons.flash_off, color: Colors.grey),
                    onPressed: () {
                      _cameraController.toggleTorch();
                    },
                  );

                case TorchState.on:
                  return IconButton(
                    icon: const Icon(Icons.flash_on, color: Colors.yellow),
                    onPressed: () {
                      _cameraController.toggleTorch();
                    },
                  );

                case TorchState.unavailable:
                  return const Icon(Icons.flash_off, color: Colors.red);

                case TorchState.auto:
                  return IconButton(
                    icon: const Icon(Icons.flash_auto),
                    onPressed: () {
                      _cameraController.toggleTorch();
                    },
                  );
              }
            },
          ),
        ],
      ),

      body: Stack(
        children: [
          MobileScanner(
            controller: _cameraController,

            onDetect: (BarcodeCapture capture) {
              if (_processing) return;

              if (capture.barcodes.isEmpty) return;

              final barcode = capture.barcodes.first.rawValue;

              if (barcode != null && barcode.isNotEmpty) {
                _buscarProducto(barcode);
              }
            },
          ),

          Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://app.ahorrala.com/public/images/ahorrala_logo_1024x1024.png',
                    width: 200,
                    height: 200,
                  ),
                ),
                Container(
                  width: 280,
                  height: 160,

                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 34, 208, 89),
                      width: 2.5,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: const Center(
                    child: Text(
                      'Alinea el código de barras aquí',
                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        backgroundColor: Colors.black45,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_processing)
            Container(
              color: Colors.black54,

              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    CircularProgressIndicator(color: Colors.white),

                    SizedBox(height: 16),

                    Text(
                      "Buscando producto...",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
