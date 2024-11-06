import 'dart:convert';
import 'package:http/http.dart' as http;

class NflApiService {
  static const String apiUrl = 'https://nfl-api-data.p.rapidapi.com';
  static const String apiKey = 'eace7848c2msha169585313067e7p179069jsn4a4b3e9daceb'; 

  Future<Map<String, dynamic>?> getTeamStats(String teamId) async {
    final url = Uri.parse('$apiUrl/nfl-team-statistics?id=$teamId&year=2023'); 
    final response = await http.get(
      url,
      headers: {
        'X-RapidAPI-Key': apiKey,
        'X-RapidAPI-Host': 'nfl-api-data.p.rapidapi.com',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to fetch data: ${response.statusCode}');
      return null;
    }
  }
}
