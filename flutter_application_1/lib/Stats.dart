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
            // Display team logo
            Image.network(teamData.logoUrl),  
            SizedBox(height: 16),
            
          // Team name
          Text(
            'Team: ${teamData!.name}',  // Display team name
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            'Wins: ${teamData!.recordSummary.split('-')[0]}',  // Display Wins
            style: TextStyle(fontSize: 16),
          ),
          Text(
            'Losses: ${teamData!.recordSummary.split('-')[1]}',  // Display Losses
            style: TextStyle(fontSize: 16),
          ),
            
          ],
        ),
      ),
    );
  }
}
