import 'dart:convert';

class TeamData {
  final String name;
  final String abbreviation;
  final String location;
  final String displayName;
  final String logoUrl;
  final String recordSummary;
  final String seasonSummary;
  final String standingSummary;
  final String coachFirstName;
  final String coachLastName;
  final int coachExperience;
  
  TeamData({
    required this.name,
    required this.abbreviation,
    required this.location,
    required this.displayName,
    required this.logoUrl,
    required this.recordSummary,
    required this.seasonSummary,
    required this.standingSummary,
    required this.coachFirstName,
    required this.coachLastName,
    required this.coachExperience,
  });

  // Factory constructor to create a TeamData object from the JSON response
  factory TeamData.fromJson(Map<String, dynamic> json) {
    // Make sure the data is being parsed correctly by accessing the 'team' key from the JSON response
    var team = json['team'];

    // Ensure all necessary fields are correctly accessed and parsed
    return TeamData(
      name: team['name'] ?? 'Unknown',
      abbreviation: team['abbreviation'] ?? 'N/A',
      location: team['location'] ?? 'Unknown',
      displayName: team['displayName'] ?? 'N/A',
      logoUrl: team['logo'] ?? '',
      recordSummary: team['recordSummary'] ?? '0-0',
      seasonSummary: team['seasonSummary'] ?? 'N/A',
      standingSummary: team['standingSummary'] ?? 'N/A',
      coachFirstName: json['coach']?[0]['firstName'] ?? 'Unknown',
      coachLastName: json['coach']?[0]['lastName'] ?? 'Unknown',
      coachExperience: json['coach']?[0]['experience'] ?? 0,
    );
  }

  // Convert TeamData to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'abbreviation': abbreviation,
      'location': location,
      'displayName': displayName,
      'logoUrl': logoUrl,
      'recordSummary': recordSummary,
      'seasonSummary': seasonSummary,
      'standingSummary': standingSummary,
      'coachFirstName': coachFirstName,
      'coachLastName': coachLastName,
      'coachExperience': coachExperience,
    };
  }
  
}
