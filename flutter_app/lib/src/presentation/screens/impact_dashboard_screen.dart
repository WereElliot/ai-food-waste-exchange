import 'package:flutter/material.dart';

class ImpactDashboardScreen extends StatelessWidget {
  const ImpactDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Impact')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _ImpactCard(
              title: 'Food Saved',
              value: '124.5 kg',
              icon: Icons.eco,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            _ImpactCard(
              title: 'CO2 Reduced',
              value: '312.0 kg',
              icon: Icons.cloud,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            _ImpactCard(
              title: 'Meals Provided',
              value: '450',
              icon: Icons.restaurant,
              color: Colors.orange,
            ),
            const SizedBox(height: 32),
            const Text(
              'Top Food Savers this Month',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Mock leaderboard
            const ListTile(
              leading: CircleAvatar(child: Text('1')),
              title: Text('Were Elliot'),
              trailing: Text('45kg saved'),
            ),
            const ListTile(
              leading: CircleAvatar(child: Text('2')),
              title: Text('GreenNGO'),
              trailing: Text('38kg saved'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImpactCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _ImpactCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
