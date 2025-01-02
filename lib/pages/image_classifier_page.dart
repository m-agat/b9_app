import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'prediction_result_page.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class ImageClassifierPage extends StatefulWidget {
  @override
  _ImageClassifierPageState createState() => _ImageClassifierPageState();
}

class _ImageClassifierPageState extends State<ImageClassifierPage> {
  File? _imageFile;
  bool _isSubmitting = false;
  String? _selectedLocation;
  List<String> _locations = []; // List to store saved locations
  int _progressStep = 0; // Steps to track progress: 0 = idle, 1 = submitting, 2 = analyzing, 3 = matching the images

  @override
  void initState() {
    super.initState();
    _loadSavedLocations(); // Show the already saved locations 
  }

  Future<void> _loadSavedLocations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _locations = prefs.getStringList('locations') ?? [];
    });
  }

  Future<void> _saveNewLocation(String location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _locations.add(location);
    });
    await prefs.setStringList('locations', _locations);
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? selectedImage = await picker.pickImage(source: source);

    if (selectedImage == null) return;

    final File imageFile = File(selectedImage.path);
    setState(() {
      _imageFile = imageFile;
      _isSubmitting = true;
      _progressStep = 1; // Start submission 
    });

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _progressStep = 2; // Analyzing step
    });

    await Future.delayed(Duration(seconds: 3));

    final result = await classifyImage(_imageFile!);

    setState(() {
      _isSubmitting = false;
      _progressStep = 0; // Reset progress step
    });

    if (result != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PredictionResultPage(
            predictedClass: result['predicted_class'].toString(),
            confidence: result['confidence'],
            moleLocation: _selectedLocation ?? 'Unknown',
            imagePath: _imageFile!.path,
            isNew: true,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred while processing the image')),
      );
    }
  }

  Future<Map<String, dynamic>?> classifyImage(File image) async {
    final url = Uri.parse("http://10.0.2.2:8000/predict");

    try {
      final request = http.MultipartRequest("POST", url);
      request.files.add(await http.MultipartFile.fromPath("file", image.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        return json.decode(responseData);
      } else {
        print("Error: ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Widget _buildProgressIndicator() {
    switch (_progressStep) {
      case 1:
        return Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Text('Submitting your photo...', style: TextStyle(fontSize: 16)),
          ],
        );
      case 2:
        return Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Text('Analyzing...', style: TextStyle(fontSize: 16)),
          ],
        );
      case 3:
        return Row(
          children: [
            Icon(Icons.timelapse, color: Colors.blue),
            SizedBox(width: 10),
            Text('Matching results...', style: TextStyle(fontSize: 16)),
          ],
        );
      default:
        return SizedBox.shrink();
    }
  }

  Future<void> _showPhotoSourceDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Submit Photo'),
          content: Text('Choose a method to submit your photo:'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
              child: Text('Open Camera'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
              child: Text('Open Gallery'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Skin Lesion Classifier',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFFFF6F1),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end, 
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: DropdownButton<String>(
                    value: _selectedLocation,
                    hint: Text('Select Mole Location'),
                    underline: SizedBox(),
                    items: [
                      ..._locations.map((location) => DropdownMenuItem(
                            child: Text(location),
                            value: location,
                          )),
                      DropdownMenuItem(
                        child: Text('Add Location'),
                        value: 'Add Location',
                      ),
                    ],
                    onChanged: (value) {
                      if (value == 'Add Location') {
                        showDialog(
                          context: context,
                          builder: (context) {
                            String? customLocation;
                            return AlertDialog(
                              title: Text('Add Custom Location'),
                              content: TextField(
                                onChanged: (text) {
                                  customLocation = text;
                                },
                                decoration: InputDecoration(hintText: 'Enter location'),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (customLocation != null && customLocation!.isNotEmpty) {
                                      _saveNewLocation(customLocation!);
                                      setState(() {
                                        _selectedLocation = customLocation;
                                      });
                                    }
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        setState(() {
                          _selectedLocation = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _imageFile != null
                ? Image.file(
                    _imageFile!,
                    height: 250,
                    width: 250,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 250,
                    width: 250,
                    color: Colors.grey[300],
                    child: Icon(Icons.camera_alt, size: 100, color: Colors.grey),
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showPhotoSourceDialog,
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFE78A82),
                onPrimary: Colors.black,
              ),
              child: Text('Submit Photo'),
            ),
            const SizedBox(height: 20),
            if (_isSubmitting) _buildProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
