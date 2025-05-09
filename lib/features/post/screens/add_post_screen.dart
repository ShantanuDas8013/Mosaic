import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigateToType(BuildContext context, String type) {
    Routemaster.of(context).push('/add-post/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    // Calculate bottom padding to avoid overflow with navigation bar
    final bottomPadding = MediaQuery.of(context).padding.bottom + 70;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Post',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      backgroundColor:
          isDarkMode ? const Color(0xFF121212) : Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          // Add padding at the bottom to prevent overflow
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info card at the top
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.white.withAlpha(240),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Choose the type of post you want to create',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Post type options with adjusted aspect ratio
                GridView.count(
                  crossAxisCount: 2, // 2 cards per row
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0, // Increased spacing between rows
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 0.85, // Adjusted to provide proper height
                  children: [
                    // Image Post Card
                    _buildPostTypeCard(
                      context: context,
                      icon: Icons.image_outlined,
                      title: 'Image Post',
                      description: 'Share photos, screenshots, or artwork',
                      onTap: () => navigateToType(context, 'image'),
                      isDarkMode: isDarkMode,
                    ),

                    // Text Post Card
                    _buildPostTypeCard(
                      context: context,
                      icon: Icons.text_snippet_outlined,
                      title: 'Text Post',
                      description: 'Share your thoughts or ask questions',
                      onTap: () => navigateToType(context, 'text'),
                      isDarkMode: isDarkMode,
                    ),

                    // Link Post Card
                    _buildPostTypeCard(
                      context: context,
                      icon: Icons.link,
                      title: 'Link Post',
                      description: 'Share URLs to interesting content',
                      onTap: () => navigateToType(context, 'link'),
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: isDarkMode ? const Color(0xFF212121) : Colors.white,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: isDarkMode ? Colors.white60 : Colors.grey.shade600,
        type: BottomNavigationBarType.fixed,
        elevation: 8.0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.post_add), label: 'Post'),
        ],
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  // Helper method to build consistent post type cards
  Widget _buildPostTypeCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Reduced padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 45, // Slightly reduced icon size
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12), // Reduced spacing
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 6), // Reduced spacing
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color:
                      isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
