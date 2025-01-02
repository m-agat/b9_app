import 'package:flutter/material.dart';

class ConsultDoctorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF6F1), 
        elevation: 0, 
        title: const Text(
          'Consult Your Doctor',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFFFF6F1), 
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/images/cat_doctor.jpg', 
                height: 300,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              // Stay Tuned Text
              const Text(
                'Stay tuned!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}