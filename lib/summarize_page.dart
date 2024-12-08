import 'package:flutter/material.dart';

class SummarizePage extends StatelessWidget {
  final String output; // Assuming this will be passed from the backend

  const SummarizePage({super.key, required this.output});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF202222),
        centerTitle: true,
        title: Image.asset('assets/logo.png', height: 40),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start (left)
            children: <Widget>[
              const Center( // Center the title
                child: Text(
                  'Summarize',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.0),
                      // Removed border for a cleaner look
                    ),
                    child: Text(
                       "Google has launched a new service called Vertex AI, which uses deep learning technology to solve problems in artificial intelligence and other areas of the technology industry, such as image recognition and speech recognition, on the Google Cloud platform, the company has announced on Tuesday, with the launch of a new version of its Vertex platform.",
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.left, // Left align the output text
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

