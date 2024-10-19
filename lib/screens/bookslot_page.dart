import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importing DateFormat

void main() => runApp(CarParkApp());

class CarParkApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BookSlotPage(slotNumber: 1),
    );
  }
}

class BookSlotPage extends StatefulWidget {
  final int slotNumber;

  const BookSlotPage({required this.slotNumber});

  @override
  _BookSlotPageState createState() => _BookSlotPageState();
}

class _BookSlotPageState extends State<BookSlotPage> {
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  int _selectedDuration = 1; // Default duration: 1 hour

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  // Formats the selected TimeOfDay into a readable format (e.g., 12:00 PM)
  String formatTime(TimeOfDay? time) {
    if (time == null) return '--:--';
    final now = DateTime.now();
    final formattedTime = DateFormat.jm()
        .format(DateTime(now.year, now.month, now.day, time.hour, time.minute));
    return formattedTime;
  }

  // Validate if the start and end times are properly selected and the end time is after the start time
  bool validateTimeSelection() {
    if (_startTime != null && _endTime != null) {
      final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
      final endMinutes = _endTime!.hour * 60 + _endTime!.minute;
      return endMinutes > startMinutes;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Book Slot'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Image.asset(
              'assets/images/logo.jpg', // Replace with your logo path
              height: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Book Slot ${widget.slotNumber}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // Name TextField
            TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter Your Name',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 15),

            // Car No. TextField
            TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Car No.',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            // "Book Slot" Title

            // Start Time Picker
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Start Time: ',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                GestureDetector(
                  onTap: () => _selectTime(context, true),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      formatTime(_startTime),
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // End Time Picker
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'End Time: ',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                GestureDetector(
                  onTap: () => _selectTime(context, false),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      formatTime(_endTime),
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Duration Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Duration: ',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                DropdownButton<int>(
                  value: _selectedDuration,
                  dropdownColor: Colors.grey[800],
                  items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                      .map((duration) => DropdownMenuItem(
                    value: duration,
                    child: Text(
                      '$duration hr',
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDuration = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),

            // Slot Display (Slot name with color)
            Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Slot - ${widget.slotNumber}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30),

            // Back and Submit Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to ParkingSlotsPage
                  },
                  child: Text('Back'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (validateTimeSelection()) {
                      // Add booking submission logic here
                      // e.g., save the booking details to the database or navigate to a success page
                      print("Booking confirmed: Slot ${widget.slotNumber}");
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Invalid Time Selection'),
                            content: Text(
                                'Please ensure that the end time is after the start time.'),
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
                  child: Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}