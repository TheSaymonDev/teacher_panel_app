import 'package:get/get.dart';
import 'package:teacher_panel/data/models/teacher_model.dart';
import 'package:teacher_panel/data/services/firebase_service.dart';

class TeacherInfoController extends GetxController {
  TeacherModel teacherData = TeacherModel.defaultData();
  final _firebaseService = FirebaseService();

  @override
  void onInit() {
    super.onInit();
    _fetchTeacherInfo();
  }

  Future<void> _fetchTeacherInfo() async {
    final response = await _firebaseService.readTeacherInfo(
    );

    if (response['success'] == true) {
      final snapshot = response['data'];
      final docs = snapshot.docs;

      if (docs.isNotEmpty) {
        final doc = docs.first;
        teacherData = TeacherModel.fromFireStore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
        update();
      }
    }

  }
}
