import 'package:carparking2/screens/bookslot_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'profile_page.dart'; // Replace with the actual ProfilePage file
import 'home_page.dart'; // Replace with your ParkingSlotsPage file
import 'bookslot_page.dart'; // Replace with the actual BookSlotPage file

class SubmittedPage extends StatefulWidget {
  final int slotNumber; // Booked slot number
  final String name;
  final String carNo;
  final Duration bookingDuration; // Booking duration

  const SubmittedPage({
    required this.slotNumber,
    required this.name,
    required this.carNo,
    required this.bookingDuration,
  });

  @override
  _SubmittedPageState createState() => _SubmittedPageState();
}

class _SubmittedPageState extends State<SubmittedPage> {
  Timer? _timer;
  Duration? _remainingTime;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.bookingDuration;

    // Start countdown timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime!.inSeconds > 0) {
          _remainingTime = _remainingTime! - Duration(seconds: 1);
        } else {
          _timer!.cancel();
          _showTimerExpiredDialog();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showTimerExpiredDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Time Expired'),
          content: Text('Your booking time has expired. Please book again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ParkingSlotsPage(),
                  ),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.carNo,
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
                itemCount: 10, // Number of slots
                itemBuilder: (context, index) {
                  // Define slots that are always booked
                  List<int> alwaysBookedSlots = [2, 4, 6, 8, 10];

                  // Check if the slot is the booked one or part of always-booked slots
                  bool isBookedSlot = (index + 1) == widget.slotNumber || alwaysBookedSlots.contains(index + 1);

                  return GestureDetector(
                    onTap: () {
                      if (isBookedSlot) {
                        // Show a message if the slot is already booked
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('This slot is already booked, please book another.'),
                          ),
                        );
                      } else {
                        // Navigate to BookSlotPage for available slots
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookSlotPage(
                              slotNumber: index + 1, // Pass selected slot number
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isBookedSlot ? Colors.red : Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Slot - ${index + 1}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          // Show timer for the currently booked slot only
                          if ((index + 1) == widget.slotNumber)
                            Text(
                              _formatDuration(_remainingTime!),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Legend (Booked/Available)
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

  // Helper function to format duration as HH:mm:ss
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }
}
