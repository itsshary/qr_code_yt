import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({super.key});

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  var qrText = '';

  var flashState = "flashon";
  var cameraState = "frontCamera";
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  copytext() {
    final qrvalue = ClipboardData(text: qrText);
    Clipboard.setData(qrvalue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Qr"),
        actions: [
          IconButton(
              onPressed: () {
                if (controller != null) {
                  controller?.toggleFlash();
                  if (_isFlashOn(flashState)) {
                    setState(() {
                      flashState = "flashOff";
                    });
                  } else {
                    setState(() {
                      flashState = "flashOn";
                    });
                  }
                }
              },
              icon: Icon(
                  flashState == "flashOff" ? Icons.flash_off : Icons.flash_on)),
          IconButton(
              onPressed: () {
                if (controller != null) {
                  controller!.flipCamera();
                  if (_isBackCamera(cameraState)) {
                    setState(() {
                      cameraState = "frontCamera";
                    });
                  } else {
                    setState(() {
                      cameraState = "backCamera";
                    });
                  }
                }
              },
              icon: Icon(cameraState == "frontCamera"
                  ? Icons.camera_alt_outlined
                  : Icons.camera_alt)),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      qrText,
                      style: const TextStyle(
                        fontSize: 15.0,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      copytext();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Copy Text Successfully")));
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text("Copy"),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  bool _isFlashOn(String current) {
    return "flashOn" == current;
  }

  bool _isBackCamera(String current) {
    return "backCamera" == current;
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData.code.toString();
      });
    });
  }
}
