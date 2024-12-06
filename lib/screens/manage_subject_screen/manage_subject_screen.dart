import 'package:flutter/material.dart';

class ManageSubjectsScreen extends StatelessWidget {
  final List<String> subjects = ["Mathematics", "Science", "English"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Subjects'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add New Subject Button
            ElevatedButton.icon(
              onPressed: () {
                _showAddSubjectDialog(context);
              },
              icon: Icon(Icons.add),
              label: Text("Add New Subject"),
            ),
            SizedBox(height: 16),

            // Subject List
            Expanded(
              child: ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      title: Text(subjects[index]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _showEditSubjectDialog(context, subjects[index]);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _confirmDelete(context, subjects[index]);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSubjectDialog(BuildContext context) {
    final TextEditingController subjectController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add New Subject"),
        content: TextField(
          controller: subjectController,
          decoration: InputDecoration(
            hintText: "Enter Subject Name",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // Add subject logic
              Navigator.pop(context);
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  void _showEditSubjectDialog(BuildContext context, String currentSubject) {
    final TextEditingController subjectController =
    TextEditingController(text: currentSubject);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Subject"),
        content: TextField(
          controller: subjectController,
          decoration: InputDecoration(
            hintText: "Enter New Subject Name",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // Edit subject logic
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String subject) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Subject"),
        content: Text("Are you sure you want to delete '$subject'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // Delete subject logic
              Navigator.pop(context);
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }
}
