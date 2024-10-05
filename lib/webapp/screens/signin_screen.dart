import 'package:eco_web/webapp/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart'; // Import the HomeScreen

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _obscurePassword = true;

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Check user details in Firestore
      final querySnapshot = await FirebaseFirestore.instance
          .collection('admin')
          .where('email', isEqualTo: _email)
          .where('password',
              isEqualTo: _password) // Verify hashed passwords in production
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Navigate to HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid email or password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 300,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset('assets/images/ecologo.png',
                      height: 200), // Logo image
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter your email' : null,
                    onSaved: (value) => _email = value!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons
                                  .visibility, // Change icon based on visibility
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword =
                                !_obscurePassword; // Toggle password visibility
                          });
                        },
                      ),
                    ),
                    obscureText:
                        _obscurePassword, // Hide or show the password based on state
                    validator: (value) =>
                        value!.isEmpty ? 'Enter your password' : null,
                    onSaved: (value) => _password = value!,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _signIn,
                    child: Text('Sign In'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to Sign Up page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: Text('Don\'t have an account? Sign Up'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
