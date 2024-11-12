import 'package:flutter/material.dart';
import 'TeamData.dart';

class StatsScreen extends StatelessWidget {
  final TeamData? teamData; // Passes data from MyHomePage

  const StatsScreen({Key? key, required this.teamData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: teamData != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(teamData!.logoUrl),
                  const SizedBox(height: 16),
                  Text(
                    'Team: ${teamData!.name}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Location: ${teamData!.location}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Record: ${teamData!.recordSummary}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Standing: ${teamData!.standingSummary}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Coach: ${teamData!.coachFirstName} ${teamData!.coachLastName}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Experience: ${teamData!.coachExperience} years',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              )
            : const Center(
                child: Text('Scan a QR code to display team stats'),
              ),
      ),
    );
  }
}
