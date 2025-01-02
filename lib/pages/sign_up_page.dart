import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF6F1), // Match the background color
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // App Title
              Text(
                'B9',
                style: Theme.of(context).textTheme.headline1,
              ),
              const SizedBox(height: 10),
              // Subtitle
              Text(
                'Spot the Difference\nSave Your Skin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              // Description
              Text(
                'Create an account & take the\nfirst step toward monitoring\nyour skin health',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: Colors.black,
                    ),
              ),
              const SizedBox(height: 30),
              // Sign-up Buttons
              TapButton(
                icon: Image.asset(
                  'lib/assets/images/gmail_logo.png', // Gmail logo
                  height: 24,
                  width: 24,
                ),
                label: 'Sign up with Google',
              ),
              const SizedBox(height: 20),
              TapButton(
                icon: Icon(
                  Icons.facebook,
                  color: Colors.blue, // Facebook blue color
                  size: 24,
                ),
                label: 'Sign up with Facebook',
              ),
              const SizedBox(height: 20),
              TapButton(
                icon: Icon(
                  Icons.email,
                  color: const Color(0xFFEFBCB6), // Custom color for email
                  size: 24,
                ),
                label: 'Sign up with Email',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Button with Fixed Width and Icon Support
class TapButton extends StatelessWidget {
  final Widget icon; // Accepts a Widget for flexibility
  final String label;

  const TapButton({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: () {
          print('$label tapped');
        },
        splashColor: const Color(0xFFFFDFD8), 
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              icon, 
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
