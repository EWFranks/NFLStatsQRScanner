import 'package:flutter/material.dart';
import 'TeamData.dart';

class StatsScreen extends StatelessWidget {
  final List<TeamData> scannedTeams;

  const StatsScreen({super.key, required this.scannedTeams});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Stats'),
      ),
      body: scannedTeams.isEmpty
          ? const Center(child: Text('No team data scanned yet.'))
          : ListView.builder(
              itemCount: scannedTeams.length,
              itemBuilder: (context, index) {
                final team = scannedTeams[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          team.displayName,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Image.network(
                          team.logoUrl,
                          height: 50,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        ),
                        const SizedBox(height: 8),
                        Text('Location: ${team.location}'),
                        Text('Record: ${team.recordSummary}'),
                        Text('Season Summary: ${team.seasonSummary}'),
                        Text('Standing: ${team.standingSummary}'),
                        Text(
                            'Coach: ${team.coachFirstName} ${team.coachLastName} (${team.coachExperience} years)'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
