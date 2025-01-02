import 'package:flutter/material.dart';
import 'package:b9_app/pages/image_classifier_page.dart'; 
import 'saved_reports_page.dart';
import 'consult_results_page.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF6F1), 
        elevation: 0,
        title: const Text(
          'Menu',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFFFF6F1), 
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            children: [
              MenuCard(
                imagePath: 'lib/assets/images/menu_1.png',
                title: 'Take a photo',
                description: 'Take a picture of the skin change you want to analyze.',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageClassifierPage(), 
                    ),
                  );
                },
              ),
              const SizedBox(height: 30), 
              MenuCard(
                imagePath: 'lib/assets/images/menu_2.png',
                title: 'Read the reports',
                description: 'Learn more about your skin change.',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SavedReportsPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30), 
              MenuCard(
                imagePath: 'lib/assets/images/menu_3.png',
                title: 'Consult your results',
                description: 'Ask for a consultation with a nearby dermatologist.',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConsultDoctorPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final VoidCallback onTap;

  const MenuCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFB5A9),
          borderRadius: BorderRadius.circular(16), 
        ),
        padding: const EdgeInsets.all(20), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  imagePath,
                  height: 140, 
                  width: 120, 
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 16, 
                          color: Colors.black, 
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
