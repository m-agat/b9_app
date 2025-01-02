import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'prediction_result_page.dart';

class SavedReportsPage extends StatefulWidget {
  @override
  _SavedReportsPageState createState() => _SavedReportsPageState();
}

class _SavedReportsPageState extends State<SavedReportsPage> {
  List<Map<String, dynamic>> savedReports = [];

  @override
  void initState() {
    super.initState();
    _loadReports(); // Load saved reports when the page is loaded
  }

  // Load saved reports from SharedPreferences
  Future<void> _loadReports() async {
    final prefs = await SharedPreferences.getInstance();
    final reports = prefs.getStringList('reports') ?? [];
    setState(() {
      savedReports = reports
          .map((report) => Map<String, dynamic>.from(jsonDecode(report)))
          .toList();
    });
  }

  // Remove the selected report from SharedPreferences
  Future<void> _removeReport(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final reports = prefs.getStringList('reports') ?? [];
    reports.removeAt(index); // Remove the report at the specified index
    await prefs.setStringList('reports', reports); // Save the updated list

    // Update the savedReports list and refresh the UI
    setState(() {
      savedReports.removeAt(index); // Remove from the list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved Reports',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          ),
        centerTitle: true,
        backgroundColor: Color(0xFFFFF6F1),
        elevation: 0,
      ),
      body: Container(
        color: Color(0xFFFFF6F1),
        padding: EdgeInsets.all(20),
        child: savedReports.isEmpty
            ? Center(
                child: Text(
                  'No reports saved yet.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              )
            : ListView.builder(
                itemCount: savedReports.length,
                itemBuilder: (context, index) {
                  final report = savedReports[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PredictionResultPage(
                            predictedClass: report['predictedClass'],
                            confidence: report['confidence'],
                            moleLocation: report['location'],
                            imagePath: report['imagePath'],
                            isNew: false,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            // Display the saved image
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: FileImage(File(report['imagePath'])),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            // Display date and location
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Date: ${report['date']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Location: ${report['location']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Delete Button
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _removeReport(index); // Remove the report
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
