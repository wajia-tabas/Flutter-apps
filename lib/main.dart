import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toppr UI',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('toppr'),
        actions: [
          Icon(Icons.notifications),
          SizedBox(width: 10),
          Icon(Icons.shopping_cart),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          // Profile Section
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150'), // Replace with actual image URL
                ),
                SizedBox(width: 16),
                Text(
                  'Wajeeha',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          // Subject Grid
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16),
              children: [
                SubjectTile(
                    subject: 'Science', videos: 25, goals: 345, concepts: 322),
                SubjectTile(
                    subject: 'Mathematics',
                    videos: 25,
                    goals: 345,
                    concepts: 322),
                SubjectTile(
                    subject: 'English', videos: 25, goals: 345, concepts: 322),
                SubjectTile(
                    subject: 'Logical Reasoning',
                    videos: 25,
                    goals: 345,
                    concepts: 322),
                SubjectTile(
                    subject: 'History', videos: 25, goals: 345, concepts: 322),
                SubjectTile(
                    subject: 'Civic', videos: 25, goals: 345, concepts: 322),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.check_box), label: 'Tests'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Activities'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark), label: 'Bookmarks'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        ],
      ),
    );
  }
}

class SubjectTile extends StatelessWidget {
  final String subject;
  final int videos;
  final int goals;
  final int concepts;

  const SubjectTile({
    required this.subject,
    required this.videos,
    required this.goals,
    required this.concepts,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(subject,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('$videos Videos'),
            Text('$goals Goals'),
            Text('$concepts Concepts'),
          ],
        ),
      ),
    );
  }
}
