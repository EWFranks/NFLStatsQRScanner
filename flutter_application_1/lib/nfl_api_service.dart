import 'dart:convert';
import 'package:http/http.dart' as http;
import 'TeamData.dart'; 
import 'dart:async';

class NflApiService {
  static const String apiUrl = 'https://nfl-api-data.p.rapidapi.com/nfl-team-info/v1/data'; 
  static const String apiKey = '8824467a28mshc081f9c976a114ap1f2b63jsnabc936221d12'; // RapidAPI key

  bool isScanInProgress = false; // Flag to prevent immediate scanning 

  // Fetch data on teams via team ID
  Future<TeamData?> getTeamStats(String teamId) async {
    if (isScanInProgress) {
      print('Please wait for 15 seconds before scanning again.');
      return null; 
    }

    final url = Uri.parse('$apiUrl?id=$teamId'); 

    print('Request URL: $url');  

    try {
      isScanInProgress = true;

      Future.delayed(Duration(seconds: 15), () {
        isScanInProgress = false; // resets for multiple scans
      });

      final response = await http.get(
        url,
        headers: {
          'x-rapidapi-key': apiKey,  // API key in header
          'x-rapidapi-host': 'nfl-api-data.p.rapidapi.com', 
        },
      ).timeout(Duration(seconds: 15)); 

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('Data fetched successfully: ${data.toString()}');

        // Return TeamData object parsed
        return TeamData.fromJson(data);  
        
      } else if (response.statusCode == 429) {
        
        print('Rate limit hit (429). Please wait 15 seconds before scanning again.');
        await Future.delayed(Duration(seconds: 15));  
        isScanInProgress = false; // Reset
        return null;
      } else {
        print('Failed to fetch data: ${response.statusCode}');
        isScanInProgress = false; // Reset
        return null;
      }
    } catch (e) {
      print('Error fetching data: $e');
      isScanInProgress = false; // Reset 
      return null;
    }
  }
}
