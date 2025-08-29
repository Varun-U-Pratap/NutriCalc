import 'package:flutter/material.dart';
import 'package:nutricalc/constants/api_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiKeysScreen extends StatefulWidget {
  const ApiKeysScreen({super.key});

  @override
  State<ApiKeysScreen> createState() => _ApiKeysScreenState();
}

class _ApiKeysScreenState extends State<ApiKeysScreen> {
  late final TextEditingController _edamamAppIdController;
  late final TextEditingController _edamamAppKeyController;
  late final TextEditingController _geminiApiKeyController;

  @override
  void initState() {
    super.initState();
    _edamamAppIdController = TextEditingController(text: ApiConstants.appId);
    _edamamAppKeyController = TextEditingController(text: ApiConstants.appKey);
    _geminiApiKeyController = TextEditingController(text: ApiConstants.geminiApiKey);
  }

  @override
  void dispose() {
    _edamamAppIdController.dispose();
    _edamamAppKeyController.dispose();
    _geminiApiKeyController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<bool> _showConfirmationDialog({required String title, required String content}) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Confirm"),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit API Keys")),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          _buildSectionHeader("Edamam API Keys"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _edamamAppIdController,
              decoration: const InputDecoration(labelText: "Edamam App ID", border: OutlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _edamamAppKeyController,
              decoration: const InputDecoration(labelText: "Edamam App Key", border: OutlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                final confirmed = await _showConfirmationDialog(
                  title: "Confirm Changes",
                  content: "Are you sure you want to save these Edamam API keys?",
                );
                if (confirmed) {
                  ApiConstants.saveEdamamKeys(_edamamAppIdController.text, _edamamAppKeyController.text);
                  _showSuccessSnackBar("Edamam keys saved!");
                }
              },
              child: const Text("Save Edamam Keys"),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.link),
            title: const Text("Get Edamam API Keys"),
            subtitle: const Text("For food search functionality"),
            onTap: () => _launchURL("https://developer.edamam.com/"),
          ),
          
          const Divider(),

          _buildSectionHeader("Gemini API Key"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _geminiApiKeyController,
              decoration: const InputDecoration(labelText: "Gemini API Key", border: OutlineInputBorder()),
            ),
          ),
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                final confirmed = await _showConfirmationDialog(
                  title: "Confirm Changes",
                  content: "Are you sure you want to save this Gemini API key?",
                );
                if (confirmed) {
                  ApiConstants.saveGeminiKey(_geminiApiKeyController.text);
                  _showSuccessSnackBar("Gemini API key saved!");
                }
              },
              child: const Text("Save Gemini Key"),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.link),
            title: const Text("Get Gemini API Key"),
            subtitle: const Text("For diet plan, tip, and chatbot"),
            onTap: () => _launchURL("https://aistudio.google.com/"),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
