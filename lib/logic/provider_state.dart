
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ProviderState extends ChangeNotifier{

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool isUpdate = false;
  File? file;
  int id = 0;
  bool isLoading = false;
  bool isLoadingDel = false;
  bool forView = false;
  bool noChange = true;
  int fileId =0;
  bool isLoggedIn = false;

  Future<void>update_isLoggedIn()async{
   User? user = await _firebaseAuth.currentUser;
   if(user!=null){
     isLoggedIn = true;
     notifyListeners();
   }else{
     isLoggedIn = false;
     notifyListeners();
   }
  }

  void update_isUpdate(bool value)async{
    isUpdate = value;
    notifyListeners();
  }

  void update_forView(bool value)async{
    forView = value;
    notifyListeners();
  }

 Future<void> updateFile()async{
   XFile? xfile = await ImagePicker().pickImage(source: ImageSource.camera);
   file=File(xfile!.path);
   notifyListeners();
 }

 void IncrementId(){
    id++;
    notifyListeners();
 }

  void DecrementId(){
    id--;
    notifyListeners();
  }

  void update_isLoading(bool value){
    isLoading = value;
    notifyListeners();
  }

  void update_isLoadingDel(bool value){
    isLoadingDel = value;
    notifyListeners();
  }

  void update_fileId(){
    fileId++;
    notifyListeners();
  }


}