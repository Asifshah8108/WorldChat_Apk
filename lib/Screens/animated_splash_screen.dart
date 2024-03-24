import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat/Screens/auth.dart';
import 'package:chat/Screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({Key? key}) : super(key: key);

  @override
  _AnimatedSplashScreenState createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Adjust the duration as needed
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToNextScreen();
      }
    });
  }

  void _navigateToNextScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingScreen();
            }
            if (snapshot.hasData) {
              return const ChatScreen();
            }
            return const AuthScreen();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return CircularProgressIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Center(
            child: Opacity(
              opacity: _animation.value,
              child: child,
            ),
          );
        },
        child:FaIcon(
          FontAwesomeIcons.earthAfrica,
          size: 100,
          color: Theme.of(context).colorScheme.primary,
        )
        // Image.asset(
        // 'assets/icon/icon.png', // Replace with the correct path
        // width: 200.0,  // Replace with your logo or widget
      // ),
      )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
