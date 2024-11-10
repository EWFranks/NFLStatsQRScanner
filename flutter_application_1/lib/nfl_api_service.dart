import 'dart:convert';
import 'package:http/http.dart' as http;

class NflApiService {
  static const String apiUrl = 'https://nfl-football-api.p.rapidapi.com/nfl-team-statistics?year=2024&displayName='; // Corrected API URL
  static const String apiKey = 'eace7848c2msha169585313067e7p179069jsn4a4b3e9daceb'; // Your RapidAPI key

  // Modify this to use the correct endpoint format
  Future<Map<String, dynamic>?> getTeamStats(String teamId) async {
    final url = Uri.parse('$apiUrl?id=$teamId'); // Append teamId to the endpoint
    
    final response = await http.get(
      url,
      headers: {
        'X-RapidAPI-Key': apiKey,  // API key
        'x-rapidapi-host': 'nfl-api-data.p.rapidapi.com',  // API host
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);  // Parse and return the JSON response
    } else {
      print('Failed to fetch data: ${response.statusCode}');
      return null;  // Return null if the API request fails
    }
  }
}
