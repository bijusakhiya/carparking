import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(UserProfileApp());
}

class UserProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserProfilePage(), // Initial screen
      debugShowCheckedModeBanner: false,
    );
  }
}

class UserProfilePage extends StatelessWidget {
  final String? userName;
  final String? email;
  final String? carNo;
  final String? phoneNo;
  final int? bookedSlot; // Optional, for users who haven't booked yet

  const UserProfilePage({
    this.userName,
    this.email,
    this.carNo,
    this.phoneNo,
    this.bookedSlot, // Slot details can be null
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: userName);
    TextEditingController emailController = TextEditingController(text: email);
    TextEditingController carNoController = TextEditingController(text: carNo);
    TextEditingController phoneController = TextEditingController(text: phoneNo);

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
            // Email TextField
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Enter Your Email',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 10),
            // Name TextField
            TextFormField(
              controller: nameController,
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
              controller: carNoController,
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
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone No.',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 10),
            // Booked Slot Display
            if (bookedSlot != null) ...[
              Text(
                'Booked Slot: Slot $bookedSlot',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
            ],
            // Save Changes Button
            ElevatedButton(
              onPressed: () {
                // Handle save logic here
                Navigator.pop(context, {
                  'userName': nameController.text,
                  'email': emailController.text,
                  'carNo': carNoController.text,
                  'phoneNo': phoneController.text,
                  'bookedSlot': bookedSlot,
                });
              },
              child: Text('Save Changes'),
            ),
            SizedBox(height: 10),
            // Logout Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
                // Handle logout action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logged out')),
                );
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
