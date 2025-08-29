// lib/screens/developer_info_screen.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperInfoScreen extends StatelessWidget {
  const DeveloperInfoScreen({super.key});

  // Helper function to launch a URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About the Developers"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildDeveloperCard(
            context: context,
            name: "Varun U Pratap",
            usn: "1MS24CS215",
            description: "Pursuing Computer Science and Engineering in MS Ramaiah Institute of Technology.",
            linkedinUrl: "https://in.linkedin.com/in/varun-u-pratap-856826340",
          ),
          const SizedBox(height: 16),
          _buildDeveloperCard(
            context: context,
            name: "Utsav S R",
            usn: "1MS24CS208",
            description: "That's me.",
            linkedinUrl: "https://in.linkedin.com/in/utsav-s-r-633a91379",
          ),
        ],
      ),
    );
  }

  // Helper widget to build a developer info card
  Widget _buildDeveloperCard({
    required BuildContext context,
    required String name,
    required String usn,
    required String description,
    required String linkedinUrl,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              usn,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const Divider(height: 20),
            Text(description),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.link),
                label: const Text("LinkedIn Profile"),
                onPressed: () => _launchURL(linkedinUrl),
              ),
            ),
          ],
        ),
      ),
    );
  }
}