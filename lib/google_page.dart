import 'package:flutter/material.dart';

class GooglePage extends StatelessWidget {
  const GooglePage({super.key});

  @override
  Widget build(BuildContext context) {
    const String output = '''
AI Trends on Coursera
https://www.coursera.org/articles/ai-trends#:~:text=Multimodal%20AI&text=Multimodel%20models%20in%20AI%20can,other%20applications%20we%20already%20use

Weekly Digest on AI and Emerging Technologies - PAM
https://pam.int/weekly-digest-on-ai-and-emerging-technologies-28-october-2024/

Latest Trends in Artificial Intelligence - Element14
https://in.element14.com/latest-trends-in-artificial-intelligence

Future of Artificial Intelligence - BuiltIn
https://builtin.com/artificial-intelligence/artificial-intelligence-future#:~:text=What%20does%20the%20future%20of,and%20worries%20over%20job%20losses

Top Generative AI Trends - SoluLab
https://www.solulab.com/top-generative-ai-trends/#:~:text=In%202024%2C%20Generative%20AI%20trends,empowers%20individuals%20across%20diverse%20domains

The 10 Biggest AI Trends of 2025 - Forbes
https://www.forbes.com/sites/bernardmarr/2024/09/24/the-10-biggest-ai-trends-of-2025-everyone-must-be-ready-for-today/

The 10 Biggest Generative AI Trends for 2024 - Forbes
https://www.forbes.com/sites/bernardmarr/2023/10/02/the-10-biggest-generative-ai-trends-for-2024-everyone-must-be-ready-for-now/

IDC's 2024 AI Opportunity Study - Microsoft Blog
https://blogs.microsoft.com/blog/2024/11/12/idcs-2024-ai-opportunity-study-top-five-ai-trends-to-watch/

Artificial Intelligence Trends - IBM
https://www.ibm.com/think/insights/artificial-intelligence-trends

Summary:
In the world of artificial intelligence (AI) and deep learning algorithms that can be used to make predictions on new data, such as dog, and other data that can help humans do, for example, as well as the world, but it can be, and the world.
    ''';

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Center(
                child: Text(
                  'Google',
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
                    ),
                    child: const Text(
                      output,
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.left,
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
