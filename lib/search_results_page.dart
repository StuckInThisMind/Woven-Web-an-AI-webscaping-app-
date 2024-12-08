import 'package:flutter/material.dart';

class SearchResultsPage extends StatelessWidget {
  const SearchResultsPage({super.key});

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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Left align the column
            children: <Widget>[
              // Heading
              const Text(
                'Search Results',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20), // Space between heading and buttons

              // Clickable text boxes for different search engines
              _buildClickableBox(context, 'Google Results...', '/google'),
              const SizedBox(height: 15), // Uniform space between boxes
              _buildClickableBox(context, 'Bing Results...', '/bing'),
              const SizedBox(height: 15), // Uniform space between boxes
              _buildClickableBox(context, 'Yahoo Results...', '/yahoo'),
              const SizedBox(height: 15), // Uniform space between boxes
              _buildClickableBox(context, 'Yandex Results...', '/yandex'),
              const SizedBox(height: 15), // Uniform space between boxes
              _buildClickableBox(context, 'DuckDuckGo Results...', '/duckduckgo'),
              const Spacer(), // Push buttons to the bottom

              // Action buttons with centered text
              _buildActionButton(context, 'Summarize', '/summarize', Colors.white, const Color(0xFF202222)),
              const SizedBox(height: 10.0),
              _buildActionButton(context, 'Common Results', '/common', const Color(0xFFBA2D2D), Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create clickable boxes with left-aligned text
  Widget _buildClickableBox(BuildContext context, String title, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.0),
        ),
        alignment: Alignment.centerLeft, // Left align the text
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  // Helper method to create action buttons with centered text
  Widget _buildActionButton(BuildContext context, String title, String route, Color backgroundColor, Color textColor) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor, // Use backgroundColor instead of primary
        shape: RoundedRectangleBorder( // Remove borders by using a rounded rectangle shape
          borderRadius: BorderRadius.circular(12.0), // Optional: add rounded corners
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, route); // Navigate to the specified page
      },
      child: Center( // Center the text inside the button
        child: Text(
          title,
          style: TextStyle(color: textColor), // Set text color
        ),
      ),
    );
  }
}
