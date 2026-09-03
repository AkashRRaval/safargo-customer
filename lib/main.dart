import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const SafarGoDriverApp());
}

class SafarGoDriverApp extends StatelessWidget {
  const SafarGoDriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafarGo Driver',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5), // Blue theme for Driver App
          primary: const Color(0xFF1E88E5),
          secondary: const Color(0xFF212121),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E88E5),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const DriverHomeScreen(),
    );
  }
}

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  bool _isOnline = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SafarGo Partner', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Switch(
            value: _isOnline,
            activeColor: Colors.white,
            activeTrackColor: Colors.greenAccent,
            onChanged: (value) {
              setState(() {
                _isOnline = value;
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Status Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: _isOnline ? Colors.green.shade100 : Colors.red.shade100,
            child: Text(
              _isOnline ? '🟢 YOU ARE ONLINE - Waiting for rides' : '🔴 YOU ARE OFFLINE - Go online to get rides',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _isOnline ? Colors.green.shade800 : Colors.red.shade800,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: _isOnline
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(color: Color(0xFF1E88E5)),
                        SizedBox(height: 16),
                        Text('Searching for nearby passengers...', style: TextStyle(color: Colors.grey)),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.power_settings_new_rounded, size: 72, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Toggle switch above to start earning', style: TextStyle(color: Colors.grey, fontSize: 16)),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
