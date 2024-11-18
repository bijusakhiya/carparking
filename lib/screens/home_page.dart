import 'package:flutter/material.dart';
import 'bookslot_page.dart'; // Assuming this file exists
import 'profile_page.dart'; // For UserProfilePage
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingSlotsPage extends StatefulWidget {
  @override
  _ParkingSlotsPageState createState() => _ParkingSlotsPageState();
}

class _ParkingSlotsPageState extends State<ParkingSlotsPage> {
  String? userName;
  String? userEmail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Fetch user details from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            userName = userDoc['userName'] ?? 'User';
            userEmail = userDoc['email'] ?? 'No Email';
          });
        } else {
          setState(() {
            userName = 'Unknown User';
            userEmail = 'Unknown Email';
          });
        }
      }
    } catch (e) {
      print("Error fetching user details: $e");
      setState(() {
        userName = 'Error';
        userEmail = 'Error';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfileApp()),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[400],
                    child: Icon(
                      Icons.person,
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
                  SizedBox(width: 10),
                  isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName ?? 'Unknown User',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userEmail ?? 'Unknown Email',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            Divider(color: Colors.grey[700], thickness: 1),

            // Parking Slots Title
            Center(
              child: Text(
                'Parking Slots',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),

            // Parking Slots Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: List.generate(10, (index) {
                  bool isSlotGreen = index % 2 == 0;

                  return GestureDetector(
                    onTap: () {
                      if (isSlotGreen) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BookSlotPage(slotNumber: index + 1),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Slot Full'),
                              content: Text(
                                  'The slot is already full. Please select another slot.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSlotGreen ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Slot - ${index + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Legend (Empty and Full Status)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle, color: Colors.red, size: 20),
                SizedBox(width: 5),
                Text(
                  'Booked',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(width: 20),
                Icon(Icons.circle, color: Colors.green, size: 20),
                SizedBox(width: 5),
                Text(
                  'Available',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
