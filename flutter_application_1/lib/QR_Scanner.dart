import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'nfl_api_service.dart';
import 'TeamData.dart';

class QRCodeScanner extends StatefulWidget {
  final Function(TeamData) onTeamDataScanned;

  const QRCodeScanner({super.key, required this.onTeamDataScanned});

  @override
  State<QRCodeScanner> createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  String? scannedText;
  bool isScanInProgress = false;  // Flag to prevent immediate scanning 
  final NflApiService nflApiService = NflApiService();

  void _onDetect(BarcodeCapture barcodeCapture) async {
    if (isScanInProgress) { // If a scan is in progress then ignore the others
      return;
    }

    final List<Barcode> barcodes = barcodeCapture.barcodes;

    for (var barcode in barcodes) {
      if (barcode.rawValue != null) {
        setState(() {
          scannedText = barcode.rawValue!;
        });
        setState(() {
          isScanInProgress = true;
        });

        // Fetch team data from API with ID based on QR code
        final apiResult = await nflApiService.getTeamStats(scannedText!);

        if (apiResult != null) {
          widget.onTeamDataScanned(apiResult); // Passes data
        }

        // Disable scanning for 15 seconds after the scan
        await Future.delayed(Duration(seconds: 15));

        setState(() {
          isScanInProgress = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: _onDetect,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: scannedText != null
                ? Text('Scanned: $scannedText')
                : const Text('Scan a code to see team statistics'),
          ),
        ],
      ),
    );
  }
}
