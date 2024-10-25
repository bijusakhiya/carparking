import 'package:flutter/material.dart';
import 'dart:async'; // Import for Timer
import 'bookslot_page.dart'; // Assuming this file exists
import 'profile_page.dart'; // You need to create this file for ProfilePage
import 'home_page.dart'; // Import your home page here

class SubmittedPage extends StatefulWidget {
  final int slotNumber; // Booked slot number
  final String name;
  final String carNo;
  final Duration bookingDuration; // New - Duration for the booking

  const SubmittedPage({
    required this.slotNumber,
    required this.name,
    required this.carNo,
    required this.bookingDuration, // Accept duration
  });

  @override
  _SubmittedPageState createState() => _SubmittedPageState();
}

class _SubmittedPageState extends State<SubmittedPage> {
  Timer? _timer;
  Duration? _remainingTime; // Remaining time for the booking

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.bookingDuration; // Initialize remaining time

    // Start a timer to update remaining time
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime!.inSeconds > 0) {
          _remainingTime = _remainingTime! - Duration(seconds: 1);
        } else {
          _timer!.cancel(); // Stop the timer when it reaches zero
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Clean up the timer
    super.dispose();
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
                // Navigate to ProfilePage when any profile info is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfilePage()),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name, // Show user name
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.carNo, // Show car number
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

            // Remaining Time Section
            Center(
              child: Text(
                'Time Remaining: ${_formatDuration(_remainingTime!)}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),

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
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: 10, // Show all 10 slots
                itemBuilder: (context, index) {
                  bool isBookedSlot = (index + 1) == widget.slotNumber; // Check if this is the booked slot

                  return GestureDetector(
                    onTap: () {
                      // Optionally handle the tap on any slot
                      // You can add additional logic here if needed
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isBookedSlot ? Colors.red : Colors.green, // Red for booked, green for available
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Slot - ${index + 1}', // Display slot number
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5), // Small space between slot name and time
                          if (isBookedSlot) // Only show time for the booked slot
                            Text(
                              _formatDuration(_remainingTime!),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12, // Smaller font size
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
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

            // Navigation Button to Home Page
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to Home Page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ParkingSlotsPage()), // Replace with your actual HomePage widget
                  );
                },
                child: Text('Book Another Slot'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button color
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12), // Button padding
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to format duration as HH:mm:ss
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }
}
