import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';


Future<String> uploadImageToFirebase(BuildContext context, File imageFile) async {
  String fileName = basename(imageFile.path);
  Reference firebaseStorageRef =
  FirebaseStorage.instance.ref().child('uploads/$fileName');
  UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
  TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
  // taskSnapshot.ref.getDownloadURL().then(
  //       (value){
  //         return value;
  //       },
  // );
  String imageUrl = await taskSnapshot.ref.getDownloadURL();
  return imageUrl;
}

Future<String> uploadVoiceToFirebase(BuildContext context, File voiceFile)async{
  String fileName = basename(voiceFile.path);
  Reference firebaseStorageRef =
  FirebaseStorage.instance.ref().child('audios/$fileName');
  UploadTask uploadTask = firebaseStorageRef.putFile(voiceFile);
  TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
  String voiceUrl = await taskSnapshot.ref.getDownloadURL();

  print("dsaklfklsda;fds ${voiceUrl}");
  return voiceUrl;
}