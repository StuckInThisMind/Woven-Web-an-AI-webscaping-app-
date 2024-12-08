import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'search_state.dart';
import 'api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleSearch() async {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      setState(() {
        _isSearching = true;
      });

      final success = await _apiService.initiateSearch(query);
      if (success) {
        // Wait for the search to complete
        bool isComplete = false;
        while (!isComplete) {
          await Future.delayed(const Duration(seconds: 1));
          isComplete = await _apiService.checkSearchStatus();
        }

        if (mounted) {
          // Navigate to search results page
          Navigator.pushNamed(context, '/search');
        }
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Search failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }

      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = Provider.of<SearchState>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF202222),
        centerTitle: true,
        title: Image.asset('assets/logo.png', height: 40),
        actions: [
          if (_isSearching)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'wovenweb',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Where curiosity meets clarity.',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 40.0),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.white54),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.white70),
                        onPressed: _handleSearch,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Expanded(
                  child: Consumer<SearchState>(
                    builder: (context, searchState, child) {
                      return ListView.builder(
                        itemCount: searchState.previousSearches.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              searchState.previousSearches[index],
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}