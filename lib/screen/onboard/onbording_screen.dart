import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:player/routes/app_router.dart';

import '../../constants.dart';

@RoutePage(name: 'OnboardingScreenRoute')
class OnBordingScreen extends StatefulWidget {
  const OnBordingScreen({super.key});

  @override
  State<OnBordingScreen> createState() => _OnBordingScreenState();
}

class _OnBordingScreenState extends State<OnBordingScreen> {
  late PageController _pageController;
  int _pageIndex = 0;
  final List<Onbord> _onbordData = [
    Onbord(
      icon: Icons.ondemand_video,
      title: "Explore Videos",
      description: "Discover a wide range of videos tailored to your interests.",
      color: Colors.red[800]!,
    ),
    Onbord(
      icon: Icons.star_rate,
      title: "Premium Content",
      description: "Get access to exclusive videos and premium channels.",
      color: Colors.blue[800]!,
    ),
    Onbord(
      icon: Icons.cloud_download,
      title: "Watch Offline",
      description: "Save videos offline to watch anytime, anywhere.",
      color: Colors.green[800]!,
    ),
    Onbord(
      icon: Icons.settings,
      title: "Customize Experience",
      description: "Adjust playback settings for an optimized viewing experience.",
      color: Colors.purple[800]!,
    ),
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildPageItem(int index) {
    return Container(
      padding: EdgeInsets.all(20),
      color: _onbordData[index].color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_onbordData[index].icon, size: 80, color: Colors.white),
          SizedBox(height: 30),
          Text(
            _onbordData[index].title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
          Text(
            _onbordData[index].description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          itemCount: _onbordData.length,
          onPageChanged: (int index) {
            setState(() {
              _pageIndex = index;
            });
          },
          itemBuilder: (context, index) => _buildPageItem(index),
        ),
      ),
      bottomSheet: _pageIndex == _onbordData.length - 1
          ? TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                backgroundColor: Colors.blue[800],
              ),
              onPressed: () {
                AutoRouter.of(context).push(EntryPointRoute());
              },
              child: Text(
                "Get Started",
                style: TextStyle(fontSize: 20),
              ),
            )
          : Container(
              height: 60,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      _pageController.jumpToPage(_onbordData.length - 1);
                    },
                    child: Text("SKIP", style: TextStyle(color: Colors.white)),
                  ),
                  Row(
                    children: List.generate(
                      _onbordData.length,
                      (index) => _buildIndicator(index == _pageIndex),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                    child: Text("NEXT", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 8,
      width: isActive ? 20 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class Onbord {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  Onbord({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}