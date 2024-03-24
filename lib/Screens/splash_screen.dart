import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatHub'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Loading',
                style: TextStyle(
                  fontSize: 20,
                )),
            JumpingDots(
              color: Colors.yellow,
              radius: 10,
              numberOfDots: 3,
              animationDuration: const Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
    );
  }
}
