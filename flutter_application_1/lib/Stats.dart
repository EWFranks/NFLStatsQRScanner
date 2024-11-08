import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'nfl_api_service.dart';

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({super.key});

  @override
  State<QRCodeScanner> createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  String? scannedText;
  final NflApiService nflApiService = NflApiService();
  String? teamStats;

  void _onDetect(BarcodeCapture barcodeCapture) async {
    // Get the list of barcodes detected in the capture
    final List<Barcode> barcodes = barcodeCapture.barcodes;

    // Loop through each detected barcode
    for (var barcode in barcodes) {
      if (barcode.rawValue != null) {
        setState(() {
          scannedText = barcode.rawValue!;
        });

        // Call the API with the scanned text (team ID or name)
        final apiResult = await nflApiService.getTeamStats(scannedText!);

        // Update the UI with team stats if data is received
        if (apiResult != null) {
          setState(() {
            teamStats = 'Wins: ${apiResult['wins']}, Losses: ${apiResult['losses']}, Next Game: ${apiResult['next_game_date']}';
          });
        } else {
          print('Failed to fetch team data');
        }
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
              onDetect: _onDetect, // Corrected _onDetect function
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: teamStats != null
                ? Text(teamStats!)
                : const Text('Scan a code to see team statistics'),
          ),
        ],
      ),
    );
  }
}
