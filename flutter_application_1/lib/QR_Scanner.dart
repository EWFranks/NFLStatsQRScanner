import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'nfl_api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    StatsScreen(),
    QRCodeScanner(),
    PlusMinusScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'QR Scanner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Plus/Minus',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
    );
  }
}

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Stats Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class QRCodeScanner extends StatelessWidget {
  const QRCodeScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: const QRCodeView(),
    );
  }
}

class QRCodeView extends StatefulWidget {
  const QRCodeView({super.key});

  @override
  _QRCodeViewState createState() => _QRCodeViewState();
}

class _QRCodeViewState extends State<QRCodeView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String scannedText = '';
  String? teamStats;
  final NflApiService nflApiService = NflApiService();
  
  // Timestamp of the last scan to enforce cooldown
  DateTime? lastScanTime;

  // Updated _onDetect method with 30-second cooldown
  void _onDetect(BarcodeCapture barcodeCapture) async {
    final now = DateTime.now();

    // If cooldown period has not passed, do nothing
    if (lastScanTime != null && now.difference(lastScanTime!) < Duration(seconds: 15)) {
      print('Cooldown active. Please wait...');
      return;
    }

    // Set the last scan time immediately to start the cooldown
    lastScanTime = now;

    // Proceed with scanning and API call
    if (barcodeCapture.barcodes.isNotEmpty) {
      final barcode = barcodeCapture.barcodes.first;
      if (barcode.rawValue != null) {
        setState(() {
          scannedText = barcode.rawValue!;
        });

        // Call the API with the scanned team name or ID
        final apiResult = await nflApiService.getTeamStats(scannedText);

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
    return Column(
      children: [
        Expanded(
          child: MobileScanner(
            onDetect: _onDetect,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: teamStats != null
              ? Text(
                  teamStats!,
                  style: const TextStyle(fontSize: 24),
                )
              : const Text(
                  'Scan a code to see team statistics',
                  style: TextStyle(fontSize: 18),
                ),
        ),
      ],
    );
  }
}

class PlusMinusScreen extends StatelessWidget {
  const PlusMinusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Plus/Minus Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
