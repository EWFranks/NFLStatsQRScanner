import 'dart:convert';
import 'package:http/http.dart' as http;
import 'TeamData.dart'; 
import 'dart:async';

class NflApiService {
  static const String apiUrl = 'https://nfl-api-data.p.rapidapi.com/nfl-team-info/v1/data'; 
  static const String apiKey = 'c9015182demsh9000a387856f7bbp151741jsned38753b24e6'; // RapidAPI key

  bool isScanInProgress = false; // Flag to prevent immediate scanning 

  // Fetch data on teams via team ID
  Future<TeamData?> getTeamStats(String teamId) async {
    
    if (isScanInProgress) {
      print('Please wait for 15 seconds before scanning again.');
      return null; 
    }

    final url = Uri.parse('$apiUrl?id=$teamId'); 

    try {
      
      isScanInProgress = true;

      final response = await http.get(
        url,
        headers: {
          'x-rapidapi-key': apiKey,  // API key in header
          'x-rapidapi-host': 'nfl-api-data.p.rapidapi.com',  // Host name
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('Data fetched successfully: ${data.toString()}');  
        // Return TeamData object parsed from the JSON response
        return TeamData.fromJson(data);  
      } else if (response.statusCode == 429) {
        
        print('Rate limit hit (429). Please wait 15 seconds before scanning again.');
        await Future.delayed(Duration(seconds: 15));  
        isScanInProgress = false; // Reset scan flag
        return null;
      } else {
        print('Failed to fetch data: ${response.statusCode}');
        isScanInProgress = false; // Reset scan flag
        return null;
      }
    } catch (e) {
      print('Error fetching data: $e');
      isScanInProgress = false; // Reset in case of an error
      return null;
    }
  }
}
