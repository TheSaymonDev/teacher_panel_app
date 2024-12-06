import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/screens/subject_details_screen/controllers/subject_controller.dart';

class SubjectDetailsScreen extends StatelessWidget {
  final String subjectName;
  final String className;

  SubjectDetailsScreen({
    required this.subjectName,
    required this.className,
  });

  final SubjectDetailsController _controller = Get.put(SubjectDetailsController());

  @override
  Widget build(BuildContext context) {
    // Set initial subject name in the controller
    _controller.subjectName = subjectName;

    return Scaffold(
      appBar: AppBar(
        title: Text("$subjectName Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject Header
            Text(
              subjectName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Class: $className",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            GetBuilder<SubjectDetailsController>(
              builder: (controller) => Text(
                "Total Quizzes: ${controller.quizzes.length}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            // Add Quiz Button
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to Add Quiz Screen
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Quiz"),
            ),
            const SizedBox(height: 16),

            // Quiz List
            const Text(
              "Quizzes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Quiz List with GetBuilder
            Expanded(
              child: GetBuilder<SubjectDetailsController>(
                builder: (controller) => controller.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  itemCount: controller.quizzes.length,
                  itemBuilder: (context, index) {
                    final quiz = controller.quizzes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(quiz['quizName'] as String),
                        subtitle: Text(
                            "Date: ${quiz['date']}\nStudents: ${quiz['studentsParticipated']}"),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Avg: ${quiz['averageScore']}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            ElevatedButton(
                              onPressed: () {
                                // Navigate to Quiz Details
                              },
                              child: const Text("View"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
