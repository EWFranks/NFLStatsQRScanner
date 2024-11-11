import 'package:flutter/material.dart';
import 'TeamData.dart';  

class Stats extends StatelessWidget {
  final TeamData teamData;  // Pass team data 

  const Stats({Key? key, required this.teamData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${teamData.name} Stats'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(teamData.logoUrl),  
            SizedBox(height: 16),
            Text(
              'Team: ${teamData.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Abbreviation: ${teamData.abbreviation}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Location: ${teamData.location}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Record: ${teamData.recordSummary}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Standing: ${teamData.standingSummary}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Coach: ${teamData.coachFirstName} ${teamData.coachLastName} (Experience: ${teamData.coachExperience} years)',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
