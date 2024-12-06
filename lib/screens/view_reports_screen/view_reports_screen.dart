import 'package:flutter/material.dart';

class ViewReportsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> reportData = [
    {"name": "Rahim", "roll": "101", "marks": 90, "attendance": 95},
    {"name": "Karim", "roll": "102", "marks": 80, "attendance": 85},
    {"name": "Hasan", "roll": "103", "marks": 70, "attendance": 75},
  ];

  ViewReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Reports'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filters Section
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Select Class",
                      border: OutlineInputBorder(),
                    ),
                    items: ["Class 1", "Class 2", "Class 3"]
                        .map((className) => DropdownMenuItem(
                              value: className,
                              child: Text(className),
                            ))
                        .toList(),
                    onChanged: (value) {},
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Select Subject",
                      border: OutlineInputBorder(),
                    ),
                    items: ["Mathematics", "Science", "English"]
                        .map((subject) => DropdownMenuItem(
                              value: subject,
                              child: Text(subject),
                            ))
                        .toList(),
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Summary Card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Class Performance Summary",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Average Marks: 75%"),
                        Text("Top Student: Rahim"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Report List
            Expanded(
              child: ListView.builder(
                itemCount: reportData.length,
                itemBuilder: (context, index) {
                  final student = reportData[index];
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      title: Text(student["name"]),
                      subtitle: Text("Roll: ${student["roll"]}"),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Marks: ${student["marks"]}"),
                          Text("Attendance: ${student["attendance"]}%"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Export Options
            ElevatedButton.icon(
              onPressed: () {
                // Export logic
              },
              icon: Icon(Icons.download),
              label: Text("Export to PDF/Excel"),
            ),
          ],
        ),
      ),
    );
  }
}
