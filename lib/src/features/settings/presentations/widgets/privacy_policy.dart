// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const TextWidget(
          text: 'Privacy Policy',
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              TextWidget(
                text: 'Privacy Policy for 1Parliament1',
                fontSize: 22,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 16),
              TextWidget(
                text:
                    'Welcome to 1Parliament1. Your privacy is important to us. This Privacy Policy explains how we collect, use, disclose, and protect your information when you use our mobile application 1Parliament1.',
                fontSize: 14,
              ),
              SizedBox(height: 16),
              TextWidget(
                text: '1. Information We Collect',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 8),
              TextWidget(
                text:
                    'a. Personal Information:\n- Name\n- Email address\n- Phone number\n- Profile photo\n\nb. Usage Data:\n- IP address\n- Device information (model, OS version)\n- App usage statistics\n\nc. Media Access:\n- Camera and gallery access (only with permission)',
                fontSize: 14,
              ),
              SizedBox(height: 16),
              TextWidget(
                text: '2. How We Use Your Information',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 8),
              TextWidget(
                text:
                    'We use the information to:\n- Provide and maintain the App\n- Personalize user experience\n- Improve features and functionality\n- Communicate with you\n- Ensure security and prevent fraud',
                fontSize: 14,
              ),
              SizedBox(height: 16),
              TextWidget(
                text: '3. Sharing of Information',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 8),
              TextWidget(
                text:
                    'We do not sell or rent your personal data. We may share it with:\n- Service providers (e.g., cloud or analytics tools)\n- Law enforcement when required\n- Partners with your consent',
                fontSize: 14,
              ),
              SizedBox(height: 16),
              TextWidget(
                text: '4. Data Security',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 8),
              TextWidget(
                text:
                    'We take steps to protect your data, but no system is 100% secure.',
                fontSize: 14,
              ),
              SizedBox(height: 16),
              TextWidget(
                text: '5. Your Rights',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 8),
              TextWidget(
                text:
                    'You may have the right to:\n- Access or update your info\n- Delete your account\n- Withdraw consent\n\nContact us at: [your support email]',
                fontSize: 14,
              ),
              SizedBox(height: 16),
              TextWidget(
                text: '6. Children\'s Privacy',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 8),
              TextWidget(
                text:
                    'Our app is not for children under 13. We don’t knowingly collect data from them.',
                fontSize: 14,
              ),
              SizedBox(height: 16),
              TextWidget(
                text: '7. Changes to this Policy',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 8),
              TextWidget(
                text:
                    'We may update this Privacy Policy from time to time. Updates will be posted here with the effective date.',
                fontSize: 14,
              ),
              SizedBox(height: 16),
              TextWidget(
                text: '8. Contact Us',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 8),
              TextWidget(
                text:
                    'Email: "support@1parliament1.com"\nApp Name: 1Parliament1',
                fontSize: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
