import 'package:flutter/material.dart';

class CommonResultsPage extends StatelessWidget {
  final List<String> results; // This will be passed from the backend

  const CommonResultsPage({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF202222),
        centerTitle: true,
        title: Image.asset('assets/logo.png', height: 40),
      ),
      body: Container(
        width: double.infinity, // Ensure the container takes the full width
        height: double.infinity, // Ensure the container takes the full height
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.png"),
            fit: BoxFit.cover, // Ensures the background image covers the entire container
            alignment: Alignment.center, // Center the image
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Align to the left
            children: <Widget>[
              const Text(
                'Common Results',
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Title color is white
                ),
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch, // Ensures the cards stretch to fill the width
                    children: results.map((result) {
                      return _buildResultCard(result);
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(String result) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1), // Background color
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        result,
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center, // Center text within the card
      ),
    );
  }
}
