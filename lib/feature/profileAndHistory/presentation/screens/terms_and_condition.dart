import 'package:flutter/material.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xFF121212), // Dark theme
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Terms And Conditions',
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildParagraph(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lobortis risus eget magna euismod rhoncus. Vivamus eu lectus a lectus interdum placerat. Praesent consectetur ante orci, non mattis massa posuere in. Integer blandit ut mi eu efficitur. Praesent congue, arcu vitae malesuada vehicula, lacus velit facilisis velit, ut vehicula sapien erat id dui. Proin nisi ante, ullamcorper vitae libero eu, mollis venenatis lectus. Integer auctor et sem at sollicitudin. Sed eget diam nisi. Nulla in id.',
              ),
              const SizedBox(height: 20),
              _buildParagraph(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lobortis risus eget magna euismod rhoncus. Vivamus eu lectus a lectus interdum placerat.',
              ),
              const SizedBox(height: 20),
              _buildHeadingParagraph(
                heading: 'Praesent consectetur:',
                text:
                    'Ante orci, non mattis massa posuere in. Integer blandit ut mi eu efficitur. Praesent congue, arcu vitae malesuada vehicula, lacus velit facilisis velit, ut vehicula sapien erat id dui.',
              ),
              const SizedBox(height: 20),
              _buildParagraph(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lobortis risus eget magna euismod rhoncus. Vivamus eu lectus a lectus interdum placerat.',
              ),
              const SizedBox(height: 20),
              _buildHeadingParagraph(
                heading: 'Proin nisi ante:',
                text:
                    'Ullamcorper vitae libero eu, mollis venenatis lectus. Integer auctor et sem at sollicitudin. Sed eget diam nisi. Nulla in id.',
              ),
              const SizedBox(height: 20),
              _buildParagraph(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lobortis risus eget magna euismod rhoncus. Vivamus eu lectus a lectus interdum placerat.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      maxLines: 20,
      textAlign: TextAlign.justify, // 👈 Makes all lines end equally
      style: const TextStyle(
        fontSize: 16,
        fontFamily: 'Poppins',
        color: Colors.white,
        height: 1.6, // line height
        letterSpacing: 0.2, // subtle letter spacing
      ),
    );
  }

  Widget _buildHeadingParagraph({
    required String heading,
    required String text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.white, // Stylish light green
          ),
        ),

        const SizedBox(height: 8),
        _buildParagraph(text),
      ],
    );
  }
}
