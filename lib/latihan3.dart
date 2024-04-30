import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class University {
  final String name;
  final List<String> website;

  University({required this.name, required this.website});

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'],
      website: List<String>.from(json['web_pages']),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Universities in Indonesia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UniversityList(),
    );
  }
}

class UniversityList extends StatefulWidget {
  @override
  _UniversityListState createState() => _UniversityListState();
}

class _UniversityListState extends State<UniversityList> {
  Future<List<University>>? _universitiesFuture;

  @override
  void initState() {
    super.initState();
    _universitiesFuture = fetchUniversities();
  }

  Future<List<University>> fetchUniversities() async {
    final response = await http.get(
        Uri.parse('http://universities.hipolabs.com/search?country=Indonesia'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((univ) => University.fromJson(univ)).toList();
    } else {
      throw Exception('Failed to load universities');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Universities in Indonesia'),
      ),
      body: FutureBuilder<List<University>>(
        future: _universitiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<University>? universities = snapshot.data;
            return ListView.builder(
              itemCount: universities?.length,
              itemBuilder: (context, index) {
                University university = universities![index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.school, color: Colors.blue),
                    title: Text(university.name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Website: ${university.website.join(', ')}'),
                    trailing: IconButton(
                      icon: Icon(Icons.open_in_new, color: Colors.blue),
                      onPressed: () {},
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
