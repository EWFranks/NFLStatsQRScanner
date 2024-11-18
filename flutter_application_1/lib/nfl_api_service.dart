import 'dart:convert';
import 'package:http/http.dart' as http;
import 'TeamData.dart';
import 'dart:async';

class NflApiService {
  static const String apiUrl =
      'https://nfl-api-data.p.rapidapi.com/nfl-team-info/v1/data';
  static const String localServerUrl = 'http://192.168.1.76:3000/teams';
  static const String apiKey = '8824467a28mshc081f9c976a114ap1f2b63jsnabc936221d12';

  bool isScanInProgress = false;

  // Fetch team stats
  Future<TeamData?> getTeamStats(String teamId) async {
    if (isScanInProgress) {
      print('Please wait for 15 seconds before scanning again.');
      return null;
    }

    final url = Uri.parse('$apiUrl?id=$teamId');

    try {
      isScanInProgress = true;

      Future.delayed(Duration(seconds: 6), () {
        isScanInProgress = false;
      });

      final response = await http.get(
        url,
        headers: {
          'x-rapidapi-key': apiKey,
          'x-rapidapi-host': 'nfl-api-data.p.rapidapi.com',
        },
      ).timeout(Duration(seconds: 6));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('Remote API data fetched successfully: $data'); 
        return TeamData.fromJson(data);
      } else {
        print('Failed to fetch data from remote API: ${response.statusCode}');
        isScanInProgress = false;
        return null;
      }
    } catch (e) {
      print('Error fetching data from remote API: $e');
      isScanInProgress = false;
      return null;
    }
  }
  
  // Upload a list of teams to the local server
  Future<void> uploadTeamList(List<TeamData> teams) async {
    final url = Uri.parse(localServerUrl);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'teams': teams.map((team) => team.toJson()).toList()}),
      );

      if (response.statusCode == 200) {
        print('Team list uploaded successfully.');
      } else {
        print('Failed to upload team list: ${response.statusCode}');
        print('Response body: ${response.body}'); 
      }
    } catch (e) {
      print('Error uploading team list: $e');
    }
  }

  // Fetch saved team data from the local server
  Future<List<TeamData>> fetchSavedTeams() async {
    final url = Uri.parse(localServerUrl);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> teamList = data['teams'] ?? [];
        print('Fetched saved teams: $teamList'); 
        return teamList.map((json) => TeamData.fromJson(json)).toList();
      } else {
        print('Failed to fetch saved teams: ${response.statusCode}');
        print('Response body: ${response.body}'); 
        return [];
      }
    } catch (e) {
      print('Error fetching saved teams: $e');
      return [];
    }
  }

  // Clear all teams on the local server for possible future uses
  Future<void> clearTeams() async {
    final url = Uri.parse(localServerUrl);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'teams': []}),
      );

      if (response.statusCode == 200) {
        print('Cleared all teams successfully.');
      } else {
        print('Failed to clear teams: ${response.statusCode}');
      }
    } catch (e) {
      print('Error clearing teams: $e');
    }
  }
}
