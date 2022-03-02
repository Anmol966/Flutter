import 'package:flutter/material.dart';
import '../pickers/image_picker.dart';
import 'dart:io';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this._isLoading);
  final _isLoading;
  final void Function(String email, String username, String password,
      File image, bool isLogin) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  File? _userImageFile;
  var _isLogin = true;
  String _userEmail = '';
  String _username = '';
  String _userPassword = '';
  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState?.validate();
    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Please Pick the Image",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      ));
      return;
    }
    if (isValid != null && isValid) {
      _formKey.currentState?.save();
      widget.submitFn(_userEmail.trim(), _username.trim(), _userPassword.trim(),
          _userImageFile ?? File('a.jpeg'), _isLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 50,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isLogin) ImagePiccker(_pickedImage),
                TextFormField(
                  key: ValueKey('email'),
                  validator: (value) {
                    if (value != null) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please Enter a valid email adress.';
                      }
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email address'),
                  onSaved: (value) {
                    _userEmail = value ?? '';
                  },
                ),
                if (!_isLogin)
                  (TextFormField(
                      key: ValueKey('username'),
                      decoration: InputDecoration(labelText: 'Username'),
                      onSaved: (value) {
                        _username = value.toString();
                      },
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty || value.length < 3) {
                            return 'Username must be atleast 3 characters long';
                          }
                        }
                        return null;
                      })),
                TextFormField(
                  key: ValueKey('password'),
                  validator: (value) {
                    if (value != null) {
                      if (value.isEmpty || value.length < 5) {
                        return 'Password must be atleast 5 characters long';
                      }
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onSaved: (value) {
                    _userPassword = value.toString();
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                if (widget._isLoading)
                  Container(
                      padding: EdgeInsets.all(30),
                      child: CircularProgressIndicator()),
                if (!widget._isLoading)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(100, 40), elevation: 6),
                    onPressed: () {
                      _trySubmit();
                    },
                    child: Text(
                      _isLogin ? 'Login' : 'Signup',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                if (!widget._isLoading)
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create New Account'
                          : 'I already have an account'))
              ],
            ),
          ),
        )),
      ),
    );
  }
}
