import 'package:flutter/material.dart';
import '../models/onboarding_item.dart';
import '../widgets/onboarding_content.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<OnboardingItem> _items = [
    OnboardingItem(
      image: 'assets/images/onboarding1.png',
      title: 'Manage your tasks',
      description:
          'You can easily manage all of your daily tasks in DoMe for free',
    ),
    OnboardingItem(
      image: 'assets/images/onboarding2.png',
      title: 'Create daily routine',
      description:
          'In UptoDo you can create your personalized routine to stay productive',
    ),
    OnboardingItem(
      image: 'assets/images/onboarding3.png',
      title: 'Organize your tasks',
      description:
          'You can organize your daily tasks by adding your tasks into separate categories',
    ),
  ];

  void _nextPage() {
    if (_currentIndex < _items.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return OnboardingContent(
                    image: _items[index].image,
                    title: _items[index].title,
                    description: _items[index].description,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _currentIndex > 0
                      ? TextButton(
                        onPressed: () {
                          _controller.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text(
                          "BACK",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                      : const SizedBox(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: _nextPage,
                    child: Text(
                      _currentIndex == _items.length - 1
                          ? "GET STARTED"
                          : "NEXT",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
