class SkinLesionReport {
  final String imagePath;
  final String date;
  final String location;
  final String predictedClass;
  final double confidence;

  SkinLesionReport({
    required this.imagePath,
    required this.date,
    required this.location,
    required this.predictedClass,
    required this.confidence,
  });

  // Convert to JSON for saving in SharedPreferences
  Map<String, dynamic> toJson() => {
        'imagePath': imagePath,
        'date': date,
        'location': location,
        'predictedClass': predictedClass,
        'confidence': confidence,
      };

  // Create a report from JSON
  factory SkinLesionReport.fromJson(Map<String, dynamic> json) => SkinLesionReport(
        imagePath: json['imagePath'],
        date: json['date'],
        location: json['location'],
        predictedClass: json['predictedClass'],
        confidence: json['confidence'],
      );
}
