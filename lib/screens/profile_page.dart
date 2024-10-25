
import 'package:flutter/material.dart';
import 'package:carparking2/screens/profile_page.dart'; // This should match the actual file path
import 'login_page.dart';

void main() {
  runApp(UserProfileApp());
}

class UserProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserProfilePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black, // Set the background color
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile image
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            // Email Text
            Text(
              'kartik32@gmail.com',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            // User Profile Form
            Text(
              'User Profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Set text color for visibility
              ),
            ),
            SizedBox(height: 20),
            // Name TextField
            TextFormField(
              initialValue: 'ABC Kumar',
              decoration: InputDecoration(
                labelText: 'Enter Your Name',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 10),
            // Car Number TextField
            TextFormField(
              initialValue: 'GJ-03 JP 2556',
              decoration: InputDecoration(
                labelText: 'Car No.',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 10),
            // Phone Number TextField
            TextFormField(
              initialValue: '8649205675',
              decoration: InputDecoration(
                labelText: 'Phone No.',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 20),
            // Logout Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
                // Handle logout action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logged out')),
                );
              },
              child: Text('Logout'),
            ),
            SizedBox(height: 10),
            // Back Button
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
              child: Text(
                'Back',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
