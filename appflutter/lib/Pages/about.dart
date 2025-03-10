import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AboutUs {
  final int aboutId;
  final String title;
  final String details;
  final String? pictures;

  // Constructor
  AboutUs({
    required this.aboutId,
    required this.title,
    required this.details,
    this.pictures,
  });

  // Factory method to create an instance from JSON
  factory AboutUs.fromJson(Map<String, dynamic> json) {
    return AboutUs(
      aboutId: json['about_id'],
      title: json['title'],
      details: json['details'],
      pictures: json['pictures'],
    );
  }

  // Method to convert an instance to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'about_id': aboutId,
      'title': title,
      'details': details,
      'pictures': pictures,
    };
  }
}

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  List<dynamic> aboutUsData = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchAboutUsData();
  }

  Future<void> fetchAboutUsData() async {
    final url = Uri.parse('http://10.0.2.2:8000/about-us/');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        setState(() {
          aboutUsData = jsonData['data'];
          isLoading = false;
        });
      } else if (response.statusCode == 400) {
        setState(() {
          errorMessage = 'No data available.';
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'An error occurred. Please try again later.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
   return SafeArea(
      child: Scaffold(
      appBar: AppBar(
        title: Text('About Us',  style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF13136A), Color(0xFF5C6BC0)], // Gradient colors
                                begin: Alignment.bottomRight, // Start from top-left
                                end: Alignment.topLeft, // End at bottom-right
                              ),
                            ),
                          ),
                          leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: aboutUsData.length,
                 itemBuilder: (context, index) {
  final item = aboutUsData[index];
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title Section
        Text(
          item['title'],
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),

        // Image Section
        item['pictures'] != null
            ? Image.network(
                'http://192.168.1.69:8000${item['pictures']}', // Prepend base URL
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            : Container(
                height: 200,
                color: Colors.grey,
                child: Icon(
                  Icons.image_not_supported,
                  size: 50,
                  color: Colors.white,
                ),
              ),
        SizedBox(height: 10),

        // Description Section
        Text(
          item['details'],
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
          textAlign: TextAlign.justify,
        ),
        SizedBox(height: 20),
        Divider(color: Colors.grey),
      ],
    ),
  );
},

                ),
    ));
  }
}
