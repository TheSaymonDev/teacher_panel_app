import 'package:flutter/material.dart';

class ClassReportsAnalyticsScreen extends StatelessWidget {
  final String className;

  const ClassReportsAnalyticsScreen({super.key, required this.className});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$className - Reports & Analytics'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overall Performance Section
              _buildSectionTitle('Overall Performance'),
              _buildOverallPerformance(),

              SizedBox(height: 20),

              // Subject-wise Performance Section
              _buildSectionTitle('Subject-wise Performance'),
              _buildSubjectPerformance(),

              SizedBox(height: 20),

              // Exam Reports Section
              _buildSectionTitle('Exam Reports'),
              _buildExamReports(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildOverallPerformance() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Average Score'),
                Text(
                  '82%',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Best Performing Subject'),
                Text(
                  'Mathematics',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Lowest Performing Subject'),
                Text(
                  'History',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectPerformance() {
    final subjects = [
      {'name': 'Mathematics', 'average': '90%'},
      {'name': 'Science', 'average': '85%'},
      {'name': 'History', 'average': '78%'},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final subject = subjects[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(subject['name']!),
            trailing: Text(
              subject['average']!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              // Navigate to detailed subject report
            },
          ),
        );
      },
    );
  }

  Widget _buildExamReports() {
    final exams = [
      {'name': 'Midterm Exam', 'average': '84%'},
      {'name': 'Final Exam', 'average': '88%'},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: exams.length,
      itemBuilder: (context, index) {
        final exam = exams[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(exam['name']!),
            trailing: Text(
              exam['average']!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              // Navigate to detailed exam report
            },
          ),
        );
      },
    );
  }
}
