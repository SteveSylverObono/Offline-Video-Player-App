import 'package:flutter/material.dart';
import 'package:player/constants.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final List<Map<String, dynamic>> services = [
    {
      'icon': Icons.mosque,
      'title': 'Find Nearest Mosque',
      'color': primaryColor,
      'description': 'Locate the closest mosque to your current location'
    },
    {
      'icon': Icons.access_time,
      'title': 'Prayer Times',
      'color': Colors.green,
      'description': 'Get accurate prayer times for your location'
    },
    {
      'icon': Icons.explore,
      'title': 'Qibla Direction',
      'color': Colors.orange,
      'description': 'Find the direction of the Kaaba for prayer'
    },
    {
      'icon': Icons.people,
      'title': 'Community Help',
      'color': Colors.purple,
      'description': 'Connect with local Muslim community'
    },
    {
      'icon': Icons.book,
      'title': 'Quran Guidance',
      'color': Colors.blue,
      'description': 'Get help with Quran reading and understanding'
    },
    {
      'icon': Icons.help,
      'title': 'Islamic Questions',
      'color': Colors.teal,
      'description': 'Ask questions about Islamic practices'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Player Assistant"),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "How can I help with your video experience today?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildServicesGrid(),
            const SizedBox(height: 20),
            _buildQuickHelpSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle assistant button press
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.video_library, color: Colors.white),
      ),
    );
  }

  Widget _buildServicesGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 1.2,
        ),
        itemCount: services.length,
        itemBuilder: (context, index) {
          return _buildServiceCard(services[index]);
        },
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          // Handle service tap
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                service['icon'],
                size: 40,
                color: service['color'],
              ),
              const SizedBox(height: 10),
              Flexible(
                child: Text(
                  service['title'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 5),
              Flexible(
                child: Text(
                  service['description'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickHelpSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Video Player Tips",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                _buildHelpItem(
                  icon: Icons.play_circle_outline,
                  title: "How to play a video?",
                  onTap: () {},
                ),
                const Divider(),
                _buildHelpItem(
                  icon: Icons.pause_circle_outline,
                  title: "How to pause a video?",
                  onTap: () {},
                ),
                const Divider(),
                _buildHelpItem(
                  icon: Icons.settings,
                  title: "How to adjust video settings?",
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: primaryColor),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}