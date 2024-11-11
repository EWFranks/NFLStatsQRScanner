class TeamData {
  final String teamId;
  final String abbreviation;
  final String location;
  final String name;
  final String displayName;
  final String clubhouseUrl;
  final String color;
  final String logoUrl;
  final String recordSummary;
  final String seasonSummary;
  final String standingSummary;
  final String coachFirstName;
  final String coachLastName;
  final int coachExperience;

  // Constructors
  TeamData({
    required this.teamId,
    required this.abbreviation,
    required this.location,
    required this.name,
    required this.displayName,
    required this.clubhouseUrl,
    required this.color,
    required this.logoUrl,
    required this.recordSummary,
    required this.seasonSummary,
    required this.standingSummary,
    required this.coachFirstName,
    required this.coachLastName,
    required this.coachExperience,
  });

  // Create a TeamData instance from JSON data
  factory TeamData.fromJson(Map<String, dynamic> json) {
    var teamJson = json['team'];
    var coachJson = json['coach'][0]; 

    return TeamData(
      teamId: teamJson['id'],
      abbreviation: teamJson['abbreviation'],
      location: teamJson['location'],
      name: teamJson['name'],
      displayName: teamJson['displayName'],
      clubhouseUrl: teamJson['clubhouse'],
      color: teamJson['color'],
      logoUrl: teamJson['logo'],
      recordSummary: teamJson['recordSummary'],
      seasonSummary: json['season']['displayName'],
      standingSummary: teamJson['standingSummary'],
      coachFirstName: coachJson['firstName'],
      coachLastName: coachJson['lastName'],
      coachExperience: coachJson['experience'],
    );
  }
}
