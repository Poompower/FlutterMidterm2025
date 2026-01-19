import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final VoidCallback onGoHome;

  const AppDrawer({
    super.key,
    required this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const ListTile(
              title: Text(
                'Todo Midterm',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Flutter: widgets / navigation / form'),
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.checklist),
              title: const Text('To-do List'),
              onTap: () {
                Navigator.pop(context);
                onGoHome();
              },
            ),

            const Spacer(),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Lesson 5/6/7 (Design, API, Storage)\nยังไม่ทำตามโจทย์',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
