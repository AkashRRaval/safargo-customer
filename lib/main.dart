import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SafarGoCustomerApp());
}

class SafarGoCustomerApp extends StatelessWidget {
  const SafarGoCustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafarGo Customer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const PhoneAuthScreen(),
    );
  }
}

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _verificationId;
  bool _codeSent = false;
  bool _isLoading = false;

  void _verifyPhoneNumber() async {
    setState(() => _isLoading = true);
    await _auth.verifyPhoneNumber(
      phoneNumber: '+91${_phoneController.text.trim()}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        _showSnackBar('Authentication Successful!');
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() => _isLoading = false);
        _showSnackBar('Verification Failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _codeSent = true;
          _isLoading = false;
        });
        _showSnackBar('OTP Sent Successfully!');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void _signInWithOTP() async {
    if (_verificationId == null) return;
    setState(() => _isLoading = true);

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _otpController.text.trim(),
      );
      await _auth.signInWithCredential(credential);
      setState(() => _isLoading = false);
      _showSnackBar('Login Successful!');
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Invalid OTP. Please try again.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SafarGo - Customer Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!_codeSent) ...[
                    const Text(
                      'Enter your Phone Number',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Phone Number',
                        prefixText: '+91 ',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _verifyPhoneNumber,
                      child: const Text('Send OTP'),
                    ),
                  ] else ...[
                    const Text(
                      'Enter the 6-digit OTP',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'OTP Code',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _signInWithOTP,
                      child: const Text('Verify & Login'),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}

