import 'package:flutter/material.dart';
import 'QR_Scanner.dart';
import 'TeamData.dart';
import 'Stats.dart';
import 'nfl_api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  List<TeamData> _scannedTeams = []; // Initialize as an empty list
  final NflApiService nflApiService = NflApiService(); 
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _loadSavedTeams(); // Load saved teams on startup
  }

  Future<void> _loadSavedTeams() async {
    try {
      print('Fetching saved teams from the backend...');
      List<TeamData> savedTeams = await nflApiService.fetchSavedTeams();
      setState(() {
        _scannedTeams = savedTeams; // Update the local state with the fetched teams
        _isLoading = false; // loading complete
      });
      print('Teams loaded successfully: $_scannedTeams'); 
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop loading on error
      });
      print('Error loading saved teams: $e');
    }
  }

  void _addTeamData(TeamData data) async {
    setState(() {
      _scannedTeams.add(data); // Add the new team locally
    });
    try {
      await nflApiService.uploadTeamList(_scannedTeams); // Sync the updated list to the backend
      print('Team data synced successfully!');
    } catch (e) {
      print('Error syncing team data: $e');
    }
  }

  // Handle navigation bar taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFLStatsQRScanner'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) 
          : IndexedStack(
              index: _selectedIndex,
              children: [
                StatsScreen(scannedTeams: _scannedTeams), // Display fetched teams in the stats screen
                QRCodeScanner(onTeamDataScanned: _addTeamData), // QR Scanner screen to add teams
              ],
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
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
    );
  }
}
