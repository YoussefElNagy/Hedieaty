import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedeyeti/components/(auth)/AuthenticationVM.dart';
import 'package:hedeyeti/components/(auth)/LoginScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;

  Future<void> _signup() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final username = _usernameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();
      final phone = _phoneController.text.trim();


      AuthenticationViewModel().signUp(email:email,password:password,username:username,phone:phone,gender:gender);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      ).then((_) {
        // Clear the form fields after successful signup
        _usernameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
        _phoneController.clear();
      });
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      print(e.code);
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already in use. Try logging in.';
          break;
        case 'weak-password':
          errorMessage = 'Password should be at least 6 characters.';
          break;
        case 'invalid-email':
          errorMessage = 'Please enter a valid email address.';
          break;
        default:
          errorMessage = 'An unexpected error occurred. Please try again.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred: $e'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  String gender = 'male';

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment
                  .stretch, // Ensures children fill available width
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.1), // Adds top spacing
                Text(
                  "Welcome to Hedeiaty!",
                  style: theme.textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  "Create your account now!",
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.name,
                        autocorrect: false,
                        validator: (x) {
                          if (x == null || x.isEmpty) {
                            return 'Please enter your username';
                          }
                          final regex = RegExp(r'^[a-zA-Z0-9_-]+$');
                          if (!regex.hasMatch(x)) {
                            return 'Enter valid characters.';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        autocorrect: false,
                        validator: (x) {
                          if (x == null || x.isEmpty) {
                            return 'Please enter your phone';
                          }

                          if(x.length<11){
                            return 'Enter a valid phone number';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: "Gender"),
                        value: gender,
                        items: [
                          DropdownMenuItem(value: 'male', child: Text("Male")),
                          DropdownMenuItem(value: 'female', child: Text("Female")),
                        ],
                        onChanged: (value) => setState(() => gender = value!),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        validator: (x) {
                          if (x == null || x.isEmpty) {
                            return 'Please enter your email';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        autocorrect: false,
                        validator: (x) {
                          if (x == null || x.isEmpty) {
                            return 'Please enter your password';
                          } else if (x.length < 6) {
                            return 'Password must be at least 6 characters';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: const InputDecoration(
                          labelText: 'Confirm password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        autocorrect: false,
                        validator: (x) {
                          if (x == null || x.isEmpty) {
                            return 'Please enter your password';
                          } else if (x.length < 6) {
                            return 'Password must be at least 6 characters';
                          } else if (x != _passwordController.text) {
                            return 'Both passwords must match';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 30),
                      _isLoading
                          ? Center(child: const CircularProgressIndicator())
                          : AbsorbPointer(
                              absorbing: _isLoading,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme
                                      .primary, // Directly set the color
                                ),
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    _signup();
                                  }
                                },
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme
                                        .onPrimary, // Text color matching button background
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?"),
                          TextButton(
                            child: Text(
                              "Sign in now!",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              ).then((_) {
                                setState(() {
                                  _isLoading = false;
                                });
                              });
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.1), // Adds bottom spacing
              ],
            ),
          ),
        ),
      ),
    );
  }
}
