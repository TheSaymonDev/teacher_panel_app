import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddClassController extends GetxController{
  final classNameController = TextEditingController();
  final classCodeController = TextEditingController();
  final numberOfStudentController = TextEditingController();
  final subjectController = TextEditingController();

  final subjects = <String>[];
  void addSubject(){
    if(subjectController.text.trim().isNotEmpty){
      subjects.add(subjectController.text);
      subjectController.clear();
      update();
    }
  }

  void removeSubject(int index){
    subjects.removeAt(index);
    update();
  }

}