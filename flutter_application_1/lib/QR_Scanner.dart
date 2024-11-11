import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'nfl_api_service.dart';
import 'TeamData.dart'; 

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({super.key});

  @override
  State<QRCodeScanner> createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  String? scannedText;
  TeamData? teamData;  

  final NflApiService nflApiService = NflApiService();  

  
  void _onDetect(BarcodeCapture barcodeCapture) async {
    final List<Barcode> barcodes = barcodeCapture.barcodes;

    for (var barcode in barcodes) {
      if (barcode.rawValue != null) {
        setState(() {
          scannedText = barcode.rawValue!;
        });

        // Fetch the team data from the API based on the scanned QR code
        final apiResult = await nflApiService.getTeamStats(scannedText!);

        if (apiResult != null) {
          setState(() {
            teamData = apiResult;  // Store the fetched data in TeamData
          });
        } else {
          print('Failed to fetch team data');
          setState(() {
            teamData = null;  // reset
          });
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
              onDetect: _onDetect,  
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: teamData != null
                ? Column(
                    children: [
                      Text(
                        'Team: ${teamData!.name}',  // Display team name
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Wins: ${teamData!.recordSummary.split('-')[0]}',  // Display Wins
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Losses: ${teamData!.recordSummary.split('-')[1]}',  // Display Losses
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  )
                : const Text('Scan a code to see team statistics'),
          ),
        ],
      ),
    );
  }
}