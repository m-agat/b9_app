import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'skin_lesion_report.dart';
import 'dart:io';

class PredictionResultPage extends StatelessWidget {
  final String predictedClass;
  final double confidence;
  final String moleLocation;
  final String imagePath;
  final bool isNew;

  // Mapping of class numbers to disease names
  static const Map<String, String> diseaseNames = {
    '0': 'Benign Keratosis-like Lesions',
    '1': 'Basal Cell Carcinoma',
    '2': 'Actinic Keratoses',
    '3': 'Vascular Lesions',
    '4': 'Melanocytic Nevi',
    '5': 'Melanoma',
    '6': 'Dermatofibroma',
  };

  // Mapping of class numbers to descriptions
  static const Map<String, String> diseaseDescriptions = {
    '0': 'Benign keratosis is a harmless skin growth often caused by sun exposure or aging. It appears as scaly, thickened, or warty patches and is non-cancerous. While not a concern, it’s important to monitor changes in your skin for early detection of potential issues.',
    '1': 'Basal cell carcinoma is a slow-growing type of skin cancer. It often appears as a pearly bump or a lesion with visible blood vessels and raised edges. Early treatment is highly effective.',
    '2': 'Actinic keratoses are rough, scaly patches caused by long-term sun exposure. While often harmless, they can occasionally develop into skin cancer if left untreated.',
    '3': 'Vascular lesions are reddish or purplish growths caused by blood vessels. These are typically benign and include conditions like spider veins or angiomas.',
    '4': 'Melanocytic nevi, or moles, are generally harmless pigmented skin lesions. Regular monitoring is recommended to detect any unusual changes.',
    '5': 'Melanoma is a serious form of skin cancer characterized by irregular borders, multiple colors, and asymmetry. Immediate consultation with a specialist is recommended.',
    '6': 'Dermatofibroma is a benign, firm, and small growth often caused by minor skin injuries. It’s harmless and doesn’t require treatment unless symptomatic.',
  };

  const PredictionResultPage({
    Key? key,
    required this.predictedClass,
    required this.confidence,
    required this.moleLocation,
    required this.imagePath,
    required this.isNew,
  }) : super(key: key);

  Future<void> saveReport(SkinLesionReport report) async {
    final prefs = await SharedPreferences.getInstance();
    final reports = prefs.getStringList('reports') ?? [];
    reports.add(jsonEncode(report.toJson())); // Convert to JSON and save
    await prefs.setStringList('reports', reports);
  }

  @override
  Widget build(BuildContext context) {
    final report = SkinLesionReport(
      imagePath: imagePath,
      date: DateTime.now().toLocal().toString().split(' ')[0],
      location: moleLocation,
      predictedClass: predictedClass,
      confidence: confidence,
    );

    final diseaseName = diseaseNames[predictedClass] ?? 'Unknown';
    final diseaseDescription =
        diseaseDescriptions[predictedClass] ?? 'No description available for this condition.';

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Mole Report'),
        centerTitle: true,
        backgroundColor: Color(0xFFFFF6F1),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: Color(0xFFFFF6F1),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Submitted Image
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: FileImage(File(imagePath)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                // Details next to the image
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Picture details:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Date: ${DateTime.now().toLocal().toString().split(' ')[0]}',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Location: $moleLocation',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),

            // Prediction Details
            Text(
              'We think it is...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 10),
            Text(
              diseaseName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Confidence: ${(confidence * 100).toStringAsFixed(2)}%',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 20),

            // Description Section
            Text(
              diseaseDescription,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 30),

            // Warning Section
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFE78A82),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Important!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Our diagnosis should not be treated as a professional examination. It’s always better to consult your results with a real doctor.',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ),
            Spacer(),

            // Save Button
            if (isNew)
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await saveReport(report);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Report saved successfully!')),
                    );
                  },
                  child: Text('Save Report'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFE78A82),
                    onPrimary: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}