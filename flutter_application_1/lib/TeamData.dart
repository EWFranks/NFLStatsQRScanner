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
    
    var team = json['team'] ?? {};
    var coach = json['coach']?[0] ?? {}; 

    return TeamData(
      name: team['name'] ?? 'Unknown', 
      abbreviation: team['abbreviation'] ?? 'N/A',
      location: team['location'] ?? 'Unknown',
      displayName: team['displayName'] ?? 'N/A',
      logoUrl: team['logo'] ?? '',  
      recordSummary: team['recordSummary'] ?? '0-0',  
      seasonSummary: team['seasonSummary'] ?? 'N/A',  
      standingSummary: team['standingSummary'] ?? 'N/A',  
      coachFirstName: coach['firstName'] ?? 'Unknown',  
      coachLastName: coach['lastName'] ?? 'Unknown',    
      coachExperience: coach['experience'] ?? 0,       
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

  @override
  String toString() {
    return 'TeamData{name: $name, abbreviation: $abbreviation, location: $location, displayName: $displayName, logoUrl: $logoUrl, recordSummary: $recordSummary, seasonSummary: $seasonSummary, standingSummary: $standingSummary, coachFirstName: $coachFirstName, coachLastName: $coachLastName, coachExperience: $coachExperience}';
  }
}
