import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  var colors = [
    "0xff66ff00",
    "0xff1974d2",
    "0xff08e8de",
    "0xfffff000",
    "0xffffaa1d",
    "0xffff007f"
  ];
  void _submitAuthForm(String email, String username, String password,
      File image, bool isLogin) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user!.uid + '.jpg');
        await ref.putFile(image);
        final url = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'username': username,
          'email': email,
          'color': (colors..shuffle()).first,
          'image': url,
        });
      }
    } on FirebaseException catch (err) {
      setState(() {
        _isLoading = false;
      });
      var message = "An error occured, please check your credentials";
      if (err != null) {
        message = err.message.toString();
      }
      print(err);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      ));
    } catch (err) {
      print("hshshhahahhahahahhahhahahhahahhahahahhahahhahahhahaha\n\n\n\n\n");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(0xff57c3ad), Color(0xff007475)])),
            child: AuthForm(_submitAuthForm, _isLoading)));
  }
}
